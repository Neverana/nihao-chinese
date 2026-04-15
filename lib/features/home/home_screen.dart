// lib/features/home/home_screen.dart
// ИЗМЕНЕНИЕ: вкладки Словарь и Каллиграфия подключены к реальным экранам

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_tokens.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_theme_mode.dart';
import '../../core/widgets/app_card.dart';
import '../../data/models/models.dart';
import '../../data/repositories/content_repository.dart';
import '../calligraphy/calligraphy_screen.dart';
import '../dictionary/dictionary_screen.dart';
import '../profile/profile_screen.dart';
import 'providers/home_provider.dart';
import 'widgets/block_card.dart';
import 'widgets/stats_bar.dart';

const _navItems = [
  (icon: Icons.menu_book_outlined,     selected: Icons.menu_book_rounded,     label: 'Курс'),
  (icon: Icons.book_outlined,          selected: Icons.book_rounded,           label: 'Словарь'),
  (icon: Icons.brush_outlined,         selected: Icons.brush_rounded,          label: 'Каллиграфия'),
  (icon: Icons.person_outline_rounded, selected: Icons.person_rounded,         label: 'Профиль'),
];

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width >= 600;

    return AppBackground(
      child: isWide
          ? _WideLayout(
              selectedIndex: _selectedNavIndex,
              onNavTap: (i) => setState(() => _selectedNavIndex = i),
            )
          : _MobileLayout(
              selectedIndex: _selectedNavIndex,
              onNavTap: (i) => setState(() => _selectedNavIndex = i),
            ),
    );
  }
}

class _MobileLayout extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onNavTap;
  const _MobileLayout({required this.selectedIndex, required this.onNavTap});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.transparent,
        appBar: selectedIndex == 3 ? null : _HomeTopBar(),
        body: _pageForIndex(selectedIndex),
        bottomNavigationBar: _AppBottomNav(selectedIndex: selectedIndex, onTap: onNavTap),
      );
}

class _WideLayout extends ConsumerWidget {
  final int selectedIndex;
  final ValueChanged<int> onNavTap;
  const _WideLayout({required this.selectedIndex, required this.onNavTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(appTokensProvider);
    return Row(
      children: [
        _SideNav(selectedIndex: selectedIndex, onTap: onNavTap),
        Container(width: 1, color: t.navBarBorder),
        Expanded(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: selectedIndex == 3 ? null : _HomeTopBar(isWide: true),
            body: _pageForIndex(selectedIndex),
          ),
        ),
      ],
    );
  }
}

class _SideNav extends ConsumerWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;
  const _SideNav({required this.selectedIndex, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(appTokensProvider);
    final ts = AppTextStyles.of(t);

    return Container(
      width: 200,
      color: t.navBarBackground.withValues(alpha: 0.9),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Text('🐉', style: TextStyle(fontSize: 28)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('汉语',
                            style: ts.hanziSmall.copyWith(
                                color: t.accent, fontWeight: FontWeight.w700)),
                        Text('Курс китайского',
                            style: ts.caption.copyWith(color: t.sideNavSubtitleColor)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            for (int i = 0; i < _navItems.length; i++)
              _SideNavItem(
                icon: _navItems[i].icon,
                selectedIcon: _navItems[i].selected,
                label: _navItems[i].label,
                isSelected: i == selectedIndex,
                onTap: () => onTap(i),
              ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text('v0.1.0 · alpha',
                  style: ts.caption.copyWith(color: t.onSurfaceDisabled)),
            ),
          ],
        ),
      ),
    );
  }
}

class _SideNavItem extends ConsumerWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _SideNavItem({
    required this.icon, required this.selectedIcon,
    required this.label, required this.isSelected, required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(appTokensProvider);
    final ts = AppTextStyles.of(t);
    final color = isSelected ? t.navBarSelectedColor : t.navBarUnselectedColor;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? t.accentSoft : Colors.transparent,
          borderRadius: BorderRadius.circular(t.radiusButton),
        ),
        child: Row(
          children: [
            Icon(isSelected ? selectedIcon : icon, color: color, size: 20),
            const SizedBox(width: 12),
            Text(label,
                style: ts.headlineMedium.copyWith(
                  color: color,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                )),
          ],
        ),
      ),
    );
  }
}

class _HomeTopBar extends ConsumerWidget implements PreferredSizeWidget {
  final bool isWide;
  const _HomeTopBar({this.isWide = false});

  @override
  Size get preferredSize => const Size.fromHeight(68);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(appTokensProvider);
    final ts = AppTextStyles.of(t);
    final stats = ref.watch(userStatsProvider);
    const currentHsk = 'HSK 1';

