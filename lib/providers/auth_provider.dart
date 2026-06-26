import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthTab {
  login,
  register,
}

class AuthNotifier extends StateNotifier<AuthTab> {
  AuthNotifier() : super(AuthTab.login);

  void setTab(AuthTab tab) {
    state = tab;
  }
}

class LoginNotifier extends StateNotifier<LoginState> {
  LoginNotifier() : super(LoginState.initial());

  void setEmail(String email) {
    state = state.copyWith(email: email);
  }

  void setPassword(String password) {
    state = state.copyWith(password: password);
  }

  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  void setError(String? error) {
    state = state.copyWith(error: error);
  }

  void loadDemoData() {
    state = state.copyWith(
      email: 'demo@example.com',
      password: 'demo123',
    );
  }

  Future<bool> login() async {
    setLoading(true);
    setError(null);
    
    // Simulate login delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Basic validation
    if (state.email.isEmpty || state.password.isEmpty) {
      setError('Please fill in all fields');
      setLoading(false);
      return false;
    }
    
    if (!state.email.contains('@')) {
      setError('Please enter a valid email');
      setLoading(false);
      return false;
    }
    
    setLoading(false);
    return true;
  }

  void reset() {
    state = LoginState.initial();
  }
}

class RegisterNotifier extends StateNotifier<RegisterState> {
  RegisterNotifier() : super(RegisterState.initial());

  void setName(String name) {
    state = state.copyWith(name: name);
  }

  void setEmail(String email) {
    state = state.copyWith(email: email);
  }

  void setPhone(String phone) {
    state = state.copyWith(phone: phone);
  }

  void setPassword(String password) {
    state = state.copyWith(password: password);
  }

  void setConfirmPassword(String confirmPassword) {
    state = state.copyWith(confirmPassword: confirmPassword);
  }

  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  void setError(String? error) {
    state = state.copyWith(error: error);
  }

  Future<bool> register() async {
    setLoading(true);
    setError(null);
    
    // Simulate registration delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Basic validation
    if (state.name.isEmpty || 
        state.email.isEmpty || 
        state.phone.isEmpty || 
        state.password.isEmpty) {
      setError('Please fill in all fields');
      setLoading(false);
      return false;
    }
    
    if (!state.email.contains('@')) {
      setError('Please enter a valid email');
      setLoading(false);
      return false;
    }
    
    if (state.phone.length != 10) {
      setError('Please enter a valid 10-digit phone number');
      setLoading(false);
      return false;
    }
    
    if (state.password.length < 6) {
      setError('Password must be at least 6 characters');
      setLoading(false);
      return false;
    }
    
    if (state.password != state.confirmPassword) {
      setError('Passwords do not match');
      setLoading(false);
      return false;
    }
    
    setLoading(false);
    return true;
  }

  void reset() {
    state = RegisterState.initial();
  }
}

class LoginState {
  final String email;
  final String password;
  final bool isLoading;
  final String? error;

  LoginState({
    required this.email,
    required this.password,
    required this.isLoading,
    this.error,
  });

  factory LoginState.initial() {
    return LoginState(
      email: '',
      password: '',
      isLoading: false,
    );
  }

  LoginState copyWith({
    String? email,
    String? password,
    bool? isLoading,
    String? error,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class RegisterState {
  final String name;
  final String email;
  final String phone;
  final String password;
  final String confirmPassword;
  final bool isLoading;
  final String? error;

  RegisterState({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.confirmPassword,
    required this.isLoading,
    this.error,
  });

  factory RegisterState.initial() {
    return RegisterState(
      name: '',
      email: '',
      phone: '',
      password: '',
      confirmPassword: '',
      isLoading: false,
    );
  }

  RegisterState copyWith({
    String? name,
    String? email,
    String? phone,
    String? password,
    String? confirmPassword,
    bool? isLoading,
    String? error,
  }) {
    return RegisterState(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

final authTabProvider = StateNotifierProvider<AuthNotifier, AuthTab>(
  (ref) => AuthNotifier(),
);

final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>(
  (ref) => LoginNotifier(),
);

final registerProvider = StateNotifierProvider<RegisterNotifier, RegisterState>(
  (ref) => RegisterNotifier(),
);
