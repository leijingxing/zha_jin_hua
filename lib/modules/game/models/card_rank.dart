/// 牌面点数的枚举类型，按从小到大排列（2 到 A）。
enum CardRank {
  two(2),
  three(3),
  four(4),
  five(5),
  six(6),
  seven(7),
  eight(8),
  nine(9),
  ten(10),
  jack(11),
  queen(12),
  king(13),
  ace(14);

  const CardRank(this.value);

  /// 点数对应的整数值，用于比较强弱。
  final int value;

  /// 获取当前点数的下一个点数，如已到顶则返回 null。
  CardRank? get next => switch (this) {
        CardRank.two => CardRank.three,
        CardRank.three => CardRank.four,
        CardRank.four => CardRank.five,
        CardRank.five => CardRank.six,
        CardRank.six => CardRank.seven,
        CardRank.seven => CardRank.eight,
        CardRank.eight => CardRank.nine,
        CardRank.nine => CardRank.ten,
        CardRank.ten => CardRank.jack,
        CardRank.jack => CardRank.queen,
        CardRank.queen => CardRank.king,
        CardRank.king => CardRank.ace,
        CardRank.ace => null,
      };

  /// 根据实际点数值转换为 [CardRank]。
  static CardRank fromValue(int value) {
    return CardRank.values.firstWhere(
      (CardRank rank) => rank.value == value,
      orElse: () => throw ArgumentError.value(value, 'value', 'Invalid rank'),
    );
  }
}
