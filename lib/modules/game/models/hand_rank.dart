import 'hand_category.dart';

/// 三张牌型的评估结果，包含比较所需的维度。
class HandRank implements Comparable<HandRank> {
  const HandRank({
    required this.category,
    required this.primary,
    required this.secondary,
    required this.kickers,
  });

  /// 牌型所属的强度档位。
  final HandCategory category;

  /// 第一优先级的比较值，例如豹子点数或顺子最大点。
  final int primary;

  /// 第二优先级比较值，例如对子单牌或顺子中间点。
  final int secondary;

  /// 剩余用于打平的点数组合，按降序排列。
  final List<int> kickers;

  @override
  int compareTo(HandRank other) {
    final int categoryDiff =
        other.category.index.compareTo(category.index); // 强者在前
    if (categoryDiff != 0) {
      return categoryDiff;
    }
    if (primary != other.primary) {
      return primary.compareTo(other.primary);
    }
    if (secondary != other.secondary) {
      return secondary.compareTo(other.secondary);
    }
    for (int i = 0; i < kickers.length && i < other.kickers.length; i++) {
      final int diff = kickers[i].compareTo(other.kickers[i]);
      if (diff != 0) {
        return diff;
      }
    }
    return kickers.length.compareTo(other.kickers.length);
  }
}
