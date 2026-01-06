import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/storage/local_storage_service.dart';
import '../router/app_routes.dart';
import 'app.dart';
import 'env.dart';

Future<void> bootstrap(AppEnvConfig config) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync<LocalStorageService>(
    () async => await LocalStorageService().init(),
  );
  final storage = Get.find<LocalStorageService>();
  final initialRoute = storage.isLoggedIn ? AppRoutes.home : AppRoutes.login;
  runApp(AppRoot(config: config, initialRoute: initialRoute));
}
