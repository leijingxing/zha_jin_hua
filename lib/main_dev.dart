import 'core/config/app_environment.dart';
import 'modules/app/app_bootstrap.dart';

/// 开发环境入口，开启调试与模拟数据。
Future<void> main() async {
  await bootstrapApp(AppEnvironment.dev);
}
