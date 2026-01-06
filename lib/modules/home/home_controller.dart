import 'package:get/get.dart';

class HomeController extends GetxController {
  final RxString selectedMode = '经典模式'.obs;

  void selectMode(String mode) {
    selectedMode.value = mode;
  }
}
