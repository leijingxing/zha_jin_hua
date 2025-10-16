import 'dart:math';

import '../deck/card_deck.dart';
import '../logic/hand_evaluator.dart';
import '../models/game_config.dart';
import '../models/player_action.dart';
import '../models/player_action_type.dart';
import '../models/player_round_status.dart';
import '../models/player_state.dart';
import '../models/playing_card.dart';
import '../models/round_stage.dart';
import '../models/hand_rank.dart';
import '../state/game_table_state.dart';

/// 核心牌局引擎，负责管理发牌、下注与阶段切换。
class GameEngine {
  GameEngine({
    GameConfig? config,
    Random? random,
    DateTime Function()? now,
  })  : config = config ?? GameConfig.standard(),
        _random = random ?? Random.secure(),
        _now = now ?? DateTime.now;

  /// 当前牌桌配置。
  final GameConfig config;

  final Random _random;
  final DateTime Function() _now;

  /// 根据座位信息初始化牌桌状态。
  GameTableState initializeTable(List<PlayerState> seats) {
    if (seats.length < config.minPlayers) {
      throw StateError('牌桌人数不足，无法初始化');
    }
    if (seats.length > config.maxPlayers) {
      throw StateError('超出最大座位数限制');
    }

    return GameTableState(
      config: config,
      stage: RoundStage.waitingPlayers,
      players: seats,
      potAmount: 0,
      currentBet: config.baseBet,
      dealerIndex: 0,
      activePlayerIndex: 0,
      roundIndex: 0,
      actions: <PlayerAction>[],
      remainingDeck: const <PlayingCard>[],
      lastActionAt: null,
    );
  }

  /// 启动新一局牌，收集底注并发牌。
  GameTableState startNewRound(GameTableState state) {
    final int readyPlayers =
        state.players.where((PlayerState p) => p.stack >= config.ante).length;
    if (readyPlayers < config.minPlayers) {
      throw StateError('可参与的玩家数量不足，无法开局');
    }

    final CardDeck deck = CardDeck.shuffled(_random);
    final List<PlayerState> updatedPlayers = <PlayerState>[];
    final List<PlayerAction> newActions = List<PlayerAction>.from(state.actions);

    int pot = 0;

    for (final PlayerState player in state.players) {
      if (player.stack < config.ante) {
        updatedPlayers.add(
          player.copyWith(
            hand: const <PlayingCard>[],
            chipsInPot: 0,
            hasSeenCards: false,
            roundStatus: PlayerRoundStatus.eliminated,
          ),
        );
        continue;
      }

      final int newStack = player.stack - config.ante;
      pot += config.ante;
      final PlayerState refreshed = player.copyWith(
        stack: newStack,
        hand: deck.draw(3),
        chipsInPot: config.ante,
        hasSeenCards: false,
        roundStatus: PlayerRoundStatus.active,
      );
      updatedPlayers.add(refreshed);
      newActions.add(
        PlayerAction(
          playerId: player.id,
          type: PlayerActionType.ante,
          amount: config.ante,
          createdAt: _now(),
        ),
      );
    }

    final int dealer =
        _nextOccupiedIndex(updatedPlayers, (state.dealerIndex + 1) % updatedPlayers.length);
    final int firstActor = _nextActiveIndex(updatedPlayers, dealer);

    return state.copyWith(
      stage: RoundStage.betting,
      players: updatedPlayers,
      potAmount: pot,
      currentBet: config.baseBet,
      dealerIndex: dealer,
      activePlayerIndex: firstActor,
      roundIndex: state.roundIndex + 1,
      actions: newActions,
      remainingDeck: deck.snapshot(),
      lastActionAt: _now(),
    );
  }

