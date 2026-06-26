import 'package:flutter/material.dart';
import '../main.dart';

class DeviceDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> policy;

  const DeviceDetailsScreen({super.key, required this.policy});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: isDark ? Colors.white : AppColors.ipackBlue, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Device Coverage',
          style: TextStyle(
            color: isDark ? Colors.white : AppColors.ipackBlue,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDeviceHeader(context, isDark),
            const SizedBox(height: 24),
            _buildCoverageSection(context, isDark),
            const SizedBox(height: 24),
            _buildPolicyDetailsSection(context, isDark),
            const SizedBox(height: 32),
            _buildActionButtons(context, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceHeader(BuildContext context, bool isDark) {
    final deviceName = policy['deviceName'] ?? 'Unknown Device';
    final planName = policy['planName'] ?? 'Standard Protection';
    final serial = policy['serialNumber'] ?? 'SN-78328-984';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey[200]!,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                ),
                child: const Text(
                  'ACTIVE COVERAGE',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Icon(
                _getDeviceIcon(policy['deviceType'] ?? 'phone'),
                color: AppColors.ipackOrange,
                size: 28,
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            deviceName,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.ipackBlue,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            planName,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.ipackOrange,
            ),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, thickness: 0.5),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Serial Number',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.white54 : Colors.grey[500],
                ),
              ),
              Text(
                serial,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCoverageSection(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 12),
          child: Text(
            'INCLUDED PROTECTION BENEFIT',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
              color: isDark ? Colors.white38 : Colors.grey[500],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey[200]!,
            ),
          ),
          child: Column(
            children: [
              _buildCoverageItem(Icons.edgesensor_high_rounded, 'Accidental Screen Breakage', 'Full replacement coverage', isDark),
              const Divider(height: 24, thickness: 0.5),
              _buildCoverageItem(Icons.water_drop_outlined, 'Liquid & Spill Damages', 'Internal cleaning & component fixes', isDark),
              const Divider(height: 24, thickness: 0.5),
              _buildCoverageItem(Icons.bolt_rounded, 'Hardware Defect & Battery', 'Health level coverage under 70%', isDark),
              const Divider(height: 24, thickness: 0.5),
              _buildCoverageItem(Icons.security_rounded, 'Theft & Loss Assistance', 'Police report verification required', isDark),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCoverageItem(IconData icon, String title, String subtitle, bool isDark) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.ipackBlue.withValues(alpha: 0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.ipackOrange, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? Colors.white54 : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        const Icon(Icons.check_circle_rounded, color: Colors.green, size: 20),
      ],
    );
  }

  Widget _buildPolicyDetailsSection(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 12),
          child: Text(
            'POLICY LOGISTICS',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
              color: isDark ? Colors.white38 : Colors.grey[500],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey[200]!,
            ),
          ),
          child: Column(
            children: [
              _buildDetailRow('Start Date', policy['startDate'] ?? 'June 10, 2026', isDark),
              const SizedBox(height: 12),
              _buildDetailRow('Expiry Date', policy['endDate'] ?? 'June 10, 2027', isDark),
              const SizedBox(height: 12),
              _buildDetailRow('Premium Price', policy['premiumCost'] ?? '\$12.99 / mo', isDark),
              const SizedBox(height: 12),
              _buildDetailRow('Payment Term', 'Annual Renewal Auto-Debit', isDark),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: isDark ? Colors.white54 : Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isDark) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Downloading digital certificate...')),
              );
            },
            icon: const Icon(Icons.download_rounded, size: 18),
            label: const Text('Download Certificate'),
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark ? AppColors.ipackOrange : AppColors.ipackBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: isDark ? AppColors.ipackOrange : AppColors.ipackBlue,
              side: BorderSide(
                color: isDark ? AppColors.ipackOrange : AppColors.ipackBlue,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text('Back to Policies'),
          ),
        ),
      ],
    );
  }

  IconData _getDeviceIcon(String type) {
    switch (type.toLowerCase()) {
      case 'tablet':
        return Icons.tablet_mac_rounded;
      case 'laptop':
      case 'macbook':
        return Icons.laptop_mac_rounded;
      case 'watch':
        return Icons.watch_rounded;
      default:
        return Icons.phone_iphone_rounded;
    }
  }
}
