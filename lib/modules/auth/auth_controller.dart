import 'package:get/get.dart';

import '../../data/storage/local_storage_service.dart';

class AuthController extends GetxController {
  final LocalStorageService _storage = Get.find<LocalStorageService>();

  final RxBool isSubmitting = false.obs;

  String? get savedUser => _storage.user;

  Future<void> register({
    required String user,
    required String password,
  }) async {
    isSubmitting.value = true;
    try {
      await _storage.saveAccount(user: user, password: password);
      await _storage.setLoggedIn(false);
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<bool> login({
    required String user,
    required String password,
  }) async {
    isSubmitting.value = true;
    try {
      if (user.isNotEmpty || password.isNotEmpty) {
        await _storage.saveAccount(user: user, password: password);
      }
      await _storage.setLoggedIn(true);
      return true;
    } finally {
      isSubmitting.value = false;
    }
  }
}
