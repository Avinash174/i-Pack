import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/form_provider.dart';
import '../main.dart';
import 'home_screen.dart';

class ConfirmScreen extends ConsumerWidget {
  const ConfirmScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceInfo = ref.watch(deviceInfoProvider);
    final addOnsState = ref.watch(addOnsProvider);
    final totalPrice = ref.watch(totalPriceProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF051124) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.ipackBlue,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Receipt & Confirmation',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  _buildSuccessIcon(isDark),
                  const SizedBox(height: 20),
                  Text(
                    'Order Confirmed!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: isDark ? Colors.white : AppColors.ipackBlue,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Your device protection plan is now active.',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.white60 : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 28),
                  _buildOrderSummary(deviceInfo, addOnsState, totalPrice, isDark),
                  const SizedBox(height: 20),
                  _buildDeviceInfoCard(deviceInfo, isDark),
                  const SizedBox(height: 20),
                  _buildAddOnsCard(addOnsState, isDark),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          _buildBottomBar(context, ref, isDark),
        ],
      ),
    );
  }

  Widget _buildSuccessIcon(bool isDark) {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.green.withValues(alpha: 0.12),
        border: Border.all(color: Colors.green.withValues(alpha: 0.3), width: 2),
      ),
      child: const Center(
        child: Icon(
          Icons.check_circle_rounded,
          color: Colors.green,
          size: 54,
        ),
      ),
    );
  }

  Widget _buildOrderSummary(
    DeviceInfoState deviceInfo, 
    AddOnsState addOnsState, 
    double totalPrice, 
    bool isDark
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.ipackBlue, Color(0xFF1E5BB0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.ipackBlue.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Plan Cost Breakdown',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 16),
          _buildSummaryRow('Basic Protection Plan', '₹699.00'),
          if (addOnsState.screenProtection) _buildSummaryRow('Screen Protection Cover', '₹199.00'),
          if (addOnsState.liquidDamage) _buildSummaryRow('Liquid Spill Cover', '₹299.00'),
          if (addOnsState.theftProtection) _buildSummaryRow('Theft & Loss Cover', '₹499.00'),
          if (addOnsState.quickClaim) _buildSummaryRow('Quick Claim VIP Queue', '₹149.00'),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: Colors.white24, height: 1, thickness: 0.5),
          ),
          _buildSummaryRow('Annual Subscription Total', '₹${totalPrice.toStringAsFixed(2)}', isBold: true),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isBold ? Colors.white : Colors.white.withValues(alpha: 0.9),
              fontSize: isBold ? 15 : 13,
              fontWeight: isBold ? FontWeight.w900 : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: isBold ? AppColors.ipackOrange : Colors.white,
              fontSize: isBold ? 16 : 13,
              fontWeight: isBold ? FontWeight.w900 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceInfoCard(DeviceInfoState deviceInfo, bool isDark) {
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Insured Device Specs',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.ipackBlue,
            ),
          ),
          const SizedBox(height: 14),
          _buildInfoRow('Device Brand', deviceInfo.brand, isDark),
          _buildInfoRow('Device Model', deviceInfo.model, isDark),
          _buildInfoRow('15-Digit IMEI', deviceInfo.imei, isDark),
          _buildInfoRow('Estimated Market Value', '₹${deviceInfo.marketValue}', isDark),
          _buildInfoRow('Specs Purchase Date', deviceInfo.formattedPurchaseDate, isDark),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
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
      ),
    );
  }

  Widget _buildAddOnsCard(AddOnsState addOnsState, bool isDark) {
    final selectedAddOns = <String>[];
    if (addOnsState.screenProtection) selectedAddOns.add('Screen Protection');
    if (addOnsState.liquidDamage) selectedAddOns.add('Liquid Damage');
    if (addOnsState.theftProtection) selectedAddOns.add('Theft Protection');
    if (addOnsState.quickClaim) selectedAddOns.add('Quick Claim VIP');

    final cardBg = isDark ? AppColors.darkSurface : Colors.white;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bundled Add-ons Selected',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.ipackBlue,
            ),
          ),
          const SizedBox(height: 14),
          if (selectedAddOns.isEmpty)
            Text(
              'No additional add-on components selected.',
              style: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.white38 : Colors.grey[600],
              ),
            )
          else
            ...selectedAddOns.map((addOn) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle_outline_rounded,
                        color: AppColors.ipackOrange,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        addOn,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? Colors.white70 : Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, WidgetRef ref, bool isDark) {
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
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed: () {
            // Reset form steps & providers for subsequent purchases
            ref.read(formStepProvider.notifier).reset();
            ref.read(deviceInfoProvider.notifier).reset();
            ref.read(addOnsProvider.notifier).reset();
            ref.read(paymentProvider.notifier).reset();
            
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false,
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
            'Return to Home Screen',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
