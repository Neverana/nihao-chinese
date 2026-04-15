// lib/core/widgets/app_card.dart

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_tokens.dart';
import '../theme/app_text_styles.dart';

// ─── AppCard ──────────────────────────────────────────────────────────────────

class AppCard extends ConsumerWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final bool isSelected;
  final Color? customBorderColor;
  final double? customRadius;

  const AppCard({
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.isSelected = false,
    this.customBorderColor,
    this.customRadius,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(appTokensProvider);
    final radius = customRadius ?? t.radiusCard;
    final borderColor =
        customBorderColor ?? (isSelected ? t.accent : t.surfaceBorder);

    Widget card = Container(
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: borderColor, width: isSelected ? 2 : 1.5),
        boxShadow: isSelected ? t.buttonShadow : t.cardShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius - 1),
        child: Padding(padding: padding, child: child),
      ),
    );

    if (t.isGlass) {
      card = ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: t.blurStrength, sigmaY: t.blurStrength),
          child: card,
        ),
      );
    }

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: card);
    }
    return card;
  }
}

// ─── AppBackground ────────────────────────────────────────────────────────────

class AppBackground extends ConsumerWidget {
  final Widget child;
  const AppBackground({required this.child, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(appTokensProvider);
    return Container(decoration: t.backgroundDecoration, child: child);
  }
}

// ─── AppChip ──────────────────────────────────────────────────────────────────

class AppChip extends ConsumerWidget {
  final String label;
  final Color? color;
  final IconData? icon;

  const AppChip({required this.label, this.color, this.icon, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(appTokensProvider);
    final ts = AppTextStyles.of(t);
    final chipColor = color ?? t.accent;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(t.radiusChip),
        border: Border.all(color: chipColor.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: chipColor),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: ts.label.copyWith(color: chipColor, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

// ─── SectionHeader ────────────────────────────────────────────────────────────

class SectionHeader extends ConsumerWidget {
  final String title;
  const SectionHeader(this.title, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(appTokensProvider);
    final ts = AppTextStyles.of(t);
    return Padding(
      padding: const EdgeInsets.only(left: 2, bottom: 10, top: 4),
      child: Text(title.toUpperCase(), style: ts.captionAllCaps),
    );
  }
}
