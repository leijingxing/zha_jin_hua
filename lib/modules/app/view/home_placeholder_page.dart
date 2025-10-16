import 'package:flutter/material.dart';

import '../../../core/theme/theme_tokens.dart';

/// 临时占位页面，后续将替换为大厅或加载界面。
class HomePlaceholderPage extends StatelessWidget {
  const HomePlaceholderPage({super.key});

  /// 路由路径常量，方便统一引用。
  static const String routePath = '/';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: _PlaceholderPanel(),
      ),
    );
  }
}

class _PlaceholderPanel extends StatelessWidget {
  const _PlaceholderPanel();

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      decoration: BoxDecoration(
        color: ThemeTokens.surfaceLayer,
        borderRadius: BorderRadius.all(Radius.circular(28)),
        boxShadow: ThemeTokens.outerShadows,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            '扎金花项目初始化完成',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: ThemeTokens.textPrimary,
            ),
          ),
          SizedBox(height: 12),
          Text(
            '后续功能将按任务清单逐步落地。',
            style: TextStyle(
              fontSize: 14,
              color: ThemeTokens.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
