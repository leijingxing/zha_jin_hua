import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'lobby_controller.dart';

class LobbyView extends GetView<LobbyController> {
  const LobbyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('大厅'),
      ),
      body: Center(
        child: Obx(() => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('当前筹码：${controller.chouMa.value}'),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => controller.zengJiaChouMa(100),
                  child: const Text('增加筹码'),
                ),
              ],
            )),
      ),
    );
  }
}
