import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/form_provider.dart';
import '../main.dart';
import 'payment_screen.dart';

class AddOnsScreen extends ConsumerStatefulWidget {
  const AddOnsScreen({super.key});

  @override
  ConsumerState<AddOnsScreen> createState() => _AddOnsScreenState();
}

class _AddOnsScreenState extends ConsumerState<AddOnsScreen> {
  @override
  Widget build(BuildContext context) {
    final addOnsState = ref.watch(addOnsProvider);
    final totalPrice = ref.watch(totalPriceProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF051124) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.ipackBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Customize Coverage',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildStepsIndicator(isDark),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Select Add-on Protections',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: isDark ? Colors.white : AppColors.ipackBlue,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Boost your plan protection with optional components',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white60 : Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildAddOnCard(
                    context,
                    ref,
                    title: 'Screen Protection Cover',
                    description: 'Cover crack displays, pixels bleed, & touch errors.',
                    price: '₹199',
                    icon: Icons.screen_rotation_rounded,
                    isSelected: addOnsState.screenProtection,
                    onTap: () => ref.read(addOnsProvider.notifier).toggleScreenProtection(!addOnsState.screenProtection),
                    isDark: isDark,
                  ),
                  _buildAddOnCard(
                    context,
                    ref,
                    title: 'Liquid & Spill Protection',
                    description: 'Guard against accidental beverage drops & water submersion.',
                    price: '₹299',
                    icon: Icons.water_drop_rounded,
                    isSelected: addOnsState.liquidDamage,
                    onTap: () => ref.read(addOnsProvider.notifier).toggleLiquidDamage(!addOnsState.liquidDamage),
                    isDark: isDark,
                  ),
                  _buildAddOnCard(
                    context,
                    ref,
                    title: 'Theft & Loss Cover',
                    description: 'Secure reimbursement credits for stolen or lost devices.',
                    price: '₹499',
                    icon: Icons.vpn_lock_rounded,
                    isSelected: addOnsState.theftProtection,
                    onTap: () => ref.read(addOnsProvider.notifier).toggleTheftProtection(!addOnsState.theftProtection),
                    isDark: isDark,
                  ),
                  _buildAddOnCard(
                    context,
                    ref,
                    title: 'Quick Express Claim Service',
                    description: 'Priority VIP processing queue, guaranteed fast approval within 12 hours.',
                    price: '₹149',
                    icon: Icons.bolt_rounded,
                    isSelected: addOnsState.quickClaim,
                    onTap: () => ref.read(addOnsProvider.notifier).toggleQuickClaim(!addOnsState.quickClaim),
                    showActiveTag: true,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          _buildBottomBar(context, totalPrice, isDark),
        ],
      ),
    );
  }

  Widget _buildStepsIndicator(bool isDark) {
    final currentStep = FormStep.addOns;
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey[200]!,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: FormStep.values.map((step) {
          final index = step.index;
          final isActive = step == currentStep;
          final isCompleted = index < currentStep.index;
          
          return Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: isActive || isCompleted
                      ? const LinearGradient(
                          colors: [AppColors.ipackBlue, AppColors.ipackOrange],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: !isActive && !isCompleted
                      ? (isDark ? Colors.white.withValues(alpha: 0.06) : Colors.grey[200])
                      : null,
                ),
                child: Center(
                  child: isCompleted
                      ? const Icon(Icons.done_rounded, color: Colors.white, size: 18)
                      : Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: isActive || isCompleted 
                                ? Colors.white 
                                : (isDark ? Colors.white38 : Colors.grey[600]),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                ),
              ),
              if (index < FormStep.values.length - 1)
                Container(
                  width: 48,
                  height: 3,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: isCompleted
                        ? AppColors.ipackOrange
                        : (isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey[300]!),
                  ),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAddOnCard(
    BuildContext context,
    WidgetRef ref,
    {
      required String title,
      required String description,
      required String price,
      required IconData icon,
      required bool isSelected,
      required VoidCallback onTap,
      required bool isDark,
      bool showActiveTag = false,
    }
  ) {
    final activeColor = isDark ? AppColors.ipackOrange : AppColors.ipackBlue;
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withValues(alpha: 0.04) : cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? activeColor : (isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey[200]!),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: (isSelected ? activeColor : Colors.grey).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? activeColor : (isDark ? Colors.white30 : Colors.grey[500]),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: isSelected 
                                ? (isDark ? Colors.white : AppColors.ipackBlue) 
                                : (isDark ? Colors.white70 : Colors.black87),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (showActiveTag) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.ipackOrange,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'RECOMMENDED',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white54 : Colors.grey[600],
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  price,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: isSelected ? activeColor : (isDark ? Colors.white70 : Colors.black87),
                  ),
                ),
                const SizedBox(height: 10),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? activeColor : Colors.transparent,
                    border: Border.all(
                      color: isSelected ? activeColor : (isDark ? Colors.white24 : Colors.grey[400]!),
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, color: Colors.white, size: 14)
                      : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, double totalPrice, bool isDark) {
    final bottomBg = isDark ? AppColors.darkSurface : Colors.white;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: bottomBg,
        border: Border(
          top: BorderSide(
            color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey[200]!,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Price:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white70 : Colors.grey[700],
                ),
              ),
              Text(
                '₹${totalPrice.toStringAsFixed(0)}/year',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: isDark ? AppColors.ipackOrange : AppColors.ipackBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextButton.icon(
                  onPressed: () {
                    ref.read(addOnsProvider.notifier).loadDemoData();
                  },
                  icon: const Icon(Icons.auto_awesome, size: 14),
                  label: const Text('Demo Choices'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.ipackOrange,
                    textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PaymentScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? AppColors.ipackOrange : AppColors.ipackBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Continue to Payment',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
