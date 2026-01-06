import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LocalStorageService extends GetxService {
  static const String boxName = 'app_storage';
  static const String keyUser = 'user_account';
  static const String keyPassword = 'user_password';
  static const String keyLoggedIn = 'logged_in';

  late Box<dynamic> _box;

  Future<LocalStorageService> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox<dynamic>(boxName);
    return this;
  }

  String? get user => _box.get(keyUser) as String?;
  String? get password => _box.get(keyPassword) as String?;
  bool get isLoggedIn => (_box.get(keyLoggedIn) as bool?) ?? false;

  Future<void> saveAccount({
    required String user,
    required String password,
  }) async {
    await _box.put(keyUser, user);
    await _box.put(keyPassword, password);
  }

  Future<void> setLoggedIn(bool value) async {
    await _box.put(keyLoggedIn, value);
  }

  Future<void> clearLogin() async {
    await _box.put(keyLoggedIn, false);
  }
}
