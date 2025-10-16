import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zha_jin_hua/modules/app/view/home_placeholder_page.dart';

void main() {
  testWidgets('占位页加载后展示初始化提示', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: HomePlaceholderPage(),
      ),
    );

    expect(find.text('扎金花项目初始化完成'), findsOneWidget);
    expect(find.text('后续功能将按任务清单逐步落地。'), findsOneWidget);
  });
}
