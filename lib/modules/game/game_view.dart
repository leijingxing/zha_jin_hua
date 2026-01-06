import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GameView extends StatelessWidget {
  const GameView({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    final mode = (args?['mode'] as String?) ?? '经典模式';
    return Scaffold(
      appBar: AppBar(
        title: const Text('牌桌'),
      ),
      body: Center(
        child: Text('当前玩法：$mode'),
      ),
    );
  }
}
