import 'package:collection/collection.dart';

import '../models/game_config.dart';
import '../models/player_action.dart';
import '../models/player_state.dart';
import '../models/round_stage.dart';
import '../models/playing_card.dart';

/// 牌桌整体状态，包含当前局面的所有关键数据。
class GameTableState {
  const GameTableState({
    required this.config,
    required this.stage,
    required this.players,
    required this.potAmount,
    required this.currentBet,
    required this.dealerIndex,
    required this.activePlayerIndex,
    required this.roundIndex,
    required this.actions,
    required this.remainingDeck,
    this.lastActionAt,
  });

  /// 当前牌桌配置。
  final GameConfig config;

  /// 当前局阶段。
  final RoundStage stage;

  /// 所有座位状态，按座位顺序排序。
  final List<PlayerState> players;

  /// 底池总额。
  final int potAmount;

  /// 当前需要跟注的金额（未看牌前的基准值）。
  final int currentBet;

  /// 庄家所在的索引，用于确定发牌顺序。
  final int dealerIndex;

  /// 轮到行动的玩家索引。
  final int activePlayerIndex;

  /// 第几局牌，从 1 开始计数。
  final int roundIndex;

  /// 行动记录列表。
  final List<PlayerAction> actions;

  /// 牌堆剩余的牌面，索引尾部视为牌顶。
  final List<PlayingCard> remainingDeck;

  /// 上一次行动发生时间，用于倒计时。
  final DateTime? lastActionAt;

  /// 获取当前行动的玩家状态。
  PlayerState get activePlayer => players[activePlayerIndex];

  /// 返回仍未弃牌的玩家集合。
  List<PlayerState> get alivePlayers =>
      players.where((PlayerState p) => p.isInRound).toList(growable: false);

  /// 判断是否满足摊牌条件（只剩一人或阶段进入 showdown）。
  bool get shouldEnterShowdown =>
      alivePlayers.length <= 1 || stage == RoundStage.showdown;

  /// 创建新的状态实例。
  GameTableState copyWith({
    GameConfig? config,
    RoundStage? stage,
    List<PlayerState>? players,
    int? potAmount,
    int? currentBet,
    int? dealerIndex,
    int? activePlayerIndex,
    int? roundIndex,
    List<PlayerAction>? actions,
    List<PlayingCard>? remainingDeck,
    DateTime? lastActionAt,
  }) {
    return GameTableState(
      config: config ?? this.config,
      stage: stage ?? this.stage,
      players: players ?? this.players,
      potAmount: potAmount ?? this.potAmount,
      currentBet: currentBet ?? this.currentBet,
      dealerIndex: dealerIndex ?? this.dealerIndex,
      activePlayerIndex: activePlayerIndex ?? this.activePlayerIndex,
      roundIndex: roundIndex ?? this.roundIndex,
      actions: actions ?? this.actions,
      remainingDeck: remainingDeck ?? this.remainingDeck,
      lastActionAt: lastActionAt ?? this.lastActionAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameTableState &&
          other.config == config &&
          other.stage == stage &&
          other.potAmount == potAmount &&
          other.currentBet == currentBet &&
          other.dealerIndex == dealerIndex &&
          other.activePlayerIndex == activePlayerIndex &&
          other.roundIndex == roundIndex &&
          other.lastActionAt == lastActionAt &&
          const ListEquality<PlayerState>().equals(other.players, players) &&
          const ListEquality<PlayerAction>().equals(other.actions, actions) &&
          const ListEquality<PlayingCard>()
              .equals(other.remainingDeck, remainingDeck);

  @override
  int get hashCode => Object.hash(
        config,
        stage,
        potAmount,
        currentBet,
        dealerIndex,
        activePlayerIndex,
        roundIndex,
        lastActionAt,
        Object.hashAll(players),
        Object.hashAll(actions),
        Object.hashAll(remainingDeck),
      );
}
