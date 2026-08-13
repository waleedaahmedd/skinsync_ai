import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomNavItem {
  final String label;
  final FaIconData selectedIcon;
  final FaIconData unselectedIcon;

  const BottomNavItem({
    required this.label,
    required this.selectedIcon,
    required this.unselectedIcon,
  });
}