    Widget bar = Container(
      height: 68,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: t.isGlass ? t.surface : t.navBarBackground,
        border: Border(bottom: BorderSide(color: t.navBarBorder, width: 1)),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            if (!isWide) ...[
              const Text('🐉', style: TextStyle(fontSize: 24)),
              const SizedBox(width: 10),
            ],
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Курс китайского', style: ts.displayMedium),
                  const SizedBox(height: 1),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: t.accentSoft,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(currentHsk,
                        style: ts.caption.copyWith(
                            color: t.accent, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ),
            _TopBarBadge(icon: Icons.local_fire_department_rounded,
                value: '${stats.fireCount}', bg: t.badgeFireBg, fg: t.badgeFireFg),
            const SizedBox(width: 8),
            _TopBarBadge(icon: Icons.star_rounded,
                value: '${stats.starCount}', bg: t.badgeStarBg, fg: t.badgeStarFg),
            const SizedBox(width: 4),
            const _ThemeToggleButton(),
          ],
        ),
      ),
    );

    if (t.isGlass) {
      bar = ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: bar,
        ),
      );
    }
    return bar;
  }
}

class _TopBarBadge extends ConsumerWidget {
  final IconData icon;
  final String value;
  final Color bg;
  final Color fg;
  const _TopBarBadge({required this.icon, required this.value,
      required this.bg, required this.fg});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(appTokensProvider);
    final ts = AppTextStyles.of(t);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(t.radiusChip),
        border: Border.all(color: fg.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, color: fg, size: 16),
        const SizedBox(width: 4),
        Text(value, style: ts.badge.copyWith(color: fg)),
      ]),
    );
  }
}

class _ThemeToggleButton extends ConsumerWidget {
  const _ThemeToggleButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(appTokensProvider);
    return GestureDetector(
      onTap: () => _showThemePicker(context, ref),
      child: Container(
        width: 36, height: 36,
        margin: const EdgeInsets.only(left: 8),
        decoration: BoxDecoration(
          color: t.surfaceHighlight,
          shape: BoxShape.circle,
          border: Border.all(color: t.surfaceBorder, width: 1.5),
        ),
        child: Icon(Icons.palette_outlined, color: t.onSurfaceMuted, size: 17),
      ),
    );
  }

  void _showThemePicker(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => const _ThemePickerSheet(),
    );
  }
}

class _ThemePickerSheet extends ConsumerWidget {
  const _ThemePickerSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(appTokensProvider);
    final ts = AppTextStyles.of(t);
    final current = ref.watch(appThemeModeProvider);

