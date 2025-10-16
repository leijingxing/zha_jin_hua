/// 52 张标准扑克牌中使用的花色。
enum CardSuit {
  clubs,
  diamonds,
  hearts,
  spades;

  /// 花色对应的编号，方便洗牌时统一处理。
  int get id => index;

  /// 简易文本标记，便于日志输出。
  String get symbol => switch (this) {
        CardSuit.clubs => 'C',
        CardSuit.diamonds => 'D',
        CardSuit.hearts => 'H',
        CardSuit.spades => 'S',
      };
}
