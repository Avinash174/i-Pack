import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

enum FormStep {
  deviceInfo,
  addOns,
  payment,
  confirm,
}

class FormStepNotifier extends StateNotifier<FormStep> {
  FormStepNotifier() : super(FormStep.deviceInfo);

  void nextStep() {
    if (state.index < FormStep.values.length - 1) {
      state = FormStep.values[state.index + 1];
    }
  }

  void previousStep() {
    if (state.index > 0) {
      state = FormStep.values[state.index - 1];
    }
  }

  void goToStep(FormStep step) {
    state = step;
  }

  void reset() {
    state = FormStep.deviceInfo;
  }
}

class DeviceInfoNotifier extends StateNotifier<DeviceInfoState> {
  DeviceInfoNotifier() : super(DeviceInfoState.initial());

  void setBrand(String brand) {
    state = state.copyWith(brand: brand);
  }

  void setModel(String model) {
    state = state.copyWith(model: model);
  }

  void setImei(String imei) {
    state = state.copyWith(imei: imei);
  }

  void setMarketValue(String value) {
    state = state.copyWith(marketValue: value);
  }

  void setPurchaseDate(DateTime date) {
    state = state.copyWith(purchaseDate: date);
  }

  void setError(String? error) {
    state = state.copyWith(error: error);
  }

  void loadDemoData() {
    state = state.copyWith(
      brand: 'Apple',
      model: 'iPhone 15',
      imei: '123456789012345',
      marketValue: '75000',
      purchaseDate: DateTime(2024, 1, 15),
    );
  }

  bool validate() {
    if (state.brand.isEmpty) {
      setError('Please select a brand');
      return false;
    }
    if (state.model.isEmpty) {
      setError('Please select a model');
      return false;
    }
    if (state.imei.isEmpty || state.imei.length != 15) {
      setError('Please enter a valid 15-digit IMEI number');
      return false;
    }
    if (state.marketValue.isEmpty) {
      setError('Please enter the market value');
      return false;
    }
    if (state.purchaseDate == null) {
      setError('Please select the purchase date');
      return false;
    }
    setError(null);
    return true;
  }

  void reset() {
    state = DeviceInfoState.initial();
  }
}

class AddOnsNotifier extends StateNotifier<AddOnsState> {
  AddOnsNotifier() : super(AddOnsState.initial());

  void toggleScreenProtection(bool value) {
    state = state.copyWith(screenProtection: value);
  }

  void toggleLiquidDamage(bool value) {
    state = state.copyWith(liquidDamage: value);
  }

  void toggleTheftProtection(bool value) {
    state = state.copyWith(theftProtection: value);
  }

  void toggleQuickClaim(bool value) {
    state = state.copyWith(quickClaim: value);
  }

  void loadDemoData() {
    state = state.copyWith(
      screenProtection: true,
      liquidDamage: true,
      theftProtection: false,
      quickClaim: true,
    );
  }

  double getTotalPrice() {
    double total = 699.0; // Basic plan price
    if (state.screenProtection) total += 199.0;
    if (state.liquidDamage) total += 299.0;
    if (state.theftProtection) total += 499.0;
    if (state.quickClaim) total += 149.0;
    return total;
  }

  void reset() {
    state = AddOnsState.initial();
  }
}

class PaymentNotifier extends StateNotifier<PaymentState> {
  PaymentNotifier() : super(PaymentState.initial());

  void setPaymentMethod(String method) {
    state = state.copyWith(paymentMethod: method);
  }

  void setCardNumber(String number) {
    state = state.copyWith(cardNumber: number);
  }

  void setExpiryDate(String date) {
    state = state.copyWith(expiryDate: date);
  }

  void setCvv(String cvv) {
    state = state.copyWith(cvv: cvv);
  }

  void setUpiId(String upiId) {
    state = state.copyWith(upiId: upiId);
  }

  void setError(String? error) {
    state = state.copyWith(error: error);
  }

  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  void loadDemoData() {
    state = state.copyWith(
      paymentMethod: 'upi',
      upiId: 'demo@upi',
    );
  }

