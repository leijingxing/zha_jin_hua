import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

import 'package:zha_jin_hua/modules/game/engine/game_engine.dart';
import 'package:zha_jin_hua/modules/game/models/game_config.dart';
import 'package:zha_jin_hua/modules/game/models/player_action.dart';
import 'package:zha_jin_hua/modules/game/models/player_action_type.dart';
import 'package:zha_jin_hua/modules/game/models/player_round_status.dart';
import 'package:zha_jin_hua/modules/game/models/player_state.dart';
import 'package:zha_jin_hua/modules/game/models/playing_card.dart';
import 'package:zha_jin_hua/modules/game/models/round_stage.dart';
import 'package:zha_jin_hua/modules/game/state/game_table_state.dart';

void main() {
  group('GameEngine', () {
    late GameEngine engine;
    late GameConfig config;

    setUp(() {
      config = GameConfig.standard();
      engine = GameEngine(
        config: config,
        random: Random(42),
        now: () => DateTime(2025, 1, 1, 12, 0, 0),
      );
    });

    GameTableState createInitialTable() {
      final List<PlayerState> seats = <PlayerState>[
         PlayerState(id: 'A', name: 'Alice', isBot: false, stack: 1000),
         PlayerState(id: 'B', name: 'Bob', isBot: false, stack: 1000),
         PlayerState(id: 'C', name: 'Cathy', isBot: true, stack: 1000),
      ];
      return engine.initializeTable(seats);
    }

    test('startNewRound 会收取底注并发牌', () {
      final GameTableState initial = createInitialTable();
      final GameTableState round = engine.startNewRound(initial);

      expect(round.stage, RoundStage.betting);
      expect(round.potAmount, config.ante * 3);
      expect(round.roundIndex, 1);
      expect(round.currentBet, config.baseBet);
      expect(round.remainingDeck.length, 52 - 3 * 3);

      for (final PlayerState player in round.players) {
        if (player.roundStatus == PlayerRoundStatus.eliminated) {
          fail('所有玩家都应成功参与本局');
        }
        expect(player.chipsInPot, config.ante);
        expect(player.hand.length, 3);
        expect(player.stack, 1000 - config.ante);
      }
    });

    test('call 行动扣除差额并轮到下家', () {
      final GameTableState initial = createInitialTable();
      final GameTableState round = engine.startNewRound(initial);
      final PlayerState actor = round.activePlayer;

      final GameTableState afterCall = engine.applyAction(
        round,
        PlayerAction(
          playerId: actor.id,
          type: PlayerActionType.call,
          amount: 0,
          createdAt: DateTime(2025),
        ),
      );

      expect(afterCall.potAmount, round.potAmount + config.baseBet - config.ante);
      final PlayerState updated = afterCall.players
          .firstWhere((PlayerState p) => p.id == actor.id);
      expect(updated.chipsInPot, config.baseBet);
      expect(updated.stack, 1000 - config.ante - (config.baseBet - config.ante));

      /// 验证轮转到下一位玩家。
      expect(afterCall.activePlayer.id, isNot(actor.id));
    });

    test('结算阶段会把底池分配给获胜者', () {
      final GameTableState initial = createInitialTable();
      final GameTableState round = engine.startNewRound(initial);
      final PlayerState active = round.activePlayer;
      final GameTableState afterCall = engine.applyAction(
        round,
        PlayerAction(
          playerId: active.id,
          type: PlayerActionType.call,
          amount: 0,
          createdAt: DateTime(2025),
        ),
      );

      final List<PlayerState> preparedPlayers = <PlayerState>[
        afterCall.players[0].copyWith(roundStatus: PlayerRoundStatus.active),
        afterCall.players[1].copyWith(
          roundStatus: PlayerRoundStatus.folded,
          hand: const <PlayingCard>[],
        ),
        afterCall.players[2].copyWith(
          roundStatus: PlayerRoundStatus.folded,
          hand: const <PlayingCard>[],
        ),
      ];

      final GameTableState showdown = afterCall.copyWith(
        stage: RoundStage.showdown,
        players: preparedPlayers,
      );

      final GameTableState settled = engine.settle(showdown);

      expect(settled.stage, RoundStage.settlement);
      expect(settled.potAmount, 0);
      final PlayerState winner =
          settled.players.firstWhere((PlayerState p) => p.id == preparedPlayers.first.id);
      expect(winner.stack,
          greaterThan(preparedPlayers.first.stack)); // 赢得底池获得更多筹码。
      expect(winner.roundStatus, PlayerRoundStatus.waiting);
    });
  });
}
