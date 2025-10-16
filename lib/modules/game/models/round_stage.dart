/// 单局牌局的阶段划分。
enum RoundStage {
  /// 等待所有座位准备就绪。
  waitingPlayers,

  /// 收取底注或盲注。
  collectingAnte,

  /// 发牌阶段。
  dealing,

  /// 轮流行动下注阶段。
  betting,

  /// 比牌或摊牌阶段。
  showdown,

  /// 当局结算筹码并准备下一局。
  settlement,
}
