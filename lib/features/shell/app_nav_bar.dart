import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';

class NavDestination {
  const NavDestination(this.label, this.icon);
  final String label;
  final IconData icon;
}

const navDestinations = <NavDestination>[
  NavDestination('Novos', Icons.chat_rounded),
  NavDestination('Atender', Icons.forum_rounded),
  NavDestination('Catálogo', Icons.two_wheeler_rounded),
  NavDestination('Pós-venda', Icons.handshake_rounded),
];

class AppNavBar extends StatelessWidget {
  const AppNavBar({super.key, required this.index, required this.onTap});

  final int index;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 4),
      child: Row(
        children: [
          for (var i = 0; i < navDestinations.length; i++)
            Expanded(
              child: _NavItem(
                destination: navDestinations[i],
                selected: i == index,
                onTap: () {
                  if (i == index) return;
                  HapticFeedback.selectionClick();
                  onTap(i);
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.destination,
    required this.selected,
    required this.onTap,
  });

  final NavDestination destination;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: destination.label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              width: selected ? 56 : 34,
              height: 32,
              decoration: BoxDecoration(
                color: selected ? AppColors.successSoft : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: AnimatedScale(
                scale: selected ? 1 : 0.94,
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                child: Icon(
                  destination.icon,
                  size: 21,
                  color: selected
                      ? AppColors.primaryDeep
                      : AppColors.inkMuted,
                ),
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              style: jk(
                11,
                selected ? 700 : 600,
                color: selected ? AppColors.primaryDeep : AppColors.inkMuted,
                height: 1,
                letterSpacing: -0.1,
              ),
              child: Text(destination.label),
            ),
          ],
        ),
      ),
    );
  }
}