  /// 处理玩家的行动并推进局面。
  GameTableState applyAction(GameTableState state, PlayerAction request) {
    final PlayerState actor = state.activePlayer;
    if (actor.id != request.playerId) {
      throw StateError('未轮到该玩家行动');
    }

    switch (request.type) {
      case PlayerActionType.call:
        return _handleCall(state, actor);
      case PlayerActionType.raise:
        return _handleRaise(state, actor, request.amount);
      case PlayerActionType.fold:
        return _handleFold(state, actor);
      case PlayerActionType.see:
        return _handleSee(state, actor);
      case PlayerActionType.compare:
        if (request.targetPlayerId == null) {
          throw ArgumentError('比牌必须指定目标玩家');
        }
        return _handleCompare(state, actor, request.targetPlayerId!);
      case PlayerActionType.ante:
        throw StateError('底注收取仅限系统操作');
      case PlayerActionType.allIn:
        return _handleAllIn(state, actor);
    }
  }

  /// 统一判断玩家是否仍然可以继续行动。
  bool _canAct(PlayerState player) =>
      player.roundStatus == PlayerRoundStatus.active && player.stack > 0;

  GameTableState _handleCall(GameTableState state, PlayerState actor) {
    final int target = _expectedContribution(state.currentBet, actor.hasSeenCards);
    final int required = target - actor.chipsInPot;
    final int delta =
        required <= 0 ? 0 : min(required, actor.stack);
    final bool isAllIn = delta == actor.stack;

    final PlayerState updated = actor.copyWith(
      stack: actor.stack - delta,
      chipsInPot: actor.chipsInPot + delta,
      roundStatus: isAllIn ? PlayerRoundStatus.allIn : actor.roundStatus,
    );

    return _advanceState(
      state: state,
      updatedPlayer: updated,
      paidAmount: delta,
      actionType: PlayerActionType.call,
    );
  }

  GameTableState _handleRaise(GameTableState state, PlayerState actor, int newBaseBet) {
    if (newBaseBet <= state.currentBet) {
      throw ArgumentError('加注金额必须大于当前注额');
    }
    if (newBaseBet - state.currentBet < config.raiseStep) {
      throw ArgumentError('加注幅度至少应为最小阶梯：${config.raiseStep}');
    }

    final int target = _expectedContribution(newBaseBet, actor.hasSeenCards);
    final int required = target - actor.chipsInPot;
    final int delta =
        required <= 0 ? 0 : min(required, actor.stack);
    final bool isAllIn = delta == actor.stack;

    final PlayerState updated = actor.copyWith(
      stack: actor.stack - delta,
      chipsInPot: actor.chipsInPot + delta,
      roundStatus: isAllIn ? PlayerRoundStatus.allIn : PlayerRoundStatus.active,
    );

    return _advanceState(
      state: state,
      updatedPlayer: updated,
      paidAmount: delta,
      actionType: PlayerActionType.raise,
      newBaseBet: newBaseBet,
    );
  }

  GameTableState _handleFold(GameTableState state, PlayerState actor) {
    final PlayerState updated =
        actor.copyWith(roundStatus: PlayerRoundStatus.folded, hand: const <PlayingCard>[]);

    return _advanceState(
      state: state,
      updatedPlayer: updated,
      paidAmount: 0,
      actionType: PlayerActionType.fold,
    );
  }

  GameTableState _handleSee(GameTableState state, PlayerState actor) {
    if (actor.hasSeenCards) {
      throw StateError('玩家已看过牌');
    }
    final PlayerState updated = actor.copyWith(hasSeenCards: true);
    return _advanceState(
      state: state,
      updatedPlayer: updated,
      paidAmount: 0,
      actionType: PlayerActionType.see,
      preserveTurn: true,
    );
  }

