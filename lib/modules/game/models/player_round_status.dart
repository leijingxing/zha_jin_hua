/// 玩家在当前局中的状态。
enum PlayerRoundStatus {
  /// 已加入牌桌但尚未参与本局。
  waiting,

  /// 正在本局内行动。
  active,

  /// 已经弃牌，退出本局结算。
  folded,

  /// 已全压，等待摊牌或比较结果。
  allIn,

  /// 筹码已耗尽或离开牌桌。
  eliminated,
}
