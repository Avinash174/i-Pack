import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/form_provider.dart';
import '../main.dart';
import 'add_ons_screen.dart';

class DeviceInfoScreen extends ConsumerStatefulWidget {
  const DeviceInfoScreen({super.key});

  @override
  ConsumerState<DeviceInfoScreen> createState() => _DeviceInfoScreenState();
}

class _DeviceInfoScreenState extends ConsumerState<DeviceInfoScreen> {
  final List<String> brands = [
    'Apple', 'Samsung', 'OnePlus', 'Xiaomi', 'Realme', 'Vivo', 'Oppo', 'Google'
  ];
  
  final Map<String, List<String>> models = {
    'Apple': ['iPhone 15 Pro', 'iPhone 15', 'iPhone 14 Pro', 'iPhone 14', 'iPhone 13'],
    'Samsung': ['Galaxy S24 Ultra', 'Galaxy S24', 'Galaxy S23', 'Galaxy A54', 'Galaxy Z Flip 5'],
    'OnePlus': ['OnePlus 12', 'OnePlus 12R', 'OnePlus 11', 'OnePlus Nord CE 4'],
    'Xiaomi': ['Xiaomi 14', 'Redmi Note 13 Pro', 'Redmi 12', 'Xiaomi 13 Pro'],
    'Realme': ['Realme GT 5', 'Realme 12 Pro', 'Realme 11 Pro', 'Realme C67'],
    'Vivo': ['Vivo X100 Pro', 'Vivo V30 Pro', 'Vivo Y200', 'Vivo T3'],
    'Oppo': ['Oppo Reno 11', 'Oppo Find N3', 'Oppo F25 Pro', 'Oppo A79'],
    'Google': ['Pixel 8 Pro', 'Pixel 8', 'Pixel 7a', 'Pixel Fold', 'Pixel 6a'],
  };

  @override
  Widget build(BuildContext context) {
    final deviceInfo = ref.watch(deviceInfoProvider);
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
          'Device Information',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildStepsIndicator(isDark),
            _buildPlanCard(isDark),
            const SizedBox(height: 24),
            _buildForm(deviceInfo, isDark),
            const SizedBox(height: 32),
            _buildContinueButton(deviceInfo, isDark),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStepsIndicator(bool isDark) {
    final currentStep = ref.watch(formStepProvider);
    
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
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: AppColors.ipackOrange.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          )
                        ]
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

