import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/form_provider.dart';
import '../main.dart';
import 'confirm_screen.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({super.key});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  @override
  Widget build(BuildContext context) {
    final paymentState = ref.watch(paymentProvider);
    final totalPrice = ref.watch(totalPriceProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.ipackBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Payment Gateway',
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
                  _buildPaymentMethods(paymentState, isDark),
                  if (paymentState.paymentMethod == 'card') ...[
                    const SizedBox(height: 24),
                    _buildCardForm(paymentState, isDark),
                  ] else if (paymentState.paymentMethod == 'upi') ...[
                    const SizedBox(height: 24),
                    _buildUpiForm(paymentState, isDark),
                  ],
                  if (paymentState.error != null) ...[
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline_rounded, color: Colors.red, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              paymentState.error!,
                              style: const TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          _buildBottomBar(context, paymentState, totalPrice, isDark),
        ],
      ),
    );
  }

  Widget _buildStepsIndicator(bool isDark) {
    final currentStep = FormStep.payment;
    
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

  Widget _buildPaymentMethods(PaymentState paymentState, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose Payment Method',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: isDark ? Colors.white : AppColors.ipackBlue,
            ),
          ),
          const SizedBox(height: 16),
          _buildPaymentMethodCard(
            title: 'UPI Transfer (GPay / PhonePe / Paytm)',
            icon: Icons.account_balance_rounded,
            isSelected: paymentState.paymentMethod == 'upi',
            onTap: () => ref.read(paymentProvider.notifier).setPaymentMethod('upi'),
            isDark: isDark,
          ),
          const SizedBox(height: 12),
          _buildPaymentMethodCard(
            title: 'Credit / Debit / ATM Card',
            icon: Icons.credit_card_rounded,
            isSelected: paymentState.paymentMethod == 'card',
            onTap: () => ref.read(paymentProvider.notifier).setPaymentMethod('card'),
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodCard({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    final activeColor = isDark ? AppColors.ipackOrange : AppColors.ipackBlue;
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
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
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: (isSelected ? activeColor : Colors.grey).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? activeColor : (isDark ? Colors.white30 : Colors.grey[500]),
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isSelected 
                      ? (isDark ? Colors.white : AppColors.ipackBlue) 
                      : (isDark ? Colors.white70 : Colors.black87),
                ),
              ),
            ),
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
      ),
    );
  }

  Widget _buildCardForm(PaymentState paymentState, bool isDark) {
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
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
            'Card Credentials',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.ipackBlue,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            keyboardType: TextInputType.number,
            maxLength: 16,
            style: TextStyle(color: isDark ? Colors.white : Colors.black87),
            onChanged: (value) => ref.read(paymentProvider.notifier).setCardNumber(value),
            decoration: InputDecoration(
              hintText: 'Card Number (16-digits)',
              hintStyle: TextStyle(color: isDark ? Colors.white30 : Colors.grey[400], fontSize: 14),
              filled: true,
              fillColor: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.grey[100],
              counterText: '',
              prefixIcon: Icon(Icons.credit_card, color: isDark ? Colors.white30 : Colors.grey[500]),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                  onChanged: (value) => ref.read(paymentProvider.notifier).setExpiryDate(value),
                  decoration: InputDecoration(
                    hintText: 'Expiry (MM/YY)',
                    hintStyle: TextStyle(color: isDark ? Colors.white30 : Colors.grey[400], fontSize: 14),
                    filled: true,
                    fillColor: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.grey[100],
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  maxLength: 3,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                  onChanged: (value) => ref.read(paymentProvider.notifier).setCvv(value),
                  decoration: InputDecoration(
                    hintText: 'CVV Code',
                    hintStyle: TextStyle(color: isDark ? Colors.white30 : Colors.grey[400], fontSize: 14),
                    filled: true,
                    fillColor: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.grey[100],
                    counterText: '',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUpiForm(PaymentState paymentState, bool isDark) {
    final formBg = isDark ? AppColors.darkSurface : Colors.white;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: formBg,
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
            'UPI Virtual Address',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.ipackBlue,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            style: TextStyle(color: isDark ? Colors.white : Colors.black87),
            onChanged: (value) => ref.read(paymentProvider.notifier).setUpiId(value),
            decoration: InputDecoration(
              hintText: 'Enter UPI VPA (e.g. mobile@ybl)',
              hintStyle: TextStyle(color: isDark ? Colors.white30 : Colors.grey[400], fontSize: 14),
              filled: true,
              fillColor: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.grey[100],
              prefixIcon: Icon(Icons.alternate_email, color: isDark ? Colors.white30 : Colors.grey[500]),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildUpiAppIcon('GPay', Colors.blue, isDark),
              _buildUpiAppIcon('PhonePe', Colors.purple, isDark),
              _buildUpiAppIcon('Paytm', Colors.blue[900]!, isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUpiAppIcon(String name, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Text(
        name,
        style: TextStyle(
          color: isDark ? Colors.white : color,
          fontWeight: FontWeight.w900,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, PaymentState paymentState, double totalPrice, bool isDark) {
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
                'Grand Total:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white70 : Colors.grey[700],
                ),
              ),
              Text(
                '₹${totalPrice.toStringAsFixed(0)}',
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
                    ref.read(paymentProvider.notifier).loadDemoData();
                  },
                  icon: const Icon(Icons.auto_awesome, size: 14),
                  label: const Text('Demo Pay'),
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
                    onPressed: paymentState.isLoading
                        ? null
                        : () async {
                            if (ref.read(paymentProvider.notifier).validate()) {
                              final success = await ref.read(paymentProvider.notifier).processPayment();
                              if (success && context.mounted) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const ConfirmScreen()),
                                );
                              }
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? AppColors.ipackOrange : AppColors.ipackBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: paymentState.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Pay Now Securely',
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
