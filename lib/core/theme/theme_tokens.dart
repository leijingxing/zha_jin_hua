import 'package:flutter/material.dart';

/// 主题色彩与阴影基线常量，方便统一维护现代拟态风格。
class ThemeTokens {
  ThemeTokens._();

  /// 应用主背景色，偏明亮的暖白色。
  static const Color backgroundBase = Color(0xFFF8FAFC);

  /// 次级面板背景色，用于组件浮层。
  static const Color surfaceLayer = Color(0xFFE2E8F0);

  /// 高亮颜色，用于主要操作按钮与强调元素。
  static const Color accentPrimary = Color(0xFF0F766E);

  /// 成功或胜利提示色，带有金属质感的金色。
  static const Color accentVictory = Color(0xFFD97706);

  /// 错误或危险提示色。
  static const Color accentDanger = Color(0xFFDC2626);

  /// 文字主色，保持足够对比度。
  static const Color textPrimary = Color(0xFF0F172A);

  /// 文字次色，用于辅助信息。
  static const Color textSecondary = Color(0xFF475569);

  /// 拟态外阴影，营造浮起效果。
  static const List<BoxShadow> outerShadows = [
    BoxShadow(
      color: Color(0x331E293B),
      offset: Offset(12, 12),
      blurRadius: 32,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x80FFFFFF),
      offset: Offset(-8, -8),
      blurRadius: 24,
      spreadRadius: 0,
    ),
  ];

  /// 拟态内阴影，突出按压态。
  static const List<BoxShadow> innerShadows = [
    BoxShadow(
      color: Color(0x40FFFFFF),
      offset: Offset(6, 6),
      blurRadius: 16,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x331E293B),
      offset: Offset(-4, -4),
      blurRadius: 12,
      spreadRadius: 0,
    ),
  ];
}
