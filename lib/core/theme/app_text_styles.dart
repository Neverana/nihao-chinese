// lib/core/theme/app_text_styles.dart
//
// Все стили завязаны на AppTokens, чтобы корректно работать со всеми 4 темами.
// Используй: AppTextStyles.of(tokens).headlineLarge

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_tokens.dart';

class AppTextStyles {
  final AppTokens _t;
  const AppTextStyles._(this._t);

  factory AppTextStyles.of(AppTokens tokens) => AppTextStyles._(tokens);

  // ─── Иероглифы ──────────────────────────────────────────────────────────────

  TextStyle get hanziHero => const TextStyle(
        fontFamily: 'NotoSansSC',
        fontSize: 56,
        fontWeight: FontWeight.w700,
        height: 1.1,
      );

  TextStyle get hanziLarge => const TextStyle(
        fontFamily: 'NotoSansSC',
        fontSize: 36,
        fontWeight: FontWeight.w700,
        height: 1.2,
      );

  TextStyle get hanziMedium => const TextStyle(
        fontFamily: 'NotoSansSC',
        fontSize: 24,
        fontWeight: FontWeight.w400,
        height: 1.3,
      );

  TextStyle get hanziSmall => const TextStyle(
        fontFamily: 'NotoSansSC',
        fontSize: 18,
        fontWeight: FontWeight.w400,
        height: 1.4,
      );

  // ─── Пиньинь ────────────────────────────────────────────────────────────────

  TextStyle get pinyinLarge => GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: _t.accent,
        letterSpacing: 0.5,
      );

  TextStyle get pinyin => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: _t.accent,
        letterSpacing: 0.3,
      );

  // ─── UI-текст ────────────────────────────────────────────────────────────────

  TextStyle get displayLarge => GoogleFonts.dmSans(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: _t.onSurface,
        letterSpacing: -0.5,
        height: 1.2,
      );

  TextStyle get displayMedium => GoogleFonts.dmSans(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: _t.onSurface,
        letterSpacing: -0.3,
        height: 1.25,
      );

  TextStyle get headlineLarge => GoogleFonts.dmSans(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: _t.onSurface,
        letterSpacing: -0.2,
        height: 1.3,
      );

  TextStyle get headlineMedium => GoogleFonts.dmSans(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: _t.onSurface,
        height: 1.4,
      );

  TextStyle get body => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: _t.onSurface,
        height: 1.5,
      );

  TextStyle get bodyMuted => GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: _t.onSurfaceMuted,
        height: 1.5,
      );

  TextStyle get caption => GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: _t.onSurfaceMuted,
        letterSpacing: 0.5,
        height: 1.4,
      );

  TextStyle get captionAllCaps => GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: _t.onSurfaceMuted,
        letterSpacing: 1.2,
        height: 1.4,
      );

  TextStyle get label => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: _t.onSurface,
        height: 1.3,
      );

  TextStyle get labelAccent => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: _t.accent,
        height: 1.3,
      );

  TextStyle get badge => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: Colors.white,
        height: 1.0,
      );

  TextStyle get statNumber => GoogleFonts.dmSans(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: _t.onSurface,
        height: 1.1,
      );

  TextStyle get statLabel => GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: _t.onSurfaceMuted,
        height: 1.3,
      );

  TextStyle get navLabel => GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        height: 1.0,
      );
}
