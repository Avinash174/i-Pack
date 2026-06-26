import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/theme_provider.dart';
import '../main.dart';
import '../utils/responsive.dart';
import 'login_screen.dart';
import 'help_center_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF051124) : const Color(0xFFF8FAFC),
      appBar: Responsive.isMobile(context)
          ? AppBar(
              backgroundColor: isDark ? AppColors.darkSurface : AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              title: const Text(
                'Profile & Settings',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          : null,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(context, isDark),
            const SizedBox(height: 24),
            _buildProfileMenu(context, ref, isDark),
            const SizedBox(height: 100), // Space to scroll past bottom bar on mobile
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: Responsive.getResponsivePadding(context) * 2.5,
        horizontal: Responsive.getResponsivePadding(context),
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.primary.withValues(alpha: 0.04),
        border: Border(
          bottom: BorderSide(
            color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey[200]!,
          ),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.person_rounded,
                color: Colors.white,
                size: 48,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Avinash Magar',
            style: TextStyle(
              fontFamily: 'SF Pro Display',
              fontSize: Responsive.getResponsiveFontSize(context, 22),
              fontWeight: FontWeight.w900,
              color: isDark ? Colors.white : AppColors.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'avinashmagar@gmail.com',
            style: TextStyle(
              fontSize: Responsive.getResponsiveFontSize(context, 14),
              color: isDark ? Colors.white60 : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 12),
          // Short stat tags row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildHeaderStatBadge('Active Policies: 1', Colors.green, isDark),
              const SizedBox(width: 12),
              _buildHeaderStatBadge('Settled Claims: 1', AppColors.secondary, isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderStatBadge(String label, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildProfileMenu(BuildContext context, WidgetRef ref, bool isDark) {
    final activeThemeMode = ref.watch(themeModeProvider);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.getResponsivePadding(context) * 1.5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Account Preferences', isDark),
          const SizedBox(height: 10),
          _buildMenuContainer(
            isDark: isDark,
            children: [
              _buildMenuItem(
                context,
                icon: Icons.person_outline_rounded,
                title: 'Personal Information',
                subtitle: 'Update address, phone number & details',
                isDark: isDark,
                onTap: () {
                  _showPersonalDetailsDialog(context, isDark);
                },
              ),
              _buildMenuItem(
                context,
                icon: Icons.notifications_none_rounded,
                title: 'Notifications Support',
                subtitle: 'Manage alert sounds & scheduling alerts',
                isDark: isDark,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Notifications settings loaded.')),
                  );
                },
              ),
              // Dynamic Theme Selector Segment Tile
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Appearance Mode',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          Text(
                            'Light, dark, or system mode',
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? Colors.white54 : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    DropdownButton<ThemeModeOption>(
                      value: activeThemeMode,
                      dropdownColor: isDark ? AppColors.darkSurface : Colors.white,
                      style: TextStyle(
                        color: isDark ? Colors.white : AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                      underline: const SizedBox(),
                      onChanged: (val) {
                        if (val != null) {
                          ref.read(themeModeProvider.notifier).setThemeMode(val);
                        }
                      },
                      items: ThemeModeOption.values.map((mode) {
                        return DropdownMenuItem(
                          value: mode,
                          child: Text(mode.name.toUpperCase()),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('Help & Actions', isDark),
          const SizedBox(height: 10),
          _buildMenuContainer(
            isDark: isDark,
            children: [
              _buildMenuItem(
                context,
                icon: Icons.help_outline_rounded,
                title: 'Help Center',
                subtitle: 'Read FAQs, claim terms & conditions',
                isDark: isDark,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HelpCenterScreen()),
                  );
                },
              ),
              _buildMenuItem(
                context,
                icon: Icons.logout_rounded,
                title: 'Logout',
                subtitle: 'Sign out of your session securely',
                isDark: isDark,
                isDestructive: true,
                onTap: () {
                  // Simulate logout by routing back to Login
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white38 : Colors.grey[500],
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildMenuContainer({required List<Widget> children, required bool isDark}) {
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey[200]!,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: List.generate(children.length, (index) {
          if (index == children.length - 1) return children[index];
          return Column(
            children: [
              children[index],
              Divider(
                height: 1,
                thickness: 0.5,
                color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey[100],
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required bool isDark,
    bool isDestructive = false,
  }) {
    final titleColor = isDestructive ? Colors.red : (isDark ? Colors.white : Colors.black87);
    final iconColor = isDestructive ? Colors.red : (isDark ? AppColors.secondary : AppColors.primary);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: titleColor,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 11,
          color: isDark ? Colors.white54 : Colors.grey[600],
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: isDark ? Colors.white24 : Colors.grey[400],
        size: 20,
      ),
      onTap: onTap,
    );
  }

  void _showPersonalDetailsDialog(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          'Personal Details',
          style: TextStyle(
            color: isDark ? Colors.white : AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDialogDetailItem('Name', 'Avinash Magar', isDark),
            const SizedBox(height: 12),
            _buildDialogDetailItem('Email', 'avinashmagar@gmail.com', isDark),
            const SizedBox(height: 12),
            _buildDialogDetailItem('Phone', '+91 98765 43210', isDark),
            const SizedBox(height: 12),
            _buildDialogDetailItem('Registered Address', 'Pune, Maharashtra, India', isDark),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'CLOSE',
              style: TextStyle(
                color: isDark ? AppColors.secondary : AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogDetailItem(String label, String value, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white38 : Colors.grey[500],
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            color: isDark ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
