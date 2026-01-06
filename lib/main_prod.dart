import 'core/bootstrap.dart';
import 'core/env.dart';

Future<void> main() async {
  await bootstrap(AppEnvConfig.prod);
}
