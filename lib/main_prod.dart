import 'core/config/app_environment.dart';
import 'modules/app/app_bootstrap.dart';

/// 生产环境入口，使用正式配置与服务地址。
Future<void> main() async {
  await bootstrapApp(AppEnvironment.prod);
}
