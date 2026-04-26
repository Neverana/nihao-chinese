// lib/app.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_tokens.dart';
import 'core/theme/app_theme_mode.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(appThemeModeProvider);

    // Строим Material ThemeData под текущий режим
    // (используем для базовых M3-виджетов: диалоги, SnackBar и т.д.)
    final tokens = AppTokens.forMode(themeMode);

    final colorScheme = ColorScheme.fromSeed(
      seedColor: tokens.accent,
      brightness: (themeMode == AppThemeMode.darkGlass ||
              themeMode == AppThemeMode.blackMaterial)
          ? Brightness.dark
          : Brightness.light,
      surface: tokens.surface,
      onSurface: tokens.onSurface,
    );

    final theme = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: Colors.transparent,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      // Убираем splash-эффекты, используем собственные анимации
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
    );

    return MaterialApp.router(
      title: '汉语 · Курс китайского',
      theme: theme,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      builder: (context, child) => DefaultTextStyle(
        style: DefaultTextStyle.of(context)
            .style
            .copyWith(decoration: TextDecoration.none),
        child: child!,
      ),
    );
  }
}
