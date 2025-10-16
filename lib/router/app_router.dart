import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../modules/app/view/home_placeholder_page.dart';
import '../modules/game/view/game_table_page.dart';

/// 提供全局路由配置，可根据环境或登录态动态调整。
final Provider<GoRouter> appRouterProvider = Provider<GoRouter>(
  (Ref ref) {
    return GoRouter(
      initialLocation: GameTablePage.routePath,
      routes: <RouteBase>[
        GoRoute(
          path: GameTablePage.routePath,
          builder: (BuildContext context, GoRouterState state) =>
              const GameTablePage(),
        ),
        GoRoute(
          path: HomePlaceholderPage.routePath,
          builder: (BuildContext context, GoRouterState state) =>
              const HomePlaceholderPage(),
        ),
      ],
    );
  },
);
