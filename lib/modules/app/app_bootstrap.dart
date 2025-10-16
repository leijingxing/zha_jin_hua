import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/config/app_config.dart';
import '../../core/config/app_environment.dart';
import '../../core/theme/app_theme.dart';
import '../../data/hive_initializer.dart';
import '../../router/app_router.dart';

/// Exposes the resolved [AppConfig] to the widget tree.
final Provider<AppConfig> appConfigProvider = Provider<AppConfig>(
  (Ref ref) => throw UnimplementedError('appConfigProvider is not overridden'),
);

/// Exposes the shared [HiveInitializer] instance for late usage.
final Provider<HiveInitializer> hiveInitializerProvider = Provider<HiveInitializer>(
  (Ref ref) =>
      throw UnimplementedError('hiveInitializerProvider is not overridden'),
);

/// Performs shared bootstrapping tasks before rendering the app.
Future<void> bootstrapApp(AppEnvironment environment) async {
  WidgetsFlutterBinding.ensureInitialized();

  final AppConfig config = AppConfig.fromEnvironment(environment);
  final HiveInitializer hiveInitializer = HiveInitializer(config);
  await hiveInitializer.init();

  runApp(
    ProviderScope(
      overrides: [
        appConfigProvider.overrideWithValue(config),
        hiveInitializerProvider.overrideWithValue(hiveInitializer),
      ],
      child: const _AppRoot(),
    ),
  );
}

class _AppRoot extends ConsumerWidget {
  const _AppRoot();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppConfig config = ref.watch(appConfigProvider);
    final GoRouter router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Zha Jin Hua',
      debugShowCheckedModeBanner: !config.isProd,
      theme: buildAppTheme(),
      routerConfig: router,
    );
  }
}
