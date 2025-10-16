import 'card_rank.dart';
import 'card_suit.dart';

/// 不可变的扑克牌结构，包含点数和花色。
class PlayingCard implements Comparable<PlayingCard> {
  const PlayingCard(this.rank, this.suit);

  final CardRank rank;
  final CardSuit suit;

  /// 从 0-51 的牌堆索引构造扑克牌。
  factory PlayingCard.fromIndex(int index) {
    if (index < 0 || index > 51) {
      throw ArgumentError.value(index, 'index', 'Deck index out of range');
    }
    final int suitIndex = index ~/ 13;
    final int rankOffset = index % 13;
    return PlayingCard(
      CardRank.values[rankOffset],
      CardSuit.values[suitIndex],
    );
  }

  @override
  int compareTo(PlayingCard other) => rank.value.compareTo(other.rank.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayingCard && other.rank == rank && other.suit == suit;

  @override
  int get hashCode => Object.hash(rank, suit);

  @override
  String toString() => '${rank.value}${suit.symbol}';
}
