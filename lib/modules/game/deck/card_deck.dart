import 'dart:math';

import '../models/playing_card.dart';
import '../models/card_rank.dart';
import '../models/card_suit.dart';

/// 标准 52 张牌堆，提供洗牌与发牌能力。
class CardDeck {
  CardDeck._(this._cards);

  /// 当前剩余的牌面，栈顶在列表尾部。
  final List<PlayingCard> _cards;

  /// 创建一个新的洗牌牌堆。
  factory CardDeck.shuffled([Random? random]) {
    final Random rng = random ?? Random.secure();
    final List<PlayingCard> cards = <PlayingCard>[];
    for (final CardSuit suit in CardSuit.values) {
      for (final CardRank rank in CardRank.values) {
        cards.add(PlayingCard(rank, suit));
      }
    }
    cards.shuffle(rng);
    return CardDeck._(cards);
  }

  /// 剩余牌数量。
  int get length => _cards.length;

  /// 是否已经发完所有牌。
  bool get isEmpty => _cards.isEmpty;

  /// 导出当前剩余的牌面，外部请勿修改。
  List<PlayingCard> snapshot() => List<PlayingCard>.unmodifiable(_cards);

  /// 从牌堆顶部发出指定数量的牌。
  List<PlayingCard> draw(int count) {
    if (count < 0) {
      throw ArgumentError.value(count, 'count', '取牌数量不能为负数');
    }
    if (_cards.length < count) {
      throw StateError('牌堆剩余数量不足，无法继续发牌');
    }
    final List<PlayingCard> drawn =
        _cards.sublist(_cards.length - count, _cards.length);
    _cards.removeRange(_cards.length - count, _cards.length);
    return drawn;
  }

  /// 发出一张牌。
  PlayingCard drawOne() => draw(1).single;
}