    final themes = [
      (AppThemeMode.lightGlass, 'Light\nGlass',
          [const Color(0xFFC8D8FF), const Color(0xFFE0C8FF), const Color(0xFFC8F0E8)]),
      (AppThemeMode.darkGlass, 'Dark\nGlass',
          [const Color(0xFF0D0D1A), const Color(0xFF111830), const Color(0xFF0A1A0F)]),
      (AppThemeMode.lightMaterial, 'Light\nMaterial',
          [const Color(0xFFFFF4EC), const Color(0xFFFCF0FF), const Color(0xFFECF4FF)]),
      (AppThemeMode.blackMaterial, 'Blue\nMaterial',
          [const Color(0xFF0F1621), const Color(0xFF1C2535), const Color(0xFF243040)]),
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      decoration: BoxDecoration(
        color: t.isGlass ? t.surface.withValues(alpha: 0.97) : t.navBarBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(top: BorderSide(color: t.surfaceBorder, width: 1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36, height: 4,
              decoration: BoxDecoration(
                  color: t.surfaceBorder, borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 20),
          Text('Внешний вид', style: ts.displayMedium),
          const SizedBox(height: 16),
          Row(
            children: themes.map((theme) {
              final isSelected = current == theme.$1;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    ref.read(appThemeModeProvider.notifier).setTheme(theme.$1);
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: 64,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: theme.$3,
                            ),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isSelected ? t.accent : t.surfaceBorder,
                              width: isSelected ? 2.5 : 1,
                            ),
                            boxShadow: isSelected
                                ? [BoxShadow(
                                    color: t.accent.withValues(alpha: 0.3),
                                    blurRadius: 12, offset: const Offset(0, 4))]
                                : [],
                          ),
                          child: isSelected
                              ? Center(
                                  child: Container(
                                    width: 22, height: 22,
                                    decoration: BoxDecoration(color: t.accent, shape: BoxShape.circle),
                                    child: const Icon(Icons.check_rounded, color: Colors.white, size: 14),
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(height: 6),
                        Text(theme.$2,
                            style: ts.caption.copyWith(
                              color: isSelected ? t.accent : t.onSurfaceMuted,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                            ),
                            textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _AppBottomNav extends ConsumerWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;
  const _AppBottomNav({required this.selectedIndex, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(appTokensProvider);
    final ts = AppTextStyles.of(t);

    Widget bar = Container(
      height: 72,
      decoration: BoxDecoration(
        color: t.navBarBackground,
        border: Border(top: BorderSide(color: t.navBarBorder, width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_navItems.length, (i) {
            final item = _navItems[i];
            final isSelected = i == selectedIndex;
            final color = isSelected ? t.navBarSelectedColor : t.navBarUnselectedColor;
            return GestureDetector(
              onTap: () => onTap(i),
              behavior: HitTestBehavior.opaque,
              child: SizedBox(
                width: 72,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOut,
                      width: isSelected ? 48 : 36,
                      height: isSelected ? 32 : 28,
                      decoration: BoxDecoration(
                        color: isSelected ? t.accentSoft : Colors.transparent,
                        borderRadius: BorderRadius.circular(t.radiusChip),
                      ),
                      child: Icon(isSelected ? item.selected : item.icon,
                          color: color, size: 22),
                    ),
                    const SizedBox(height: 3),
                    Text(item.label, style: ts.navLabel.copyWith(color: color)),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );

    if (t.isGlass) {
      bar = ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: bar,
        ),
      );
    }
    return bar;
  }
}

// ИЗМЕНЕНИЕ: вкладки 1 и 2 подключены
Widget _pageForIndex(int index) => switch (index) {
      0 => const _CourseTab(),
      1 => const DictionaryScreen(),
      2 => const CalligraphyScreen(),
      3 => const ProfileScreen(),
      _ => const _CourseTab(),
    };

class _CourseTab extends ConsumerWidget {
  const _CourseTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blocks = ref.watch(homeBlocksProvider);
    final stats = ref.watch(userStatsProvider);
    final repo = ref.watch(contentRepositoryProvider);
    final width = MediaQuery.of(context).size.width;
    final isWide = width >= 900;

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.symmetric(
              horizontal: isWide ? 48 : 16, vertical: 20),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              SectionHeader('Ваша статистика'),
              const SizedBox(height: 4),
              if (isWide) _WideStatsRow(stats: stats) else StatsBar(stats: stats),
              const SizedBox(height: 24),
              SectionHeader('Блок 1 · Основы общения'),
              const SizedBox(height: 4),
              if (isWide)
                _WideBlockGrid(blocks: blocks, repo: repo)
              else
                for (final block in blocks) ...[
                  BlockCard(
                    block: block,
                    onTap: block.status.isAccessible
                        ? () {
                            final allBlocks = repo.getAllBlocks();
                            final realBlock = allBlocks.firstWhere(
                              (b) => b.order == block.order,
                              orElse: () => allBlocks.first,
                            );
                            context.push('/block/${realBlock.id}');
                          }
                        : null,
                  ),
                  const SizedBox(height: 12),
                ],
              const SizedBox(height: 32),
            ]),
          ),
        ),
      ],
    );
  }
}

class _WideBlockGrid extends ConsumerWidget {
  final List<BlockModel> blocks;
  final ContentRepository repo;
  const _WideBlockGrid({required this.blocks, required this.repo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    final cardWidth = (width - 96 - 16) / 2;
    final allBlocks = repo.getAllBlocks();

    return Wrap(
      spacing: 16, runSpacing: 16,
      children: blocks.map((block) {
        final realBlock = allBlocks.firstWhere(
          (b) => b.order == block.order,
          orElse: () => allBlocks.first,
        );
        return SizedBox(
          width: cardWidth,
          child: BlockCard(
            block: block,
            onTap: block.status.isAccessible
                ? () => context.push('/block/${realBlock.id}')
                : null,
          ),
        );
      }).toList(),
    );
  }
}

class _WideStatsRow extends ConsumerWidget {
  final UserStats stats;
  const _WideStatsRow({required this.stats});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(appTokensProvider);
    final ts = AppTextStyles.of(t);

    final items = [
      (Icons.menu_book_rounded, t.accent, '${stats.wordsLearned}', 'Слов изучено'),
      (Icons.local_fire_department_rounded, t.accentWarn, '${stats.streakDays}', 'Дней подряд'),
      (Icons.access_time_rounded, t.accentSuccess, '${stats.totalHours}ч', 'Время занятий'),
      (Icons.flag_rounded, t.accentSecondary, '${stats.topicsCompleted}', 'Тем пройдено'),
    ];

    return Row(
      children: items.indexed.map((rec) {
        final i = rec.$1;
        final item = rec.$2;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i < items.length - 1 ? 12 : 0),
            child: AppCard(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
              child: Row(
                children: [
                  Container(
                    width: 38, height: 38,
                    decoration: BoxDecoration(
                      color: item.$2.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(item.$1, color: item.$2, size: 19),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.$3, style: ts.statNumber),
                      Text(item.$4, style: ts.statLabel),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
