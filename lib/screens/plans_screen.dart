import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../main.dart';
import '../utils/responsive.dart';
import 'device_info_screen.dart';

class PlansScreen extends ConsumerWidget {
  const PlansScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF051124) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.ipackBlue,
        foregroundColor: AppColors.lightOnPrimary,
        elevation: 0,
        title: const Text(
          'Protection Plans',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context, isDark),
            const SizedBox(height: 24),
            _buildPlansList(context, isDark),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: Responsive.getResponsivePadding(context) * 2,
        horizontal: Responsive.getResponsivePadding(context),
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.ipackBlue.withValues(alpha: 0.04),
        border: Border(
          bottom: BorderSide(
            color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey[200]!,
          ),
        ),
      ),
      child: Column(
        children: [
          Text(
            'Select Device Protection',
            style: TextStyle(
              fontSize: Responsive.getResponsiveFontSize(context, 24),
              fontWeight: FontWeight.w900,
              color: isDark ? Colors.white : AppColors.ipackBlue,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Secure your digital companion against drops, spills, and thefts. Choose the perfect plan below.',
              style: TextStyle(
                fontSize: Responsive.getResponsiveFontSize(context, 14),
                color: isDark ? Colors.white60 : Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlansList(BuildContext context, bool isDark) {
    final plans = [
      {
        'title': 'Basic Plan',
        'price': '₹699/year',
        'coverage': '₹20,000',
        'features': ['Accidental Damage Cover', 'Screen Crack Cover', '6 Claims/Year', 'Standard support response'],
        'color': AppColors.ipackBlue,
        'badge': null,
      },
      {
        'title': 'Standard Plan',
        'price': '₹999/year',
        'coverage': '₹30,000',
        'features': ['Accidental Damage Cover', 'Screen Crack Cover', 'Liquid Spills Cover', '8 Claims/Year', 'Priority support response'],
        'color': AppColors.ipackOrange,
        'badge': 'MOST POPULAR',
      },
      {
        'title': 'Premium Plan',
        'price': '₹1499/year',
        'coverage': '₹50,000',
        'features': ['Full Mechanical Cover', 'Theft Coverage', 'Liquid Damage Cover', 'Unlimited Claims/Year', '24/7 VIP Express Claim Support'],
        'color': Colors.green,
        'badge': 'BEST VALUE',
      },
    ];

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.getResponsivePadding(context) * 1.5,
      ),
      child: Column(
        children: plans.map((plan) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: _buildPlanCard(context, plan, isDark),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPlanCard(BuildContext context, Map<String, dynamic> plan, bool isDark) {
    final planColor = plan['color'] as Color;
    final hasBadge = plan['badge'] != null;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: hasBadge ? planColor : (isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey[200]!),
          width: hasBadge ? 2.0 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badge banner if any
          if (hasBadge)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: planColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  topRight: Radius.circular(14),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                plan['badge'] as String,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      plan['title'] as String,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: isDark ? Colors.white : AppColors.ipackBlue,
                      ),
                    ),
                    Text(
                      plan['price'] as String,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: planColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Coverage limit up to ${plan['coverage']}',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.white60 : Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Divider(height: 1, thickness: 0.5),
                ),
                
                // Features
                ...((plan['features'] as List<String>).map((feature) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: planColor.withValues(alpha: 0.1),
                          ),
                          child: Icon(
                            Icons.check,
                            color: planColor,
                            size: 14,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            feature,
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark ? Colors.white70 : Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                })),
                
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const DeviceInfoScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: planColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Select Plan',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
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
}
