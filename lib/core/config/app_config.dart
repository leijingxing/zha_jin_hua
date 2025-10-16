import 'app_environment.dart';

/// 全局运行配置，统一描述不同环境下的开关与参数。
class AppConfig {
  const AppConfig({
    required this.environment,
    required this.enableDebugLog,
    required this.hiveSubDir,
    required this.storagePrefix,
    required this.aiDecisionBaseDelay,
  });

  /// 当前运行环境。
  final AppEnvironment environment;

  /// 是否启用调试日志（仅开发环境开启）。
  final bool enableDebugLog;

  /// Hive 数据存储的子目录，用于区分环境。
  final String hiveSubDir;

  /// 本地存储使用的键前缀，避免不同环境数据互相污染。
  final String storagePrefix;

  /// AI 动作基础延迟，营造真实玩家节奏。
  final Duration aiDecisionBaseDelay;

  /// 工厂方法：根据环境创建配置。
  factory AppConfig.fromEnvironment(AppEnvironment environment) {
    switch (environment) {
      case AppEnvironment.dev:
        return const AppConfig(
          environment: AppEnvironment.dev,
          enableDebugLog: true,
          hiveSubDir: 'dev_boxes',
          storagePrefix: 'dev_',
          aiDecisionBaseDelay: Duration(milliseconds: 800),
        );
      case AppEnvironment.prod:
        return const AppConfig(
          environment: AppEnvironment.prod,
          enableDebugLog: false,
          hiveSubDir: 'prod_boxes',
          storagePrefix: 'prod_',
          aiDecisionBaseDelay: Duration(milliseconds: 500),
        );
    }
  }

  /// 是否为生产环境。
  bool get isProd => environment == AppEnvironment.prod;
}
