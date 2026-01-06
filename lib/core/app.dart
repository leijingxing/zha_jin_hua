import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../router/app_pages.dart';
import 'env.dart';

class AppRoot extends StatelessWidget {
  final AppEnvConfig config;
  final String initialRoute;

  const AppRoot({
    super.key,
    required this.config,
    required this.initialRoute,
  });

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '扎金花',
      debugShowCheckedModeBanner: config.env == AppEnv.dev,
      initialRoute: initialRoute,
      getPages: AppPages.pages,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFB08D32)),
        useMaterial3: true,
      ),
    );
  }
}
