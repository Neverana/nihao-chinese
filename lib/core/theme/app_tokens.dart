// lib/core/theme/app_tokens.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_theme_mode.dart';

class AppTokens {
  final Decoration backgroundDecoration;

  final Color surface;
  final Color surfaceBorder;
  final Color surfaceHighlight;

  final Color onSurface;
  final Color onSurfaceMuted;
  final Color onSurfaceDisabled;

  final Color accent;
  final Color accentSoft;
  final Color accentSecondary;
  final Color accentSuccess;
  final Color accentWarn;
  final Color accentDanger;

  final Color hsk1Color;
  final Color hsk2Color;
  final Color hsk3Color;
  final Color hsk4Color;

  final double radiusCard;
  final double radiusButton;
  final double radiusChip;

  final double blurStrength;
  final double glassOpacity;
  final Color glassBorderColor;

  final List<BoxShadow> cardShadow;
  final List<BoxShadow> buttonShadow;

  final Color navBarBackground;
  final Color navBarBorder;
  final Color navBarSelectedColor;
  final Color navBarUnselectedColor;

  // Цвет текста в сайднаве (подзаголовок «Курс китайского»)
  final Color sideNavSubtitleColor;

  // Цвет бейджей в топбаре (огонь, звезда)
  final Color badgeFireBg;
  final Color badgeFireFg;
  final Color badgeStarBg;
  final Color badgeStarFg;

  final Color iconLocked;
  final Color iconAvailable;
  final Color iconCompleted;

  const AppTokens({
    required this.backgroundDecoration,
    required this.surface,
    required this.surfaceBorder,
    required this.surfaceHighlight,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.onSurfaceDisabled,
    required this.accent,
    required this.accentSoft,
    required this.accentSecondary,
    required this.accentSuccess,
    required this.accentWarn,
    required this.accentDanger,
    required this.hsk1Color,
    required this.hsk2Color,
    required this.hsk3Color,
    required this.hsk4Color,
    required this.radiusCard,
    required this.radiusButton,
    required this.radiusChip,
    required this.blurStrength,
    required this.glassOpacity,
    required this.glassBorderColor,
    required this.cardShadow,
    required this.buttonShadow,
    required this.navBarBackground,
    required this.navBarBorder,
    required this.navBarSelectedColor,
    required this.navBarUnselectedColor,
    required this.sideNavSubtitleColor,
    required this.badgeFireBg,
    required this.badgeFireFg,
    required this.badgeStarBg,
    required this.badgeStarFg,
    required this.iconLocked,
    required this.iconAvailable,
    required this.iconCompleted,
  });

  bool get isGlass => blurStrength > 0;

  static AppTokens forMode(AppThemeMode mode) => switch (mode) {
        AppThemeMode.lightGlass    => _lightGlass,
        AppThemeMode.darkGlass     => _darkGlass,
        AppThemeMode.lightMaterial => _lightMaterial,
        AppThemeMode.blackMaterial => _blueMaterial,
      };

  // ─── 1. LIGHT LIQUID GLASS ──────────────────────────────────────────────────
  // Пастельный градиент, лаванда → мята → персик. Без изменений — выглядело хорошо.