  GameTableState _handleCompare(
    GameTableState state,
    PlayerState actor,
    String targetPlayerId,
  ) {
    final PlayerState target = state.players.firstWhere(
      (PlayerState p) => p.id == targetPlayerId,
      orElse: () => throw StateError('目标玩家不存在'),
    );

    if (!target.shouldShowdown) {
      throw StateError('目标玩家已弃牌或淘汰，无法比牌');
    }
    if (target.roundStatus == PlayerRoundStatus.allIn) {
      throw StateError('对手已全压，无法发起比牌');
    }

    final int stake = config.compareStake;
    if (actor.stack < stake) {
      throw StateError('筹码不足以发起比牌');
    }
    if (target.stack < stake && target.roundStatus != PlayerRoundStatus.allIn) {
      throw StateError('对手筹码不足以参与比牌');
    }

    final HandRank actorRank = HandEvaluator.evaluate(actor.hand);
    final HandRank targetRank = HandEvaluator.evaluate(target.hand);
    final bool actorWins = actorRank.compareTo(targetRank) > 0;

    final PlayerState updatedActor = actor.copyWith(
      stack: actor.stack - stake,
      chipsInPot: actor.chipsInPot + stake,
    );

    final PlayerState updatedTarget = target.copyWith(
      stack: target.stack - stake,
      chipsInPot: target.chipsInPot + stake,
    );

    final List<PlayerState> players = List<PlayerState>.from(state.players);
    final int actorIndex = players.indexWhere((PlayerState p) => p.id == actor.id);
    final int targetIndex = players.indexWhere((PlayerState p) => p.id == target.id);
    players[actorIndex] = updatedActor;
    players[targetIndex] = updatedTarget.copyWith(
      roundStatus: actorWins ? PlayerRoundStatus.folded : target.roundStatus,
      hand: actorWins ? const <PlayingCard>[] : updatedTarget.hand,
    );

    final PlayerState resolvedActor = actorWins
        ? updatedActor.copyWith(roundStatus: PlayerRoundStatus.active)
        : updatedActor.copyWith(roundStatus: PlayerRoundStatus.folded, hand: const <PlayingCard>[]);

    players[actorIndex] = resolvedActor;
    final int potIncrease = stake * 2;

    return _finalizeAfterAction(
      state: state.copyWith(players: players),
      paidAmount: potIncrease,
      action: PlayerAction(
        playerId: actor.id,
        type: PlayerActionType.compare,
        amount: potIncrease,
        targetPlayerId: target.id,
        createdAt: _now(),
      ),
    );
  }

  GameTableState _handleAllIn(GameTableState state, PlayerState actor) {
    if (actor.stack <= 0) {
      throw StateError('玩家没有可用筹码');
    }
    final int newBase = state.currentBet;
    final PlayerState updated = actor.copyWith(
      chipsInPot: actor.chipsInPot + actor.stack,
      stack: 0,
      roundStatus: PlayerRoundStatus.allIn,
    );
    return _advanceState(
      state: state,
      updatedPlayer: updated,
      paidAmount: actor.stack,
      actionType: PlayerActionType.allIn,
      newBaseBet: newBase,
    );
  }

  GameTableState _advanceState({
    required GameTableState state,
    required PlayerState updatedPlayer,
    required int paidAmount,
    required PlayerActionType actionType,
    int? newBaseBet,
    bool preserveTurn = false,
  }) {
    final List<PlayerState> players = List<PlayerState>.from(state.players);
    final int actorIndex = state.activePlayerIndex;
    players[actorIndex] = updatedPlayer;

    final GameTableState updatedState = state.copyWith(
      players: players,
      potAmount: state.potAmount + paidAmount,
      currentBet: newBaseBet ?? state.currentBet,
      actions: List<PlayerAction>.from(state.actions)
        ..add(
          PlayerAction(
            playerId: updatedPlayer.id,
            type: actionType,
            amount: paidAmount,
            createdAt: _now(),
          ),
        ),
      lastActionAt: _now(),
    );

    return _finalizeAfterAction(
      state: updatedState,
      paidAmount: 0,
      action: null,
      preserveTurn: preserveTurn,
    );
  }

  GameTableState _finalizeAfterAction({
    required GameTableState state,
    required int paidAmount,
    PlayerAction? action,
    bool preserveTurn = false,
  }) {
    GameTableState workingState = state;
    if (action != null) {
      workingState = workingState.copyWith(
        potAmount: workingState.potAmount + paidAmount,
        actions: List<PlayerAction>.from(workingState.actions)..add(action),
        lastActionAt: _now(),
      );
    }

    final List<PlayerState> alive = workingState.alivePlayers;
    if (alive.length <= 1) {
      return workingState.copyWith(stage: RoundStage.showdown);
    }

    if (!preserveTurn) {
      final int nextIndex = _nextActiveIndex(
        workingState.players,
        workingState.activePlayerIndex,
      );
      return workingState.copyWith(activePlayerIndex: nextIndex);
    }

    return workingState;
  }

