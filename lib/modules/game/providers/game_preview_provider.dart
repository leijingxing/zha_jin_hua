import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../engine/game_engine.dart';
import '../models/player_state.dart';
import '../models/player_round_status.dart';
import '../models/playing_card.dart';
import '../models/card_rank.dart';
import '../models/card_suit.dart';
import '../state/game_table_state.dart';

/// 预览演示用的牌桌状态，用于尚未接入完整游戏逻辑时展示 UI。
final Provider<GameTableState> gamePreviewProvider = Provider<GameTableState>(
  (Ref ref) {
    final GameEngine engine = GameEngine(random: Random(7));
    final GameTableState initial = engine.initializeTable(
      <PlayerState>[
        const PlayerState(id: 'hero', name: '你', isBot: false, stack: 920),
        const PlayerState(id: 'bot_a', name: '静雅', isBot: true, stack: 1030),
        const PlayerState(id: 'bot_b', name: '乾坤', isBot: true, stack: 860),
        const PlayerState(id: 'bot_c', name: '明月', isBot: true, stack: 1240),
      ],
    );

    final GameTableState ongoing = engine.startNewRound(initial);

    // 固定主角看牌并展示一手漂亮的同花顺，提升展示效果。
    final List<PlayerState> decoratedPlayers =
        ongoing.players.map((PlayerState player) {
      if (player.id == 'hero') {
        return player.copyWith(
          hasSeenCards: true,
          hand: const <PlayingCard>[
            PlayingCard(CardRank.ace, CardSuit.hearts),
            PlayingCard(CardRank.king, CardSuit.hearts),
            PlayingCard(CardRank.queen, CardSuit.hearts),
          ],
        );
      }
      return player.copyWith(
        roundStatus: player.roundStatus == PlayerRoundStatus.active
            ? PlayerRoundStatus.active
            : player.roundStatus,
      );
    }).toList();

    return ongoing.copyWith(players: decoratedPlayers);
  },
);
