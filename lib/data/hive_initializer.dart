import 'package:hive_flutter/hive_flutter.dart';

import '../core/config/app_config.dart';

/// Hive 初始化入口，负责区分环境并注册适配器。
class HiveInitializer {
  const HiveInitializer(this.config);

  /// 应用配置，用于读取环境信息。
  final AppConfig config;

  /// 初始化 Hive，仅在首次调用时执行。
  Future<void> init() async {
    if (!_isInitialized) {
      await Hive.initFlutter(config.hiveSubDir);
      _registerAdapters();
      _isInitialized = true;
    }
  }

  static bool _isInitialized = false;

  /// 注册 Hive 适配器，后续新增模型需在此处维护。
  void _registerAdapters() {
    // TODO(开发者): 在此注册 Hive TypeAdapter，例如：
    // if (!Hive.isAdapterRegistered(PlayerProfileAdapter.typeId)) {
    //   Hive.registerAdapter(PlayerProfileAdapter());
    // }
  }
}