  int _nextOccupiedIndex(List<PlayerState> players, int start) {
    for (int i = 0; i < players.length; i++) {
      final int index = (start + i) % players.length;
      if (players[index].roundStatus != PlayerRoundStatus.eliminated) {
        return index;
      }
    }
    return start;
  }

  int _nextActiveIndex(List<PlayerState> players, int start) {
    for (int offset = 1; offset <= players.length; offset++) {
      final int index = (start + offset) % players.length;
      if (_canAct(players[index])) {
        return index;
      }
    }
    return start;
  }

  int _expectedContribution(int baseBet, bool hasSeen) {
    final int multiplier = hasSeen ? config.seeCardMultiplier : 1;
    return baseBet * multiplier;
  }

  /// 结算底池并恢复到等待阶段。
  GameTableState settle(GameTableState state) {
    if (state.stage != RoundStage.showdown) {
      throw StateError('当前未到摊牌阶段，无法结算');
    }

    final List<PlayerState> contestants =
        state.players.where((PlayerState p) => p.shouldShowdown).toList();

    List<PlayerState> winners;
    if (contestants.isEmpty) {
      final List<PlayerState> survivors = state.players
          .where((PlayerState p) =>
              p.roundStatus != PlayerRoundStatus.folded &&
              p.roundStatus != PlayerRoundStatus.eliminated)
          .toList();
      if (survivors.isEmpty) {
        throw StateError('没有可结算的玩家');
      }
      winners = <PlayerState>[survivors.first];
    } else {
      winners = _determineWinners(contestants);
    }

    final Set<String> winnerIds = winners.map((PlayerState p) => p.id).toSet();
    final int totalPot = state.potAmount;
    final int baseShare = winners.isEmpty ? 0 : totalPot ~/ winners.length;
    int remainder = winners.isEmpty ? 0 : totalPot % winners.length;

    final List<PlayerState> updatedPlayers = <PlayerState>[];
    for (final PlayerState player in state.players) {
      int gain = 0;
      if (winnerIds.contains(player.id)) {
        gain = baseShare;
        if (remainder > 0) {
          gain += 1;
          remainder -= 1;
        }
      }
      final int newStack = player.stack + gain;
      final PlayerRoundStatus nextStatus =
          newStack <= 0 ? PlayerRoundStatus.eliminated : PlayerRoundStatus.waiting;
      updatedPlayers.add(
        player.copyWith(
          stack: newStack,
          chipsInPot: 0,
          hasSeenCards: false,
          hand: const <PlayingCard>[],
          roundStatus: nextStatus,
        ),
      );
    }

    final int nextDealer =
        _nextOccupiedIndex(updatedPlayers, (state.dealerIndex + 1) % updatedPlayers.length);

    return state.copyWith(
      stage: RoundStage.settlement,
      players: updatedPlayers,
      potAmount: 0,
      currentBet: config.baseBet,
      dealerIndex: nextDealer,
      activePlayerIndex: nextDealer,
      remainingDeck: const <PlayingCard>[],
      lastActionAt: _now(),
    );
  }

  List<PlayerState> _determineWinners(List<PlayerState> contestants) {
    final List<(PlayerState, HandRank)> evaluated = contestants
        .map(
          (PlayerState p) => (p, HandEvaluator.evaluate(p.hand)),
        )
        .toList();

    (PlayerState, HandRank) best = evaluated.first;
    final List<PlayerState> winners = <PlayerState>[best.$1];

    for (int i = 1; i < evaluated.length; i++) {
      final (PlayerState, HandRank) candidate = evaluated[i];
      final int diff = candidate.$2.compareTo(best.$2);
      if (diff > 0) {
        best = candidate;
        winners
          ..clear()
          ..add(candidate.$1);
      } else if (diff == 0) {
        winners.add(candidate.$1);
      }
    }
    return winners;
  }
}
