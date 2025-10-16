import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../core/config/app_environment.dart';
import '../../core/theme/app_theme.dart';
import '../../router/app_router.dart';

/// 提供当前运行环境的 Riverpod Provider，便于模块按需读取。
final environmentProvider = Provider<AppEnvironment>(
  (ref) => throw UnimplementedError('尚未注入运行环境'),
);

/// 应用启动入口，统一处理环境配置、依赖初始化与运行。
Future<void> bootstrapApp(AppEnvironment environment) async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  // TODO(开发者): 此处注册 Hive 适配器。

  runApp(
    ProviderScope(
      overrides: [
        environmentProvider.overrideWithValue(environment),
      ],
      child: const ZjhApp(),
    ),
  );
}

/// 全局应用组件，负责加载主题与路由。
class ZjhApp extends ConsumerWidget {
  const ZjhApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      title: '扎金花',
      theme: buildAppTheme(),
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
