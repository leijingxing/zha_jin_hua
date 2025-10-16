import 'package:flutter/material.dart';

import 'theme_tokens.dart';

/// 构建全局主题数据，统一应用的色彩、字体与组件风格。
ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: ThemeTokens.backgroundBase,
    colorScheme: const ColorScheme.light(
      primary: ThemeTokens.accentPrimary,
      onPrimary: Colors.white,
      secondary: ThemeTokens.accentVictory,
      onSecondary: Colors.white,
      surface: ThemeTokens.surfaceLayer,
      onSurface: ThemeTokens.textPrimary,
      error: ThemeTokens.accentDanger,
      onError: Colors.white,
    ),
    textTheme: _buildTextTheme(),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: ThemeTokens.textPrimary,
      centerTitle: true,
    ),
    cardTheme: CardThemeData(
      color: ThemeTokens.surfaceLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      shadowColor: ThemeTokens.outerShadows.first.color,
      margin: const EdgeInsets.all(12),
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ThemeTokens.accentPrimary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        shadowColor: ThemeTokens.outerShadows.first.color,
        elevation: 6,
      ),
    ),
    snackBarTheme: const SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: ThemeTokens.textPrimary,
      contentTextStyle: TextStyle(color: Colors.white),
    ),
  );
}

/// 自定义字体层级，强化信息层次感。
TextTheme _buildTextTheme() {
  const TextStyle base = TextStyle(
    color: ThemeTokens.textPrimary,
    fontFamily: 'PingFang SC',
  );
  return TextTheme(
    headlineLarge: base.copyWith(fontSize: 32, fontWeight: FontWeight.w700),
    headlineMedium: base.copyWith(fontSize: 24, fontWeight: FontWeight.w600),
    titleLarge: base.copyWith(fontSize: 20, fontWeight: FontWeight.w600),
    titleMedium: base.copyWith(fontSize: 18, fontWeight: FontWeight.w500),
    bodyLarge: base.copyWith(fontSize: 16, fontWeight: FontWeight.w400),
    bodyMedium: base.copyWith(fontSize: 14, fontWeight: FontWeight.w400),
    labelLarge: base.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
  );
}
