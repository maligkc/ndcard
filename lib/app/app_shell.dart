import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../l10n/gen/app_localizations.dart';

/// 5 sekmeli alt bar: Ana Sayfa, Kartlar, [Kamera - ortada vurgulu, modal],
/// Araçlar, Ayarlar. Kamera bir StatefulShellRoute branch'i değildir; her
/// tıklamada tam ekran /scan route'unu açar.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _onTabTapped(BuildContext context, int visualIndex) {
    if (visualIndex == 2) {
      context.push('/scan');
      return;
    }
    final branchIndex = visualIndex < 2 ? visualIndex : visualIndex - 1;
    navigationShell.goBranch(
      branchIndex,
      initialLocation: branchIndex == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final visualIndex =
        navigationShell.currentIndex < 2 ? navigationShell.currentIndex : navigationShell.currentIndex + 1;

    return CupertinoPageScaffold(
      child: Column(
        children: [
          Expanded(child: navigationShell),
          _BottomBar(
            selectedVisualIndex: visualIndex,
            onTap: (i) => _onTabTapped(context, i),
            items: [
              _BottomBarItem(icon: CupertinoIcons.house, label: l10n.tabHome),
              _BottomBarItem(icon: CupertinoIcons.rectangle_stack, label: l10n.tabCards),
              _BottomBarItem(icon: CupertinoIcons.camera_fill, label: l10n.tabScan),
              _BottomBarItem(icon: CupertinoIcons.square_grid_2x2, label: l10n.tabTools),
              _BottomBarItem(icon: CupertinoIcons.gear, label: l10n.tabSettings),
            ],
          ),
        ],
      ),
    );
  }
}

class _BottomBarItem {
  const _BottomBarItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.selectedVisualIndex,
    required this.onTap,
    required this.items,
  });

  final int selectedVisualIndex;
  final ValueChanged<int> onTap;
  final List<_BottomBarItem> items;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: CupertinoTheme.of(context).barBackgroundColor,
        border: const Border(top: BorderSide(color: CupertinoColors.separator, width: 0.5)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 56,
          child: Row(
            children: List.generate(items.length, (i) {
              final isScan = i == 2;
              final isSelected = selectedVisualIndex == i;
              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onTap(i),
                  child: isScan
                      ? _ScanButton(icon: items[i].icon)
                      : _TabIcon(
                          icon: items[i].icon,
                          label: items[i].label,
                          selected: isSelected,
                        ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _TabIcon extends StatelessWidget {
  const _TabIcon({required this.icon, required this.label, required this.selected});

  final IconData icon;
  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final color = selected
        ? CupertinoTheme.of(context).primaryColor
        : CupertinoColors.secondaryLabel.resolveFrom(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 24, color: color),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(fontSize: 10, color: color)),
      ],
    );
  }
}

class _ScanButton extends StatelessWidget {
  const _ScanButton({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: CupertinoTheme.of(context).primaryColor,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: CupertinoColors.white, size: 22),
      ),
    );
  }
}
