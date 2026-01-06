import 'package:get/get.dart';

class LobbyController extends GetxController {
  final RxInt chouMa = 1000.obs;

  void zengJiaChouMa(int shuLiang) {
    chouMa.value += shuLiang;
  }
}
