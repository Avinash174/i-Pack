import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/navigation_provider.dart';
import '../main.dart';
import '../utils/responsive.dart';
import 'dashboard_screen.dart';
import 'policies_screen.dart';
import 'claims_screen.dart';
import 'notifications_screen.dart';
import 'profile_screen.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentNavItem = ref.watch(navigationProvider);
    
    if (Responsive.isDesktop(context)) {
      return _buildDesktopLayout(context, ref, currentNavItem);
    } else {
      return _buildMobileLayout(context, ref, currentNavItem);
    }
  }

  Widget _buildDesktopLayout(BuildContext context, WidgetRef ref, NavItem currentNavItem) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF051124) : const Color(0xFFF8FAFC),
      body: Row(
        children: [
          _buildSidebar(context, ref, currentNavItem, isDark),
          Expanded(
            child: Column(
              children: [
                _buildTopNavigationBar(context, ref, isDark),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: _getCurrentScreen(currentNavItem, context, ref),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, WidgetRef ref, NavItem currentNavItem) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF051124) : const Color(0xFFF8FAFC),
      extendBody: true, // Let screens flow under the floating navigation bar
      body: SafeArea(
        bottom: false,
        child: _getCurrentScreen(currentNavItem, context, ref),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context, currentNavItem, ref, isDark),
    );
  }

  Widget _buildSidebar(BuildContext context, WidgetRef ref, NavItem currentItem, bool isDark) {
    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        border: Border(
          right: BorderSide(
            color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey[200]!,
          ),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.ipackOrange.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.shield,
                    color: AppColors.ipackOrange,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'I-PACK',
                  style: TextStyle(
                    fontFamily: 'SF Pro Display',
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : AppColors.ipackBlue,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 0.5),
          const SizedBox(height: 20),
          _buildSidebarItem(
            context,
            ref,
            NavItem.home,
            Icons.grid_view_rounded,
            'Home',
            currentItem == NavItem.home,
            isDark,
          ),
          _buildSidebarItem(
            context,
            ref,
            NavItem.policies,
            Icons.verified_user_outlined,
            'My Policies',
            currentItem == NavItem.policies,
            isDark,
          ),
          _buildSidebarItem(
            context,
            ref,
            NavItem.claims,
            Icons.analytics_outlined,
            'My Claims',
            currentItem == NavItem.claims,
            isDark,
          ),
          _buildSidebarItem(
            context,
            ref,
            NavItem.notifications,
            Icons.notifications_none_rounded,
            'Notifications',
            currentItem == NavItem.notifications,
            isDark,
          ),
          _buildSidebarItem(
            context,
            ref,
            NavItem.profile,
            Icons.person_outline_rounded,
            'Profile',
            currentItem == NavItem.profile,
            isDark,
          ),
          const Spacer(),
          _buildSidebarProfile(context, ref, isDark),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(
    BuildContext context,
    WidgetRef ref,
    NavItem item,
    IconData icon,
    String label,
    bool isSelected,
    bool isDark,
  ) {
    final activeColor = isDark ? AppColors.ipackOrange : AppColors.ipackBlue;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        leading: Icon(
          icon,
          color: isSelected ? activeColor : (isDark ? Colors.white54 : Colors.grey[600]),
          size: 22,
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isSelected 
                ? (isDark ? Colors.white : activeColor) 
                : (isDark ? Colors.white70 : Colors.black87),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 14,
          ),
        ),
        selected: isSelected,
        selectedTileColor: activeColor.withValues(alpha: 0.1),
        onTap: () {
          ref.read(navigationProvider.notifier).setNavItem(item);
        },
      ),
    );
  }

  Widget _buildSidebarProfile(BuildContext context, WidgetRef ref, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.03) : Colors.grey[50],
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[200]!,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.ipackOrange,
            radius: 18,
            child: const Text(
              'AM',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Avinash Magar',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'avinash@gmail.com',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? Colors.white54 : Colors.grey[600],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopNavigationBar(BuildContext context, WidgetRef ref, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey[200]!,
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            'Welcome Back, Avinash!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.ipackBlue,
            ),
          ),
          const Spacer(),
          // Profile Screen Navigation Button on Desktop
          IconButton(
            icon: Icon(Icons.account_circle_outlined, color: isDark ? Colors.white70 : Colors.grey[700]),
            tooltip: 'View Profile',
            onPressed: () {
              ref.read(navigationProvider.notifier).setNavItem(NavItem.profile);
            },
          ),
          const SizedBox(width: 12),
          OutlinedButton.icon(
            onPressed: () {
              // Signout simulation
              ref.read(navigationProvider.notifier).setNavItem(NavItem.home);
            },
            icon: const Icon(Icons.logout, size: 16),
            label: const Text('Logout'),
            style: OutlinedButton.styleFrom(
              foregroundColor: isDark ? AppColors.ipackOrange : AppColors.ipackBlue,
              side: BorderSide(color: isDark ? AppColors.ipackOrange : AppColors.ipackBlue),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getCurrentScreen(NavItem item, BuildContext context, WidgetRef ref) {
    switch (item) {
      case NavItem.home:
        return const DashboardScreen();
      case NavItem.policies:
        return const PoliciesScreen();
      case NavItem.claims:
        return const ClaimsScreen();
      case NavItem.notifications:
        return const NotificationsScreen();
      case NavItem.profile:
        return const ProfileScreen();
    }
  }

  Widget _buildBottomNavigationBar(BuildContext context, NavItem currentItem, WidgetRef ref, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 28, top: 4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            decoration: BoxDecoration(
              color: isDark 
                  ? AppColors.darkSurface.withValues(alpha: 0.85) 
                  : Colors.white.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey[200]!,
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: NavItem.values.map((item) {
                  final isSelected = item == currentItem;
                  return _buildBottomNavItem(context, item, isSelected, ref, isDark);
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(BuildContext context, NavItem item, bool isSelected, WidgetRef ref, bool isDark) {
    IconData icon;
    String label;

    switch (item) {
      case NavItem.home:
        icon = Icons.grid_view_rounded;
        label = 'Home';
        break;
      case NavItem.policies:
        icon = Icons.verified_user_rounded;
        label = 'Policies';
        break;
      case NavItem.claims:
        icon = Icons.analytics_rounded;
        label = 'Claims';
        break;
      case NavItem.notifications:
        icon = Icons.notifications_rounded;
        label = 'Alerts';
        break;
      case NavItem.profile:
        icon = Icons.person_rounded;
        label = 'Profile';
        break;
    }

    final activeColor = isDark ? AppColors.ipackOrange : AppColors.ipackBlue;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          ref.read(navigationProvider.notifier).setNavItem(item);
        },
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? activeColor.withValues(alpha: 0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: isSelected ? activeColor : (isDark ? Colors.white54 : Colors.grey[500]),
                  size: 22,
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isSelected ? activeColor : (isDark ? Colors.white54 : Colors.grey[600]),
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
