import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'game_controller.dart';
import 'game_widgets.dart';

class GameView extends StatelessWidget {
  GameView({super.key});

  final GameController controller = Get.put(GameController());

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    final mode = (args?['mode'] as String?) ?? '经典模式';
    return Scaffold(
      backgroundColor: const Color(0xFF0B0E12),
      body: SafeArea(
        child: Stack(
          children: [
            const GameBackgroundLayer(),
            Positioned(
              top: -120,
              right: -80,
              child: GameGlowCircle(
                size: 260,
                color: const Color(0xFFB08D32).withOpacity(0.18),
              ),
            ),
            Positioned(
              bottom: -140,
              left: -60,
              child: GameGlowCircle(
                size: 300,
                color: const Color(0xFF1E6A5A).withOpacity(0.18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  GameTopBar(mode: mode, controller: controller),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Row(
                      children: [
                        GameSidePanel(
                          title: '玩家列表',
                          child: GamePlayerList(controller: controller),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: GameTableArea(
                            mode: mode,
                            controller: controller,
                          ),
                        ),
                        const SizedBox(width: 10),
                        GameSidePanel(
                          title: '操作区',
                          child: GameActionPanel(controller: controller),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
