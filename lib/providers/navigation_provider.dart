import 'package:flutter_riverpod/flutter_riverpod.dart';

enum NavItem {
  home,
  policies,
  claims,
  notifications,
  profile,
}

class NavigationNotifier extends StateNotifier<NavItem> {
  NavigationNotifier() : super(NavItem.home);

  void setNavItem(NavItem item) {
    state = item;
  }
}

final navigationProvider = StateNotifierProvider<NavigationNotifier, NavItem>(
  (ref) => NavigationNotifier(),
);
