import 'player_action_type.dart';
import 'player_id.dart';

/// 记录玩家在某个时刻的行动及相关参数。
class PlayerAction {
  const PlayerAction({
    required this.playerId,
    required this.type,
    this.amount = 0,
    this.targetPlayerId,
    required this.createdAt,
  });

  /// 执行动作的玩家。
  final PlayerId playerId;

  /// 动作的类别。
  final PlayerActionType type;

  /// 对应的筹码变化，例如跟注金额。
  final int amount;

  /// 比牌时的目标玩家。
  final PlayerId? targetPlayerId;

  /// 动作发生的时间戳，便于追踪。
  final DateTime createdAt;
}