  Widget _buildPlanCard(bool isDark) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      padding: const EdgeInsets.all(20),
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
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Selected Protection Plan',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Basic Protection Plan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Max Coverage reimbursement: ₹20,000',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Text(
            '₹699/yr',
            style: TextStyle(
              color: AppColors.ipackOrange,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(DeviceInfoState deviceInfo, bool isDark) {
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
          _buildBrandDropdown(deviceInfo, isDark),
          const SizedBox(height: 20),
          _buildModelDropdown(deviceInfo, isDark),
          const SizedBox(height: 20),
          _buildImeiField(deviceInfo, isDark),
          const SizedBox(height: 20),
          _buildMarketValueField(deviceInfo, isDark),
          const SizedBox(height: 20),
          _buildPurchaseDateField(deviceInfo, isDark),
          if (deviceInfo.error != null) ...[
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(Icons.error_outline_rounded, color: Colors.red, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    deviceInfo.error!,
                    style: const TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () {
                ref.read(deviceInfoProvider.notifier).loadDemoData();
              },
              icon: const Icon(Icons.auto_awesome, size: 14),
              label: const Text('Fill Demo Specs'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.ipackOrange,
                textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandDropdown(DeviceInfoState deviceInfo, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Device Manufacturer',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white70 : AppColors.ipackBlue,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey[300]!,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: deviceInfo.brand.isEmpty ? null : deviceInfo.brand,
              hint: Text(
                'Select Brand',
                style: TextStyle(color: isDark ? Colors.white30 : Colors.grey[400], fontSize: 14),
              ),
              dropdownColor: isDark ? AppColors.darkSurface : Colors.white,
              isExpanded: true,
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
              items: brands.map((brand) {
                return DropdownMenuItem(
                  value: brand,
                  child: Text(brand),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  ref.read(deviceInfoProvider.notifier).setBrand(value);
                  ref.read(deviceInfoProvider.notifier).setModel('');
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildModelDropdown(DeviceInfoState deviceInfo, bool isDark) {
    final availableModels = deviceInfo.brand.isEmpty 
        ? <String>[] 
        : models[deviceInfo.brand] ?? [];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Device Model',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white70 : AppColors.ipackBlue,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey[300]!,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: deviceInfo.model.isEmpty ? null : deviceInfo.model,
              hint: Text(
                deviceInfo.brand.isEmpty 
                    ? 'Please select brand first' 
                    : 'Select Model',
                style: TextStyle(color: isDark ? Colors.white30 : Colors.grey[400], fontSize: 14),
              ),
              dropdownColor: isDark ? AppColors.darkSurface : Colors.white,
              isExpanded: true,
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
              items: availableModels.map((model) {
                return DropdownMenuItem(
                  value: model,
                  child: Text(model),
                );
              }).toList(),
              onChanged: deviceInfo.brand.isEmpty
                  ? null
                  : (value) {
                      if (value != null) {
                        ref.read(deviceInfoProvider.notifier).setModel(value);
                      }
                    },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImeiField(DeviceInfoState deviceInfo, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '15-Digit IMEI Number',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white70 : AppColors.ipackBlue,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          keyboardType: TextInputType.number,
          maxLength: 15,
          style: TextStyle(color: isDark ? Colors.white : Colors.black87),
          onChanged: (value) {
            ref.read(deviceInfoProvider.notifier).setImei(value);
          },
          decoration: InputDecoration(
            hintText: 'IMEI (Dial *#06# on phone to find)',
            hintStyle: TextStyle(color: isDark ? Colors.white30 : Colors.grey[400], fontSize: 14),
            filled: true,
            fillColor: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.grey[100],
            counterText: '',
            prefixIcon: Icon(Icons.info_outline_rounded, color: isDark ? Colors.white30 : Colors.grey[500]),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildMarketValueField(DeviceInfoState deviceInfo, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Device Original Price (Market Value)',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white70 : AppColors.ipackBlue,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          keyboardType: TextInputType.number,
          style: TextStyle(color: isDark ? Colors.white : Colors.black87),
          onChanged: (value) {
            ref.read(deviceInfoProvider.notifier).setMarketValue(value);
          },
          decoration: InputDecoration(
            prefixText: '₹ ',
            prefixStyle: TextStyle(color: isDark ? Colors.white : AppColors.ipackBlue, fontWeight: FontWeight.bold),
            hintText: 'e.g. 54999',
            hintStyle: TextStyle(color: isDark ? Colors.white30 : Colors.grey[400], fontSize: 14),
            filled: true,
            fillColor: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.grey[100],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildPurchaseDateField(DeviceInfoState deviceInfo, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Device Purchase Date',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white70 : AppColors.ipackBlue,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2015),
              lastDate: DateTime.now(),
            );
            if (picked != null) {
              ref.read(deviceInfoProvider.notifier).setPurchaseDate(picked);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey[300]!,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  deviceInfo.purchaseDate != null
                      ? DateFormat('dd/MM/yyyy').format(deviceInfo.purchaseDate!)
                      : 'Select Date',
                  style: TextStyle(
                    color: deviceInfo.purchaseDate != null
                        ? (isDark ? Colors.white : Colors.black87)
                        : (isDark ? Colors.white30 : Colors.grey[400]),
                  ),
                ),
                Icon(
                  Icons.calendar_today_rounded,
                  color: isDark ? AppColors.ipackOrange : AppColors.ipackBlue,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContinueButton(DeviceInfoState deviceInfo, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          if (ref.read(deviceInfoProvider.notifier).validate()) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddOnsScreen()),
            );
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
        child: const Text(
          'Continue to Add-ons',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
