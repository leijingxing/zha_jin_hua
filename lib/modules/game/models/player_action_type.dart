/// 玩家可执行的行动类别。
enum PlayerActionType {
  /// 支付底注或强制盲注。
  ante,

  /// 跟注保持当前注额。
  call,

  /// 加注提高当前注额。
  raise,

  /// 弃牌退出本局。
  fold,

  /// 看牌，触发费用翻倍等规则。
  see,

  /// 比牌，直接与指定玩家决出胜负。
  compare,

  /// 全压，投入全部筹码。
  allIn,
}
