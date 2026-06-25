import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/responsive.dart';
import '../providers/theme_provider.dart';
import '../main.dart';

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
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(child: _buildHeroSection(context)),
          SliverToBoxAdapter(child: _buildServicesSection(context)),
          SliverToBoxAdapter(child: _buildAboutSection(context)),
          SliverToBoxAdapter(child: _buildContactSection(context)),
          SliverToBoxAdapter(child: _buildFooter(context)),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: AppColors.ipackBlue,
      foregroundColor: AppColors.lightOnPrimary,
      elevation: 0,
      expandedHeight: Responsive.isMobile(context) ? 60 : 80,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'I-PACK',
          style: TextStyle(
            fontSize: Responsive.getResponsiveFontSize(context, 24),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.brightness_6,
            size: Responsive.getResponsiveIconSize(context),
          ),
          onPressed: () {
            _showThemeDialog(context);
          },
        ),
      ],
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: Responsive.getResponsivePadding(context) * 3,
        horizontal: Responsive.getResponsivePadding(context),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.ipackBlue,
            AppColors.ipackBlue.withOpacity(0.8),
          ],
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: Responsive.isDesktop(context) ? 1200 : double.infinity,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to I-PACK',
                style: TextStyle(
                  fontSize: Responsive.getResponsiveFontSize(context, 36),
                  fontWeight: FontWeight.bold,
                  color: AppColors.lightOnPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: Responsive.getResponsiveSpacing(context)),
              Text(
                'Your Trusted Computer Solution Partner',
                style: TextStyle(
                  fontSize: Responsive.getResponsiveFontSize(context, 18),
                  color: AppColors.lightOnPrimary.withOpacity(0.9),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: Responsive.getResponsiveSpacing(context) * 2),
              ElevatedButton(
                onPressed: () {
                  _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent * 0.3,
                    duration: const Duration(seconds: 1),
                    curve: Curves.easeInOut,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.ipackOrange,
                  foregroundColor: AppColors.lightOnSecondary,
                  padding: EdgeInsets.symmetric(
                    horizontal: Responsive.getResponsivePadding(context) * 2,
                    vertical: Responsive.getResponsivePadding(context),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      Responsive.getResponsiveBorderRadius(context),
                    ),
                  ),
                ),
                child: Text(
                  'Get Started',
                  style: TextStyle(
                    fontSize: Responsive.getResponsiveFontSize(context, 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServicesSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: Responsive.getResponsivePadding(context) * 3,
        horizontal: Responsive.getResponsivePadding(context),
      ),
      color: Theme.of(context).colorScheme.surface,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: Responsive.isDesktop(context) ? 1200 : double.infinity,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Our Services',
                style: TextStyle(
                  fontSize: Responsive.getResponsiveFontSize(context, 28),
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(height: Responsive.getResponsiveSpacing(context) * 2),
              _buildServicesGrid(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServicesGrid(BuildContext context) {
    final services = [
      {
        'icon': Icons.computer,
        'title': 'Computer Sales',
        'description': 'New and refurbished computers at best prices',
      },
      {
        'icon': Icons.build,
        'title': 'Repairs & Maintenance',
        'description': 'Expert repair services for all brands',
      },
      {
        'icon': Icons.memory,
        'title': 'Upgrades',
        'description': 'Hardware and software upgrades',
      },
      {
        'icon': Icons.support_agent,
        'title': 'Technical Support',
        'description': '24/7 technical assistance',
      },
      {
        'icon': Icons.security,
        'title': 'Security Solutions',
        'description': 'Antivirus and security software',
      },
      {
        'icon': Icons.cloud,
        'title': 'Cloud Services',
        'description': 'Backup and cloud storage solutions',
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
        childAspectRatio: 1.2,
        crossAxisSpacing: Responsive.getResponsiveSpacing(context),
        mainAxisSpacing: Responsive.getResponsiveSpacing(context),
      ),
      itemCount: services.length,
      itemBuilder: (context, index) {
        return _buildServiceCard(context, services[index]);
      },
    );
  }

  Widget _buildServiceCard(BuildContext context, Map<String, dynamic> service) {
    return Container(
      padding: EdgeInsets.all(Responsive.getResponsivePadding(context)),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(
          Responsive.getResponsiveBorderRadius(context),
        ),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            service['icon'] as IconData,
            size: Responsive.getResponsiveIconSize(context) * 1.5,
            color: AppColors.ipackOrange,
          ),
          SizedBox(height: Responsive.getResponsiveSpacing(context)),
          Text(
            service['title'] as String,
            style: TextStyle(
              fontSize: Responsive.getResponsiveFontSize(context, 18),
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: Responsive.getResponsiveSpacing(context) / 2),
          Text(
            service['description'] as String,
            style: TextStyle(
              fontSize: Responsive.getResponsiveFontSize(context, 14),
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: Responsive.getResponsivePadding(context) * 3,
        horizontal: Responsive.getResponsivePadding(context),
      ),
      color: AppColors.ipackBlue.withOpacity(0.05),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: Responsive.isDesktop(context) ? 1200 : double.infinity,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'About I-PACK',
                style: TextStyle(
                  fontSize: Responsive.getResponsiveFontSize(context, 28),
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(height: Responsive.getResponsiveSpacing(context) * 2),
              Text(
                'I-PACK is your trusted partner for all computer-related needs. '
                'With years of experience in the industry, we provide top-quality '
                'products and services to meet your computing requirements.',
                style: TextStyle(
                  fontSize: Responsive.getResponsiveFontSize(context, 16),
                  color: Theme.of(context).colorScheme.onSurface,
                  height: 1.6,
                ),
              ),
              SizedBox(height: Responsive.getResponsiveSpacing(context)),
              Text(
                'Our commitment to customer satisfaction and technical excellence '
                'has made us a preferred choice for individuals and businesses alike.',
                style: TextStyle(
                  fontSize: Responsive.getResponsiveFontSize(context, 16),
                  color: Theme.of(context).colorScheme.onSurface,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: Responsive.getResponsivePadding(context) * 3,
        horizontal: Responsive.getResponsivePadding(context),
      ),
      color: Theme.of(context).colorScheme.surface,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: Responsive.isDesktop(context) ? 1200 : double.infinity,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Contact Us',
                style: TextStyle(
                  fontSize: Responsive.getResponsiveFontSize(context, 28),
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(height: Responsive.getResponsiveSpacing(context) * 2),
              Responsive.isMobile(context)
                  ? _buildContactColumn(context)
                  : _buildContactRow(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactColumn(BuildContext context) {
    return Column(
      children: [
        _buildContactItem(
          context,
          Icons.location_on,
          'Address',
          'Ganesh Computer, Your City',
        ),
        SizedBox(height: Responsive.getResponsiveSpacing(context)),
        _buildContactItem(
          context,
          Icons.phone,
          'Phone',
          '+91 1234567890',
        ),
        SizedBox(height: Responsive.getResponsiveSpacing(context)),
        _buildContactItem(
          context,
          Icons.email,
          'Email',
          'info@ganeshcomputer.in',
        ),
      ],
    );
  }

  Widget _buildContactRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildContactItem(
            context,
            Icons.location_on,
            'Address',
            'Ganesh Computer, Your City',
          ),
        ),
        SizedBox(width: Responsive.getResponsiveSpacing(context)),
        Expanded(
          child: _buildContactItem(
            context,
            Icons.phone,
            'Phone',
            '+91 1234567890',
          ),
        ),
        SizedBox(width: Responsive.getResponsiveSpacing(context)),
        Expanded(
          child: _buildContactItem(
            context,
            Icons.email,
            'Email',
            'info@ganeshcomputer.in',
          ),
        ),
      ],
    );
  }

  Widget _buildContactItem(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Container(
      padding: EdgeInsets.all(Responsive.getResponsivePadding(context)),
      decoration: BoxDecoration(
        color: AppColors.ipackBlue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(
          Responsive.getResponsiveBorderRadius(context),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: Responsive.getResponsiveIconSize(context),
            color: AppColors.ipackOrange,
          ),
          SizedBox(height: Responsive.getResponsiveSpacing(context) / 2),
          Text(
            label,
            style: TextStyle(
              fontSize: Responsive.getResponsiveFontSize(context, 14),
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          SizedBox(height: Responsive.getResponsiveSpacing(context) / 2),
          Text(
            value,
            style: TextStyle(
              fontSize: Responsive.getResponsiveFontSize(context, 16),
              color: Theme.of(context).colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: Responsive.getResponsivePadding(context) * 2,
        horizontal: Responsive.getResponsivePadding(context),
      ),
      color: AppColors.ipackBlue,
      child: Center(
        child: Column(
          children: [
            Text(
              'I-PACK',
              style: TextStyle(
                fontSize: Responsive.getResponsiveFontSize(context, 24),
                fontWeight: FontWeight.bold,
                color: AppColors.lightOnPrimary,
              ),
            ),
            SizedBox(height: Responsive.getResponsiveSpacing(context)),
            Text(
              '© 2024 I-PACK. All rights reserved.',
              style: TextStyle(
                fontSize: Responsive.getResponsiveFontSize(context, 14),
                color: AppColors.lightOnPrimary.withOpacity(0.8),
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
        title: const Text('Select Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ThemeModeOption.values.map((mode) {
            return ListTile(
              title: Text(mode.name.toUpperCase()),
              leading: Radio<ThemeModeOption>(
                value: mode,
                groupValue: ref.watch(themeModeProvider),
                onChanged: (value) {
                  if (value != null) {
                    ref.read(themeModeProvider.notifier).setThemeMode(value);
                    Navigator.pop(context);
                  }
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
