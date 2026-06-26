import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../main.dart';
import 'main_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authTab = ref.watch(authTabProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient Circles
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.ipackBlue.withValues(alpha: isDark ? 0.3 : 0.1),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            right: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.ipackOrange.withValues(alpha: isDark ? 0.2 : 0.1),
              ),
            ),
          ),
          
          // Main Scrollable Body
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 450),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: isDark 
                            ? AppColors.darkSurface.withValues(alpha: 0.7) 
                            : Colors.white.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.1)
                              : AppColors.ipackBlue.withValues(alpha: 0.1),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildHeader(context, isDark),
                          const SizedBox(height: 28),
                          _buildTabBar(context, ref, authTab, isDark),
                          const SizedBox(height: 28),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: authTab == AuthTab.login
                                ? _buildLoginForm(context, ref, isDark)
                                : _buildRegisterForm(context, ref, isDark),
                          ),
                          const SizedBox(height: 20),
                          _buildFooter(context, isDark),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.ipackOrange.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.shield_outlined,
            color: AppColors.ipackOrange,
            size: 32,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'I-PACK Protection',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppColors.ipackBlue,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Manage your device policies securely',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            color: isDark ? Colors.white60 : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar(BuildContext context, WidgetRef ref, AuthTab authTab, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => ref.read(authTabProvider.notifier).setTab(AuthTab.login),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: authTab == AuthTab.login 
                      ? (isDark ? AppColors.ipackOrange : AppColors.ipackBlue)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Login',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: authTab == AuthTab.login 
                        ? Colors.white 
                        : (isDark ? Colors.white70 : AppColors.ipackBlue),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => ref.read(authTabProvider.notifier).setTab(AuthTab.register),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: authTab == AuthTab.register 
                      ? (isDark ? AppColors.ipackOrange : AppColors.ipackBlue)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Register',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: authTab == AuthTab.register 
                        ? Colors.white 
                        : (isDark ? Colors.white70 : AppColors.ipackBlue),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context, WidgetRef ref, bool isDark) {
    final loginState = ref.watch(loginProvider);
    
    return Column(
      key: const ValueKey('login_form'),
      children: [
        _buildTextField(
          hintText: 'Email Address',
          icon: Icons.email_outlined,
          isDark: isDark,
          onChanged: (value) => ref.read(loginProvider.notifier).setEmail(value),
        ),
        const SizedBox(height: 16),
        _buildTextField(
          hintText: 'Password',
          icon: Icons.lock_outline,
          isDark: isDark,
          obscureText: true,
          onChanged: (value) => ref.read(loginProvider.notifier).setPassword(value),
        ),
        if (loginState.error != null) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  loginState.error!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
                );
              },
              child: Text(
                'Forgot Password?',
                style: TextStyle(
                  color: isDark ? Colors.white54 : Colors.grey[600],
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                ref.read(loginProvider.notifier).loadDemoData();
              },
              child: const Text(
                'Fill Demo Credentials',
                style: TextStyle(
                  color: AppColors.ipackOrange,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: loginState.isLoading
                ? null
                : () async {
                    final success = await ref.read(loginProvider.notifier).login();
                    if (success && context.mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const MainScreen()),
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
            child: loginState.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    'Login',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterForm(BuildContext context, WidgetRef ref, bool isDark) {
    final registerState = ref.watch(registerProvider);
    
    return Column(
      key: const ValueKey('register_form'),
      children: [
        _buildTextField(
          hintText: 'Full Name',
          icon: Icons.person_outline,
          isDark: isDark,
          onChanged: (value) => ref.read(registerProvider.notifier).setName(value),
        ),
        const SizedBox(height: 12),
        _buildTextField(
          hintText: 'Email Address',
          icon: Icons.email_outlined,
          isDark: isDark,
          onChanged: (value) => ref.read(registerProvider.notifier).setEmail(value),
        ),
        const SizedBox(height: 12),
        _buildTextField(
          hintText: 'Phone Number',
          icon: Icons.phone_outlined,
          isDark: isDark,
          keyboardType: TextInputType.phone,
          onChanged: (value) => ref.read(registerProvider.notifier).setPhone(value),
        ),
        const SizedBox(height: 12),
        _buildTextField(
          hintText: 'Password',
          icon: Icons.lock_outline,
          isDark: isDark,
          obscureText: true,
          onChanged: (value) => ref.read(registerProvider.notifier).setPassword(value),
        ),
        const SizedBox(height: 12),
        _buildTextField(
          hintText: 'Confirm Password',
          icon: Icons.lock_outline,
          isDark: isDark,
          obscureText: true,
          onChanged: (value) => ref.read(registerProvider.notifier).setConfirmPassword(value),
        ),
        if (registerState.error != null) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  registerState.error!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: registerState.isLoading
                ? null
                : () async {
                    final success = await ref.read(registerProvider.notifier).register();
                    if (success && context.mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const MainScreen()),
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
            child: registerState.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    'Register',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String hintText,
    required IconData icon,
    required bool isDark,
    required ValueChanged<String> onChanged,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      obscureText: obscureText,
      keyboardType: keyboardType,
      onChanged: onChanged,
      style: TextStyle(color: isDark ? Colors.white : Colors.black87),
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          color: isDark ? Colors.white38 : Colors.grey[500],
          size: 20,
        ),
        hintText: hintText,
        hintStyle: TextStyle(
          color: isDark ? Colors.white38 : Colors.grey[400],
          fontSize: 14,
        ),
        filled: true,
        fillColor: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? AppColors.ipackOrange : AppColors.ipackBlue,
            width: 1.5,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildFooter(BuildContext context, bool isDark) {
    return Column(
      children: [
        const SizedBox(height: 8),
        Text(
          'Need assistance? Call: 1800-123-4725',
          style: TextStyle(
            color: isDark ? Colors.white38 : Colors.grey[600],
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Available 24/7 for support & queries',
          style: TextStyle(
            color: isDark ? Colors.white24 : Colors.grey[400],
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
