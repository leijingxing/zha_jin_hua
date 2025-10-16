import 'package:flutter_test/flutter_test.dart';

import 'package:zha_jin_hua/modules/game/logic/hand_evaluator.dart';
import 'package:zha_jin_hua/modules/game/models/hand_category.dart';
import 'package:zha_jin_hua/modules/game/models/playing_card.dart';
import 'package:zha_jin_hua/modules/game/models/card_rank.dart';
import 'package:zha_jin_hua/modules/game/models/card_suit.dart';

void main() {
  group('HandEvaluator', () {
    test('识别豹子', () {
      final rank = HandEvaluator.evaluate(
        <PlayingCard>[
          PlayingCard(CardRank.ace, CardSuit.clubs),
          PlayingCard(CardRank.ace, CardSuit.diamonds),
          PlayingCard(CardRank.ace, CardSuit.spades),
        ],
      );
      expect(rank.category, HandCategory.triple);
      expect(rank.primary, CardRank.ace.value);
    });

    test('识别同花顺含 A23', () {
      final rank = HandEvaluator.evaluate(
        <PlayingCard>[
          PlayingCard(CardRank.ace, CardSuit.hearts),
          PlayingCard(CardRank.two, CardSuit.hearts),
          PlayingCard(CardRank.three, CardSuit.hearts),
        ],
      );
      expect(rank.category, HandCategory.straightFlush);
      expect(rank.primary, 3);
    });

    test('识别同花', () {
      final rank = HandEvaluator.evaluate(
        <PlayingCard>[
          PlayingCard(CardRank.two, CardSuit.spades),
          PlayingCard(CardRank.ten, CardSuit.spades),
          PlayingCard(CardRank.king, CardSuit.spades),
        ],
      );
      expect(rank.category, HandCategory.flush);
      expect(rank.primary, CardRank.king.value);
    });

    test('识别顺子', () {
      final rank = HandEvaluator.evaluate(
        <PlayingCard>[
          PlayingCard(CardRank.five, CardSuit.clubs),
          PlayingCard(CardRank.four, CardSuit.hearts),
          PlayingCard(CardRank.six, CardSuit.diamonds),
        ],
      );
      expect(rank.category, HandCategory.straight);
      expect(rank.primary, CardRank.six.value);
    });

    test('识别对子', () {
      final rank = HandEvaluator.evaluate(
        <PlayingCard>[
          PlayingCard(CardRank.five, CardSuit.clubs),
          PlayingCard(CardRank.five, CardSuit.spades),
          PlayingCard(CardRank.queen, CardSuit.hearts),
        ],
      );
      expect(rank.category, HandCategory.pair);
      expect(rank.primary, CardRank.five.value);
      expect(rank.secondary, CardRank.queen.value);
    });

    test('识别散牌', () {
      final rank = HandEvaluator.evaluate(
        <PlayingCard>[
          PlayingCard(CardRank.two, CardSuit.clubs),
          PlayingCard(CardRank.seven, CardSuit.diamonds),
          PlayingCard(CardRank.king, CardSuit.hearts),
        ],
      );
      expect(rank.category, HandCategory.highCard);
      expect(rank.primary, CardRank.king.value);
    });
  });
}