  static const _lightGlass = AppTokens(
    backgroundDecoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [0.0, 0.35, 0.70, 1.0],
        colors: [Color(0xFFC8D8FF), Color(0xFFE0C8FF), Color(0xFFC8F0E8), Color(0xFFFFD8C8)],
      ),
    ),
    surface:           Color(0x8DFFFFFF),
    surfaceBorder:     Color(0xB3FFFFFF),
    surfaceHighlight:  Color(0xCCFFFFFF),
    onSurface:         Color(0xFF1A1A2E),
    onSurfaceMuted:    Color(0xFF4A4A6A),
    onSurfaceDisabled: Color(0xFFA0A0C0),
    accent:            Color(0xFF5B8FFF),
    accentSoft:        Color(0x265B8FFF),
    accentSecondary:   Color(0xFFA78BFA),
    accentSuccess:     Color(0xFF34D399),
    accentWarn:        Color(0xFFFB923C),
    accentDanger:      Color(0xFFF87171),
    hsk1Color: Color(0xFF34D399),
    hsk2Color: Color(0xFFFBBF24),
    hsk3Color: Color(0xFFFB923C),
    hsk4Color: Color(0xFFF87171),
    radiusCard: 18, radiusButton: 12, radiusChip: 20,
    blurStrength: 16, glassOpacity: 0.55,
    glassBorderColor: Color(0xB3FFFFFF),
    cardShadow: [BoxShadow(color: Color(0x1F5B8FFF), blurRadius: 32, offset: Offset(0, 8))],
    buttonShadow: [BoxShadow(color: Color(0x335B8FFF), blurRadius: 16, offset: Offset(0, 4))],
    navBarBackground:      Color(0x99FFFFFF),
    navBarBorder:          Color(0x66FFFFFF),
    navBarSelectedColor:   Color(0xFF5B8FFF),
    navBarUnselectedColor: Color(0xFF8888AA),
    sideNavSubtitleColor:  Color(0xFF4A4A6A),
    // Бейджи — тёплые, видны на светлом фоне
    badgeFireBg: Color(0x26FB923C),
    badgeFireFg: Color(0xFFE07020),
    badgeStarBg: Color(0x26F5B800),
    badgeStarFg: Color(0xFFA07800),
    iconLocked:    Color(0xFFB0B0C8),
    iconAvailable: Color(0xFF5B8FFF),
    iconCompleted: Color(0xFF34D399),
  );

  // ─── 2. DARK LIQUID GLASS ───────────────────────────────────────────────────
  // Тёмный градиент. Исправления:
  //   • бейджи (огонь/звезда) — убраны жёлтые/оранжевые фоны, заменены на нейтральные
  //     полупрозрачные белые, иконки остаются цветными
  //   • sideNavSubtitleColor — значительно светлее чем раньше
  //   • onSurfaceMuted — чуть светлее для читаемости

  static const _darkGlass = AppTokens(
    backgroundDecoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [0.0, 0.5, 1.0],
        colors: [Color(0xFF0D0D1A), Color(0xFF111830), Color(0xFF0A1A0F)],
      ),
    ),
    surface:           Color(0x14FFFFFF),
    surfaceBorder:     Color(0x26FFFFFF),
    surfaceHighlight:  Color(0x33FFFFFF),
    onSurface:         Color(0xFFF0F0FA),   // ярче чем раньше
    onSurfaceMuted:    Color(0xFFAAAAAC),   // было 0xFF8888AA — теперь светлее
    onSurfaceDisabled: Color(0xFF5A5A7A),
    accent:            Color(0xFF7BA7FF),
    accentSoft:        Color(0x267BA7FF),
    accentSecondary:   Color(0xFFBDA8FA),
    accentSuccess:     Color(0xFF4AE3A4),
    accentWarn:        Color(0xFFFC9D52),
    accentDanger:      Color(0xFFFA8282),
    hsk1Color: Color(0xFF4AE3A4),
    hsk2Color: Color(0xFFFBBF24),
    hsk3Color: Color(0xFFFC9D52),
    hsk4Color: Color(0xFFFA8282),
    radiusCard: 18, radiusButton: 12, radiusChip: 20,
    blurStrength: 20, glassOpacity: 0.08,
    glassBorderColor: Color(0x26FFFFFF),
    cardShadow: [BoxShadow(color: Color(0x3D000000), blurRadius: 32, offset: Offset(0, 8))],
    buttonShadow: [BoxShadow(color: Color(0x4D000000), blurRadius: 16, offset: Offset(0, 4))],
    navBarBackground:      Color(0xCC0D0D1A),
    navBarBorder:          Color(0x26FFFFFF),
    navBarSelectedColor:   Color(0xFF7BA7FF),
    navBarUnselectedColor: Color(0xFF7A7A9A),  // светлее для читаемости
    sideNavSubtitleColor:  Color(0xFFCCCCDD),  // было тёмное — теперь почти белое
    // Бейджи: нейтральный белёсый фон, цветные иконки — без жёлтых полосок
    badgeFireBg: Color(0x1FFFFFFF),
    badgeFireFg: Color(0xFFFC9D52),
    badgeStarBg: Color(0x1FFFFFFF),
    badgeStarFg: Color(0xFFFBBF24),
    iconLocked:    Color(0xFF4A4A6A),
    iconAvailable: Color(0xFF7BA7FF),
    iconCompleted: Color(0xFF4AE3A4),
  );

  // ─── 3. LIGHT MATERIAL — тёплый, цветастый, уютный ─────────────────────────
  // Не чисто белый. Кремово-персиковый фон, карточки тёплые.
  // Акценты живые, насыщенные.

  static const _lightMaterial = AppTokens(
    backgroundDecoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [0.0, 0.6, 1.0],
        colors: [Color(0xFFFFF4EC), Color(0xFFFCF0FF), Color(0xFFECF4FF)],
      ),
    ),
    surface:           Color(0xFFFFFBF7),   // тёплый кремовый
    surfaceBorder:     Color(0xFFE8DACE),   // тёплая бежевая граница
    surfaceHighlight:  Color(0xFFFFF0E6),
    onSurface:         Color(0xFF2A1F1A),   // тёмно-коричневый, не чёрный
    onSurfaceMuted:    Color(0xFF7A6055),   // тёплый коричневато-серый
    onSurfaceDisabled: Color(0xFFBBAA9E),
    accent:            Color(0xFF6B6BF0),   // фиолетово-синий акцент
    accentSoft:        Color(0x1A6B6BF0),
    accentSecondary:   Color(0xFFE05FA0),   // розовый второй акцент
    accentSuccess:     Color(0xFF2DA86B),
    accentWarn:        Color(0xFFE8820C),
    accentDanger:      Color(0xFFD94040),
    hsk1Color: Color(0xFF2DA86B),
    hsk2Color: Color(0xFFE8B20C),
    hsk3Color: Color(0xFFE8820C),
    hsk4Color: Color(0xFFD94040),
    radiusCard: 16, radiusButton: 12, radiusChip: 20,
    blurStrength: 0, glassOpacity: 1,
    glassBorderColor: Color(0xFFE8DACE),
    cardShadow: [
      BoxShadow(color: Color(0x14C08060), blurRadius: 12, offset: Offset(0, 4)),
      BoxShadow(color: Color(0x0AC08060), blurRadius: 32, offset: Offset(0, 12)),
    ],
    buttonShadow: [BoxShadow(color: Color(0x206B6BF0), blurRadius: 12, offset: Offset(0, 4))],
    navBarBackground:      Color(0xFFFFFBF7),
    navBarBorder:          Color(0xFFE8DACE),
    navBarSelectedColor:   Color(0xFF6B6BF0),
    navBarUnselectedColor: Color(0xFFAA9080),
    sideNavSubtitleColor:  Color(0xFF7A6055),
    badgeFireBg: Color(0x1FE8820C),
    badgeFireFg: Color(0xFFCC6000),
    badgeStarBg: Color(0x1FE8B20C),
    badgeStarFg: Color(0xFFAA8000),
    iconLocked:    Color(0xFFCCBBAA),
    iconAvailable: Color(0xFF6B6BF0),
    iconCompleted: Color(0xFF2DA86B),
  );

  // ─── 4. BLUE MATERIAL (бывший Black Material) ───────────────────────────────
  // Тёмно-синий как в Telegram, но чуть светлее и с читаемыми шрифтами.
  // Фон — насыщенный тёмно-синий, карточки — чуть светлее синие.
  // Все тексты контрастные.

  static const _blueMaterial = AppTokens(
    backgroundDecoration: BoxDecoration(
      color: Color(0xFF0F1621),  // тёмно-синий фон
    ),
    surface:           Color(0xFF1C2535),   // карточки — синеватые, не серые
    surfaceBorder:     Color(0xFF2A3A50),   // граница видна на фоне карточки
    surfaceHighlight:  Color(0xFF243040),
    onSurface:         Color(0xFFF0F4FF),   // почти белый с голубоватым оттенком
    onSurfaceMuted:    Color(0xFFADBDD8),   // голубовато-серый, контрастный
    onSurfaceDisabled: Color(0xFF4A5A72),
    accent:            Color(0xFF5B9BFF),   // яркий синий акцент
    accentSoft:        Color(0x265B9BFF),
    accentSecondary:   Color(0xFF9B7BFF),
    accentSuccess:     Color(0xFF3DD68C),
    accentWarn:        Color(0xFFFFAA44),
    accentDanger:      Color(0xFFFF6B6B),
    hsk1Color: Color(0xFF3DD68C),
    hsk2Color: Color(0xFFFFCC44),
    hsk3Color: Color(0xFFFFAA44),
    hsk4Color: Color(0xFFFF6B6B),
    radiusCard: 16, radiusButton: 12, radiusChip: 20,
    blurStrength: 0, glassOpacity: 1,
    glassBorderColor: Color(0xFF2A3A50),
    cardShadow: [BoxShadow(color: Color(0x3D000000), blurRadius: 16, offset: Offset(0, 4))],
    buttonShadow: [BoxShadow(color: Color(0x405B9BFF), blurRadius: 12, offset: Offset(0, 4))],
    navBarBackground:      Color(0xFF141D2B),
    navBarBorder:          Color(0xFF1E2D42),
    navBarSelectedColor:   Color(0xFF5B9BFF),
    navBarUnselectedColor: Color(0xFF6A7A94),
    sideNavSubtitleColor:  Color(0xFFADBDD8),
    badgeFireBg: Color(0x26FFAA44),
    badgeFireFg: Color(0xFFFFAA44),
    badgeStarBg: Color(0x26FFCC44),
    badgeStarFg: Color(0xFFFFCC44),
    iconLocked:    Color(0xFF2A3A50),
    iconAvailable: Color(0xFF5B9BFF),
    iconCompleted: Color(0xFF3DD68C),
  );
}

final appTokensProvider = Provider<AppTokens>((ref) {
  final mode = ref.watch(appThemeModeProvider);
  return AppTokens.forMode(mode);
});
