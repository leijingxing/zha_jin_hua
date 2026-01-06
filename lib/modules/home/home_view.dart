import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../router/app_routes.dart';
import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final modes = [
      _GameMode(
        title: '经典模式',
        subtitle: '传统牌局 · 稳健对局',
        icon: FontAwesomeIcons.chessKing,
      ),
      _GameMode(
        title: '快速模式',
        subtitle: '短局快节奏 · 适合碎片时间',
        icon: FontAwesomeIcons.bolt,
      ),
      _GameMode(
        title: '挑战模式',
        subtitle: '高风险高回报 · 强手对决',
        icon: FontAwesomeIcons.fire,
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0F1217),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: -160,
              right: -80,
              child: _GlowCircle(
                size: 320,
                color: const Color(0xFFB08D32).withOpacity(0.22),
              ),
            ),
            Positioned(
              bottom: -140,
              left: -60,
              child: _GlowCircle(
                size: 300,
                color: const Color(0xFF1E6A5A).withOpacity(0.22),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Icon(
                        FontAwesomeIcons.solidGem,
                        color: Color(0xFFD6B25E),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '游戏主页',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '选择玩法，进入商业质感牌桌',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Obx(() {
                      final selectedMode = controller.selectedMode.value;
                      return ListView.separated(
                        itemBuilder: (context, index) {
                          final mode = modes[index];
                          final selected = selectedMode == mode.title;
                          return _ModeCard(
                            mode: mode,
                            selected: selected,
                            onTap: () => controller.selectMode(mode.title),
                          );
                        },
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemCount: modes.length,
                      );
                    }),
                  ),
                  const SizedBox(height: 12),
                  _ActionButton(
                    label: '开始游戏',
                    subtitle: '进入牌桌',
                    onPressed: () {
                      Get.toNamed(AppRoutes.game, arguments: {
                        'mode': controller.selectedMode.value,
                      });
                    },
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

class _GameMode {
  final String title;
  final String subtitle;
  final IconData icon;

  const _GameMode({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

class _ModeCard extends StatelessWidget {
  final _GameMode mode;
  final bool selected;
  final VoidCallback onTap;

  const _ModeCard({
    required this.mode,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final highlight = selected ? const Color(0xFFB08D32) : Colors.white24;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF161A20),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: highlight,
            width: selected ? 1.2 : 0.6,
          ),
          boxShadow: [
            BoxShadow(
              color: highlight.withOpacity(selected ? 0.3 : 0.12),
              blurRadius: selected ? 28 : 18,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: highlight.withOpacity(0.2),
              ),
              child: Icon(mode.icon, color: highlight),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mode.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    mode.subtitle,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            const Icon(
              FontAwesomeIcons.chevronRight,
              color: Colors.white54,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final String subtitle;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.label,
    required this.subtitle,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        onPressed: onPressed,
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFD6B25E), Color(0xFFB08D32)],
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(
                color: Color(0x664C3C12),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  FontAwesomeIcons.play,
                  color: Colors.black,
                  size: 18,
                ),
                const SizedBox(width: 12),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GlowCircle extends StatelessWidget {
  final double size;
  final Color color;

  const _GlowCircle({
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: 120,
            spreadRadius: 40,
          ),
        ],
      ),
    );
  }
}
