import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../main.dart';
import '../utils/responsive.dart';
import 'device_info_screen.dart';
import 'device_details_screen.dart';

class PolicyItem {
  final String id;
  final String deviceBrand;
  final String deviceModel;
  final String imei;
  final String coverageAmount;
  final String expiryDate;
  final String planType;

  PolicyItem({
    required this.id,
    required this.deviceBrand,
    required this.deviceModel,
    required this.imei,
    required this.coverageAmount,
    required this.expiryDate,
    required this.planType,
  });
}

class PoliciesScreen extends ConsumerStatefulWidget {
  const PoliciesScreen({super.key});

  @override
  ConsumerState<PoliciesScreen> createState() => _PoliciesScreenState();
}

class _PoliciesScreenState extends ConsumerState<PoliciesScreen> {
  final List<PolicyItem> _policies = [
    PolicyItem(
      id: 'IPK-9842-8812',
      deviceBrand: 'Apple',
      deviceModel: 'iPhone 15 Pro',
      imei: '358941092842105',
      coverageAmount: '₹75,000',
      expiryDate: '14 Jan 2027',
      planType: 'Premium Plan',
    ),
    PolicyItem(
      id: 'IPK-2104-5890',
      deviceBrand: 'Samsung',
      deviceModel: 'Galaxy Buds 2 Pro',
      imei: '884210482904712',
      coverageAmount: '₹15,000',
      expiryDate: '09 Oct 2026',
      planType: 'Standard Plan',
    ),
  ];

  void _removePolicy(String id) {
    setState(() {
      _policies.removeWhere((item) => item.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: Responsive.isMobile(context)
          ? AppBar(
              backgroundColor: isDark ? AppColors.darkSurface : AppColors.ipackBlue,
              foregroundColor: Colors.white,
              elevation: 0,
              title: const Text(
                'My Policies',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          : null,
      body: Responsive.isDesktop(context)
          ? _buildDesktopLayout(context, isDark)
          : _buildMobileLayout(context, isDark),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Policies',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: isDark ? Colors.white : AppColors.ipackBlue,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'All your active protection plans and subscriptions',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.white60 : Colors.grey[600],
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DeviceInfoScreen()),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Buy New Plan'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.ipackOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          _buildPoliciesContent(context, isDark),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!Responsive.isMobile(context)) ...[
            Text(
              'My Policies',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: isDark ? Colors.white : AppColors.ipackBlue,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'All your active protection plans in one place',
              style: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.white60 : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
          ],
          _buildPoliciesContent(context, isDark),
        ],
      ),
    );
  }

  Widget _buildPoliciesContent(BuildContext context, bool isDark) {
    if (_policies.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey[200]!,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.ipackBlue.withValues(alpha: 0.1),
              ),
              child: const Icon(
                Icons.verified_user_outlined,
                size: 40,
                color: AppColors.ipackOrange,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No active policies found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.ipackBlue,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Linked policies under your mobile number will appear here.',
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white54 : Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DeviceInfoScreen()),
                );
              },
              icon: const Icon(Icons.shopping_bag_outlined),
              label: const Text('Purchase A Plan'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.ipackOrange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: _policies.map((policy) {
        return Padding(
          key: ValueKey(policy.id),
          padding: const EdgeInsets.only(bottom: 16),
          child: MeltingSwipeToDelete(
            policyId: policy.id,
            onDeleted: () => _removePolicy(policy.id),
            child: PolicyCardItem(policy: policy, isDark: isDark),
          ),
        );
      }).toList(),
    );
  }
}

class PolicyCardItem extends StatelessWidget {
  final PolicyItem policy;
  final bool isDark;

  const PolicyCardItem({
    super.key,
    required this.policy,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = isDark ? AppColors.ipackOrange : AppColors.ipackBlue;
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DeviceDetailsScreen(
              policy: {
                'deviceName': '${policy.deviceBrand} ${policy.deviceModel}',
                'planName': policy.planType,
                'serialNumber': policy.imei,
                'deviceType': policy.deviceBrand == 'Apple' ? 'phone' : 'headphones',
                'startDate': '14 Jan 2026',
                'endDate': policy.expiryDate,
                'premiumCost': policy.planType == 'Premium Plan' ? '₹299 / mo' : '₹129 / mo',
              },
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey[200]!,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.ipackOrange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        policy.deviceBrand == 'Apple'
                            ? Icons.phone_iphone_rounded
                            : Icons.headphones_rounded,
                        color: AppColors.ipackOrange,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${policy.deviceBrand} ${policy.deviceModel}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : AppColors.ipackBlue,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'IMEI: ${policy.imei}',
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? Colors.white54 : Colors.grey[500],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: activeColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  policy.planType,
                  style: TextStyle(
                    color: activeColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(height: 1, thickness: 0.5),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Coverage Amount',
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? Colors.white54 : Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    policy.coverageAmount,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.ipackBlue,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Expiry Date',
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? Colors.white54 : Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    policy.expiryDate,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
}

class MeltingSwipeToDelete extends StatefulWidget {
  final Widget child;
  final VoidCallback onDeleted;
  final String policyId;

  const MeltingSwipeToDelete({
    super.key,
    required this.child,
    required this.onDeleted,
    required this.policyId,
  });

  @override
  State<MeltingSwipeToDelete> createState() => _MeltingSwipeToDeleteState();
}

class _MeltingSwipeToDeleteState extends State<MeltingSwipeToDelete>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<bool?> _handleDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Protection Plan?'),
        content: const Text(
          'Are you sure you want to cancel this protection plan? This action cannot be undone.',
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('NO, KEEP PLAN'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('YES, CANCEL'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // 1. Initial haptic feedback
      HapticFeedback.heavyImpact();

      // 2. Start the custom Melting Sequence
      setState(() {
        _isDeleting = true;
      });

      // Shaking sequence
      _animController.forward().then((_) {
        widget.onDeleted();
      });
      
      // Secondary minor pulses as it "melts"
      Future.delayed(const Duration(milliseconds: 250), () {
        HapticFeedback.lightImpact();
      });
      Future.delayed(const Duration(milliseconds: 500), () {
        HapticFeedback.lightImpact();
      });
    }
    return false; // Prevent standard dismissible from handling visual removal instantly
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey('dismiss_${widget.policyId}'),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => _handleDelete(),
      background: Container(
        padding: const EdgeInsets.only(right: 24),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(
          Icons.delete_sweep_rounded,
          color: Colors.red,
          size: 32,
        ),
      ),
      child: AnimatedBuilder(
        animation: _animController,
        builder: (context, child) {
          if (!_isDeleting) return child!;

          // Calculate visual transformations based on animation controller progress
          final progress = _animController.value;
          
          // 1. Shaking calculation (sine wave offsets)
          final double shake = 10.0 * (1.0 - progress) * (progress < 0.8 ? math.sin(progress * 10 * math.pi) : 0.0);
          
          // 2. Melting scale & tint values
          final scale = 1.0 - (progress * 0.35); // Shrinks by 35%
          final opacity = (1.0 - progress).clamp(0.0, 1.0);
          final blur = progress * 6.0;

          return Transform.translate(
            offset: Offset(shake, 0),
            child: Transform.scale(
              scale: scale,
              child: Opacity(
                opacity: opacity,
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      Colors.red.withValues(alpha: progress * 0.6),
                      BlendMode.srcATop,
                    ),
                    child: child!,
                  ),
                ),
              ),
            ),
          );
        },
        child: widget.child,
      ),
    );
  }
}
