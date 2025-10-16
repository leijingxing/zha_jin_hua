/// Hive 盒子名称常量，集中管理本地持久化键值。
class HiveBoxes {
  HiveBoxes._();

  /// 玩家档案信息，如昵称、筹码余额。
  static const String playerProfile = 'player_profile';

  /// 游戏桌局配置，用于记忆最近一次的对局设置。
  static const String tableConfig = 'table_config';

  /// 全局统计数据，例如胜率、最佳牌型。
  static const String statistics = 'statistics';
}
