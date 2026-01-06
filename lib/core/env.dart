enum AppEnv {
  dev,
  prod,
}

class AppEnvConfig {
  final AppEnv env;
  final String name;

  const AppEnvConfig._(this.env, this.name);

  static const dev = AppEnvConfig._(AppEnv.dev, '开发');
  static const prod = AppEnvConfig._(AppEnv.prod, '生产');
}
