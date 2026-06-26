import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/responsive.dart';
import '../providers/theme_provider.dart';
import '../main.dart';
import 'login_screen.dart';
import 'device_info_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF051124) : const Color(0xFFF8FAFC),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildAppBar(context, isDark),
          SliverToBoxAdapter(child: _buildHeroSection(context, isDark)),
          SliverToBoxAdapter(child: _buildServicesSection(context, isDark)),
          SliverToBoxAdapter(child: _buildAboutSection(context, isDark)),
          SliverToBoxAdapter(child: _buildContactSection(context, isDark)),
          SliverToBoxAdapter(child: _buildFooter(context, isDark)),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, bool isDark) {
    return SliverAppBar(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.ipackBlue,
      foregroundColor: AppColors.lightOnPrimary,
      elevation: 0,
      expandedHeight: Responsive.isMobile(context) ? 64 : 80,
      pinned: true,
      centerTitle: false,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.ipackOrange.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.shield_outlined,
              color: AppColors.ipackOrange,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'I-PACK',
            style: TextStyle(
              fontSize: Responsive.getResponsiveFontSize(context, 22),
              fontWeight: FontWeight.w900,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: TextButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            icon: const Icon(Icons.login_rounded, color: Colors.white, size: 18),
            label: Text(
              'Sign In',
              style: TextStyle(
                color: AppColors.lightOnPrimary,
                fontSize: Responsive.getResponsiveFontSize(context, 14),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.palette_outlined,
            size: Responsive.getResponsiveIconSize(context),
            color: Colors.white,
          ),
          onPressed: () {
            _showThemeDialog(context);
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildHeroSection(BuildContext context, bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: Responsive.getResponsivePadding(context) * 3.5,
        horizontal: Responsive.getResponsivePadding(context) * 1.5,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            isDark ? AppColors.darkSurface : AppColors.ipackBlue,
            isDark ? const Color(0xFF051124) : AppColors.ipackBlue.withValues(alpha: 0.85),
          ],
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: Responsive.isDesktop(context) ? 1100 : double.infinity,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.ipackOrange.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.ipackOrange.withValues(alpha: 0.3)),
                ),
                child: Text(
                  'SMART DEVICE INSURANCE',
                  style: TextStyle(
                    fontSize: Responsive.getResponsiveFontSize(context, 11),
                    color: AppColors.ipackOrange,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Apne Device Ko Protection Do,\nBefikar Raho!',
                style: TextStyle(
                  fontSize: Responsive.getResponsiveFontSize(context, 34),
                  fontWeight: FontWeight.w900,
                  color: AppColors.lightOnPrimary,
                  height: 1.25,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Premium Protection Plans for Smartphones & Digital Accessories.',
                style: TextStyle(
                  fontSize: Responsive.getResponsiveFontSize(context, 16),
                  color: AppColors.lightOnPrimary.withValues(alpha: 0.8),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              _buildFeatureTags(context),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const DeviceInfoScreen()),
                      );
                    },
                    icon: const Icon(Icons.shield_outlined, size: 20),
                    label: Text(
                      'View Plans',
                      style: TextStyle(
                        fontSize: Responsive.getResponsiveFontSize(context, 15),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.ipackOrange,
                      foregroundColor: AppColors.lightOnSecondary,
                      padding: EdgeInsets.symmetric(
                        horizontal: Responsive.getResponsivePadding(context) * 1.8,
                        vertical: Responsive.getResponsivePadding(context) * 1.2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                  ),
                  const SizedBox(width: 16),
                  OutlinedButton.icon(
                    onPressed: () {
                      _scrollController.animateTo(
                        _scrollController.position.maxScrollExtent * 0.45,
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeInOut,
                      );
                    },
                    icon: const Icon(Icons.help_outline, size: 20),
                    label: Text(
                      'How to Claim',
                      style: TextStyle(
                        fontSize: Responsive.getResponsiveFontSize(context, 15),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.lightOnPrimary,
                      side: const BorderSide(color: Colors.white, width: 1.5),
                      padding: EdgeInsets.symmetric(
                        horizontal: Responsive.getResponsivePadding(context) * 1.8,
                        vertical: Responsive.getResponsivePadding(context) * 1.2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureTags(BuildContext context) {
    final features = [
      'Accidental Damage Cover',
      'Liquid Spill Protection',
      'Theft Protection',
      'Quick Claims Settlement',
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: features.map((feature) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.lightOnPrimary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.lightOnPrimary.withValues(alpha: 0.12)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: AppColors.ipackOrange,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                feature,
                style: TextStyle(
                  color: AppColors.lightOnPrimary,
                  fontSize: Responsive.getResponsiveFontSize(context, 12),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildServicesSection(BuildContext context, bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: Responsive.getResponsivePadding(context) * 4,
        horizontal: Responsive.getResponsivePadding(context) * 1.5,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: Responsive.isDesktop(context) ? 1100 : double.infinity,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Protection Coverage',
                style: TextStyle(
                  fontSize: Responsive.getResponsiveFontSize(context, 28),
                  fontWeight: FontWeight.w900,
                  color: isDark ? Colors.white : AppColors.ipackBlue,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Explore the diverse components we support and cover',
                style: TextStyle(
                  fontSize: Responsive.getResponsiveFontSize(context, 14),
                  color: isDark ? Colors.white60 : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 36),
              _buildServicesGrid(context, isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServicesGrid(BuildContext context, bool isDark) {
    final services = [
      {
        'icon': Icons.screen_lock_landscape,
        'title': 'Accidental Damage',
        'description': 'Impact & physical drop cover for hardware components.',
        'price': 'Starts ₹699/year',
      },
      {
        'icon': Icons.phonelink_erase,
        'title': 'Screen Protection',
        'description': 'Cracked display glass repairs & touchscreen replacement.',
        'price': 'Starts ₹199/year',
      },
      {
        'icon': Icons.opacity,
        'title': 'Liquid Damage',
        'description': 'Internal circuitry spills & water submersions protection.',
        'price': 'Starts ₹299/year',
      },
      {
        'icon': Icons.location_off,
        'title': 'Theft Cover',
        'description': 'Device robbery cover with quick replacement credits.',
        'price': 'Starts ₹499/year',
      },
      {
        'icon': Icons.headphones,
        'title': 'Accessories',
        'description': 'Earbuds, premium smart chargers & wearables safety plans.',
        'price': 'Starts ₹299/year',
      },
      {
        'icon': Icons.bolt,
        'title': 'Quick Claims Settlement',
        'description': 'Hassle-free 24-hour verification approval cycle.',
        'price': 'Included in premium plans',
        'isActive': true,
      },
    ];

    final crossAxisCount = Responsive.isMobile(context)
        ? 1
        : Responsive.isTablet(context)
            ? 2
            : 3;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: Responsive.isMobile(context) ? 1.4 : 1.15,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemCount: services.length,
      itemBuilder: (context, index) {
        return _buildServiceCard(context, services[index], isDark);
      },
    );
  }

  Widget _buildServiceCard(BuildContext context, Map<String, dynamic> service, bool isDark) {
    final isActive = service['isActive'] as bool? ?? false;
    final cardBg = isDark
        ? AppColors.darkSurface
        : (isActive ? AppColors.ipackBlue.withValues(alpha: 0.03) : Colors.white);
    final borderCol = isActive
        ? AppColors.ipackOrange
        : (isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey[200]!);

    return Container(
      padding: EdgeInsets.all(Responsive.getResponsivePadding(context) * 1.5),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderCol,
          width: isActive ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (isActive ? AppColors.ipackOrange : AppColors.ipackBlue)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  service['icon'] as IconData,
                  size: 28,
                  color: isActive ? AppColors.ipackOrange : AppColors.ipackBlue,
                ),
              ),
              if (isActive)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.ipackOrange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'HOT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            service['title'] as String,
            style: TextStyle(
              fontSize: Responsive.getResponsiveFontSize(context, 16),
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.ipackBlue,
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: Text(
              service['description'] as String,
              style: TextStyle(
                fontSize: Responsive.getResponsiveFontSize(context, 12),
                color: isDark ? Colors.white60 : Colors.grey[600],
                height: 1.4,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            service['price'] as String,
            style: TextStyle(
              fontSize: Responsive.getResponsiveFontSize(context, 13),
              fontWeight: FontWeight.bold,
              color: AppColors.ipackOrange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context, bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: Responsive.getResponsivePadding(context) * 4,
        horizontal: Responsive.getResponsivePadding(context) * 1.5,
      ),
      color: isDark ? Colors.white.withValues(alpha: 0.02) : AppColors.ipackBlue.withValues(alpha: 0.03),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: Responsive.isDesktop(context) ? 1100 : double.infinity,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'About I-PACK',
                style: TextStyle(
                  fontSize: Responsive.getResponsiveFontSize(context, 28),
                  fontWeight: FontWeight.w900,
                  color: isDark ? Colors.white : AppColors.ipackBlue,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'I-PACK is a next-generation digital coverage provider tailored to safe-keep your digital companion devices. We support robust protections starting at highly competitive price tags to eliminate stress regarding repair costs or replacements. With fully digital onboarding and paperless claim structures, we promise a seamless experience.',
                style: TextStyle(
                  fontSize: Responsive.getResponsiveFontSize(context, 15),
                  color: isDark ? Colors.white70 : Colors.grey[750]!,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactSection(BuildContext context, bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: Responsive.getResponsivePadding(context) * 4,
        horizontal: Responsive.getResponsivePadding(context) * 1.5,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: Responsive.isDesktop(context) ? 1100 : double.infinity,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Get In Touch',
                style: TextStyle(
                  fontSize: Responsive.getResponsiveFontSize(context, 28),
                  fontWeight: FontWeight.w900,
                  color: isDark ? Colors.white : AppColors.ipackBlue,
                ),
              ),
              const SizedBox(height: 24),
              Responsive.isMobile(context)
                  ? _buildContactColumn(context, isDark)
                  : _buildContactRow(context, isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactColumn(BuildContext context, bool isDark) {
    return Column(
      children: [
        _buildContactItem(context, Icons.location_on_outlined, 'Corporate Office', 'Mumbai Tech Hub, BKC, India', isDark),
        const SizedBox(height: 16),
        _buildContactItem(context, Icons.phone_in_talk_outlined, 'Helpline Call', '1800-123-4725', isDark),
        const SizedBox(height: 16),
        _buildContactItem(context, Icons.mail_outline, 'Official Support', 'support@i-pack.in', isDark),
      ],
    );
  }

  Widget _buildContactRow(BuildContext context, bool isDark) {
    return Row(
      children: [
        Expanded(
          child: _buildContactItem(context, Icons.location_on_outlined, 'Corporate Office', 'Mumbai Tech Hub, BKC, India', isDark),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildContactItem(context, Icons.phone_in_talk_outlined, 'Helpline Call', '1800-123-4725', isDark),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildContactItem(context, Icons.mail_outline, 'Official Support', 'support@i-pack.in', isDark),
        ),
      ],
    );
  }

  Widget _buildContactItem(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    bool isDark,
  ) {
    return Container(
      padding: EdgeInsets.all(Responsive.getResponsivePadding(context) * 1.5),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16),
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
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.ipackOrange.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 24,
              color: AppColors.ipackOrange,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: Responsive.getResponsiveFontSize(context, 13),
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white70 : Colors.grey[500],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: Responsive.getResponsiveFontSize(context, 15),
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.ipackBlue,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context, bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: Responsive.getResponsivePadding(context) * 2.5,
        horizontal: Responsive.getResponsivePadding(context) * 1.5,
      ),
      color: isDark ? AppColors.darkSurface : AppColors.ipackBlue,
      child: Center(
        child: Column(
          children: [
            Text(
              'I-PACK Protection Services',
              style: TextStyle(
                fontSize: Responsive.getResponsiveFontSize(context, 20),
                fontWeight: FontWeight.w900,
                color: AppColors.lightOnPrimary,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '© 2026 I-PACK. Built securely under strict regulatory guidelines.',
              style: TextStyle(
                fontSize: Responsive.getResponsiveFontSize(context, 13),
                color: AppColors.lightOnPrimary.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Appearance'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ThemeModeOption.values.map((mode) {
            return ListTile(
              title: Text(mode.name.toUpperCase()),
              trailing: ref.watch(themeModeProvider) == mode
                  ? const Icon(Icons.check_circle, color: AppColors.ipackOrange)
                  : null,
              onTap: () {
                ref.read(themeModeProvider.notifier).setThemeMode(mode);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
