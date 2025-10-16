import 'dart:collection';

import '../models/hand_category.dart';
import '../models/hand_rank.dart';
import '../models/playing_card.dart';

/// 三张牌型评估工具，基于诈金花常见规则。
class HandEvaluator {
  const HandEvaluator._();

  /// 评估当前手牌的类别以及比较权重。
  static HandRank evaluate(List<PlayingCard> cards) {
    if (cards.length != 3) {
      throw ArgumentError.value(cards.length, 'cards', '需要正好三张牌');
    }

    // 按点数升序排序，便于判断顺子与花色。
    final List<PlayingCard> sorted = List<PlayingCard>.from(cards)
      ..sort();
    final List<int> ranks = sorted.map((PlayingCard c) => c.rank.value).toList();
    final bool isFlush = _isFlush(sorted);
    final bool isStraight = _isStraight(ranks);
    final Map<int, int> rankCounter = _buildCounter(ranks);

    if (rankCounter.length == 1) {
      // 豹子（炸弹）
      final int point = ranks.first;
      return HandRank(
        category: HandCategory.triple,
        primary: point,
        secondary: 0,
        kickers: const <int>[],
      );
    }

    if (isFlush && isStraight) {
      final List<int> normalized = _normalizeStraightRanks(ranks);
      return HandRank(
        category: HandCategory.straightFlush,
        primary: normalized.last,
        secondary: normalized[1],
        kickers: <int>[normalized.first],
      );
    }

    if (isFlush) {
      return HandRank(
        category: HandCategory.flush,
        primary: ranks[2],
        secondary: ranks[1],
        kickers: <int>[ranks[0]],
      );
    }

    if (isStraight) {
      final List<int> normalized = _normalizeStraightRanks(ranks);
      return HandRank(
        category: HandCategory.straight,
        primary: normalized.last,
        secondary: normalized[1],
        kickers: <int>[normalized.first],
      );
    }

    if (rankCounter.length == 2) {
      final int pairRank =
          rankCounter.entries.firstWhere((MapEntry<int, int> entry) => entry.value == 2).key;
      final int kicker =
          rankCounter.entries.firstWhere((MapEntry<int, int> entry) => entry.value == 1).key;
      return HandRank(
        category: HandCategory.pair,
        primary: pairRank,
        secondary: kicker,
        kickers: const <int>[],
      );
    }

    return HandRank(
      category: HandCategory.highCard,
      primary: ranks[2],
      secondary: ranks[1],
      kickers: <int>[ranks[0]],
    );
  }

  /// 判断是否为同花。
  static bool _isFlush(List<PlayingCard> cards) {
    final int suitValue = cards.first.suit.index;
    for (int i = 1; i < cards.length; i++) {
      if (cards[i].suit.index != suitValue) {
        return false;
      }
    }
    return true;
  }

  /// 判断是否为顺子，包含 A23 特例。
  static bool _isStraight(List<int> ranks) {
    final List<int> normalized = _normalizeStraightRanks(ranks);
    for (int i = 1; i < normalized.length; i++) {
      if (normalized[i] - normalized[i - 1] != 1) {
        return false;
      }
    }
    return true;
  }

  /// 顺子比较时需要将 A23 视作 1、2、3。
  static List<int> _normalizeStraightRanks(List<int> ranks) {
    final List<int> sorted = List<int>.from(ranks)..sort();
    if (sorted[0] == 2 && sorted[1] == 3 && sorted[2] == 14) {
      return <int>[1, 2, 3];
    }
    return sorted;
  }

  /// 统计各点数出现次数。
  static Map<int, int> _buildCounter(List<int> ranks) {
    final Map<int, int> counter = HashMap<int, int>();
    for (final int rank in ranks) {
      counter.update(rank, (int value) => value + 1, ifAbsent: () => 1);
    }
    return counter;
  }
}