  bool validate() {
    if (state.paymentMethod == 'card') {
      if (state.cardNumber.isEmpty || state.cardNumber.length < 16) {
        setError('Please enter a valid card number');
        return false;
      }
      if (state.expiryDate.isEmpty) {
        setError('Please enter expiry date');
        return false;
      }
      if (state.cvv.isEmpty || state.cvv.length < 3) {
        setError('Please enter a valid CVV');
        return false;
      }
    } else if (state.paymentMethod == 'upi') {
      if (state.upiId.isEmpty || !state.upiId.contains('@')) {
        setError('Please enter a valid UPI ID');
        return false;
      }
    }
    setError(null);
    return true;
  }

  Future<bool> processPayment() async {
    setLoading(true);
    await Future.delayed(const Duration(seconds: 2));
    setLoading(false);
    return true;
  }

  void reset() {
    state = PaymentState.initial();
  }
}

class DeviceInfoState {
  final String brand;
  final String model;
  final String imei;
  final String marketValue;
  final DateTime? purchaseDate;
  final String? error;

  DeviceInfoState({
    required this.brand,
    required this.model,
    required this.imei,
    required this.marketValue,
    this.purchaseDate,
    this.error,
  });

  factory DeviceInfoState.initial() {
    return DeviceInfoState(
      brand: '',
      model: '',
      imei: '',
      marketValue: '',
    );
  }

  DeviceInfoState copyWith({
    String? brand,
    String? model,
    String? imei,
    String? marketValue,
    DateTime? purchaseDate,
    String? error,
  }) {
    return DeviceInfoState(
      brand: brand ?? this.brand,
      model: model ?? this.model,
      imei: imei ?? this.imei,
      marketValue: marketValue ?? this.marketValue,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      error: error,
    );
  }

  String get formattedPurchaseDate {
    if (purchaseDate == null) return '';
    return DateFormat('dd/MM/yyyy').format(purchaseDate!);
  }
}

class AddOnsState {
  final bool screenProtection;
  final bool liquidDamage;
  final bool theftProtection;
  final bool quickClaim;

  AddOnsState({
    required this.screenProtection,
    required this.liquidDamage,
    required this.theftProtection,
    required this.quickClaim,
  });

  factory AddOnsState.initial() {
    return AddOnsState(
      screenProtection: false,
      liquidDamage: false,
      theftProtection: false,
      quickClaim: false,
    );
  }

  AddOnsState copyWith({
    bool? screenProtection,
    bool? liquidDamage,
    bool? theftProtection,
    bool? quickClaim,
  }) {
    return AddOnsState(
      screenProtection: screenProtection ?? this.screenProtection,
      liquidDamage: liquidDamage ?? this.liquidDamage,
      theftProtection: theftProtection ?? this.theftProtection,
      quickClaim: quickClaim ?? this.quickClaim,
    );
  }
}

class PaymentState {
  final String paymentMethod;
  final String cardNumber;
  final String expiryDate;
  final String cvv;
  final String upiId;
  final bool isLoading;
  final String? error;

  PaymentState({
    required this.paymentMethod,
    required this.cardNumber,
    required this.expiryDate,
    required this.cvv,
    required this.upiId,
    required this.isLoading,
    this.error,
  });

  factory PaymentState.initial() {
    return PaymentState(
      paymentMethod: 'upi',
      cardNumber: '',
      expiryDate: '',
      cvv: '',
      upiId: '',
      isLoading: false,
    );
  }

  PaymentState copyWith({
    String? paymentMethod,
    String? cardNumber,
    String? expiryDate,
    String? cvv,
    String? upiId,
    bool? isLoading,
    String? error,
  }) {
    return PaymentState(
      paymentMethod: paymentMethod ?? this.paymentMethod,
      cardNumber: cardNumber ?? this.cardNumber,
      expiryDate: expiryDate ?? this.expiryDate,
      cvv: cvv ?? this.cvv,
      upiId: upiId ?? this.upiId,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

final formStepProvider = StateNotifierProvider<FormStepNotifier, FormStep>(
  (ref) => FormStepNotifier(),
);

final deviceInfoProvider = StateNotifierProvider<DeviceInfoNotifier, DeviceInfoState>(
  (ref) => DeviceInfoNotifier(),
);

final addOnsProvider = StateNotifierProvider<AddOnsNotifier, AddOnsState>(
  (ref) => AddOnsNotifier(),
);

final paymentProvider = StateNotifierProvider<PaymentNotifier, PaymentState>(
  (ref) => PaymentNotifier(),
);

final totalPriceProvider = Provider<double>((ref) {
  return ref.watch(addOnsProvider.notifier).getTotalPrice();
});
