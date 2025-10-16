/// 牌桌运行时的核心配置项。
class GameConfig {
  const GameConfig({
    required this.minPlayers,
    required this.maxPlayers,
    required this.initialStack,
    required this.ante,
    required this.baseBet,
    required this.raiseStep,
    required this.seeCardMultiplier,
    required this.compareStake,
    required this.timeoutPerAction,
  });

  /// 最少需要几名玩家才能开局。
  final int minPlayers;

  /// 牌桌允许的最大玩家数。
  final int maxPlayers;

  /// 每名玩家默认的初始筹码。
  final int initialStack;

  /// 每局必须投入的底注。
  final int ante;

  /// 初始闷注金额（看牌前的跟注值）。
  final int baseBet;

  /// 加注的最小阶梯，通常为底注的倍数。
  final int raiseStep;

  /// 玩家看牌后下注通常需要翻倍。
  final int seeCardMultiplier;

  /// 比牌时需要额外投入的筹码。
  final int compareStake;

  /// 单次行动的超时阈值（毫秒）。
  final Duration timeoutPerAction;

  /// 标准配置，满足大部分 2-6 人牌局场景。
  factory GameConfig.standard() {
    return const GameConfig(
      minPlayers: 2,
      maxPlayers: 6,
      initialStack: 1000,
      ante: 10,
      baseBet: 20,
      raiseStep: 20,
      seeCardMultiplier: 2,
      compareStake: 40,
      timeoutPerAction: Duration(seconds: 20),
    );
  }

  /// 计算看牌后的最低跟注金额。
  int minSeenCallAmount() => baseBet * seeCardMultiplier;

  /// 计算本轮允许的最低加注金额。
  int minRaiseAmount(int currentBet) => currentBet + raiseStep;
}
