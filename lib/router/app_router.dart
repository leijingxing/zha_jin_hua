import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../modules/app/view/home_placeholder_page.dart';

/// 提供全局路由配置，后续可根据环境或登录态动态生成。
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: HomePlaceholderPage.routePath,
    routes: [
      GoRoute(
        path: HomePlaceholderPage.routePath,
        builder: (context, state) => const HomePlaceholderPage(),
      ),
    ],
  );
});
