// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/config/routing/app_routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/validation.dart';
import '../../../domain/usecases/register_account.dart';

class RegisterState {
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  final bool hasPhoneError;
  final bool hasPasswordError;
  final bool hasConfirmPasswordError;
  final bool isValid;
  final bool isLoading;
  final String? errorMessage;

  const RegisterState({
    required this.phoneController,
    required this.passwordController,
    required this.confirmPasswordController,
    this.hasPhoneError = false,
    this.hasPasswordError = false,
    this.hasConfirmPasswordError = false,
    this.isValid = false,
    this.isLoading = false,
    this.errorMessage,
  });

  RegisterState copyWith({
    bool? hasPhoneError,
    bool? hasPasswordError,
    bool? hasConfirmPasswordError,
    bool? isValid,
    bool? isLoading,
    String? errorMessage,
  }) {
    return RegisterState(
      phoneController: phoneController,
      passwordController: passwordController,
      confirmPasswordController: confirmPasswordController,
      hasPhoneError: hasPhoneError ?? this.hasPhoneError,
      hasPasswordError: hasPasswordError ?? this.hasPasswordError,
      hasConfirmPasswordError:
          hasConfirmPasswordError ?? this.hasConfirmPasswordError,
      isValid: isValid ?? this.isValid,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class RegisterNotifier extends StateNotifier<RegisterState> {
  final RegisterAccount _registerUseCase;
  final Ref ref;

  RegisterNotifier(this._registerUseCase, this.ref)
    : super(
        RegisterState(
          phoneController: TextEditingController(),
          passwordController: TextEditingController(),
          confirmPasswordController: TextEditingController(),
        ),
      ) {
    _addListeners();
  }

  // Add listeners
  void _addListeners() {
    state.phoneController.addListener(_validateAll);
    state.passwordController.addListener(_validateAll);
    state.confirmPasswordController.addListener(_validateAll);
  }

  // Validate all input fields
  void _validateAll() {
    final phone = state.phoneController.text.trim();
    final password = state.passwordController.text.trim();
    final confirmPassword = state.confirmPasswordController.text.trim();

    final phoneValid = Validation.isPhoneValid(phone);
    final passwordValid = Validation.isStrongPassword(password);
    final confirmPasswordValid = confirmPassword == password;

    final isValid = phoneValid && passwordValid && confirmPasswordValid;

    state = state.copyWith(
      hasPhoneError: !phoneValid && phone.isNotEmpty,
      hasPasswordError: !passwordValid && password.isNotEmpty,
      hasConfirmPasswordError:
          !confirmPasswordValid && confirmPassword.isNotEmpty,
      isValid: isValid,
    );
  }

  /// Get error email text
  String? get phoneErrorText {
    final text = state.phoneController.text.trim();

    if (text.isEmpty) return null;

    if (!Validation.isPhoneValid(text)) {
      return 'register.error_invalid_phone'.tr();
    }

    return null;
  }

  /// Get error password text
  String? get passwordErrorText {
    final text = state.passwordController.text;

    if (text.isEmpty) return null;

    if (text.length < 8) {
      return 'register.error_password_min_length'.tr();
    }

    if (!RegExp(r'[a-z]').hasMatch(text)) {
      return 'register.error_password_lowercase'.tr();
    }

    if (!RegExp(r'[A-Z]').hasMatch(text)) {
      return 'register.error_password_uppercase'.tr();
    }

    if (!RegExp(r'[!@#$%^&*]').hasMatch(text)) {
      return 'register.error_password_special'.tr();
    }

    return null;
  }

  /// Get error confirm password text
  String? get confirmPasswordErrorText {
    final text = state.confirmPasswordController.text;

    if (text.isEmpty) return null;

    if (text != state.passwordController.text) {
      return 'register.error_password_match'.tr();
    }

    return null;
  }

  // Handle Sign Up action
  Future<void> onSignUp(BuildContext context) async {
    if (!state.isValid) return;
    if (state.isLoading) return;

    _setLoading(true);

    final phone = state.phoneController.text.trim();
    final password = state.passwordController.text.trim();

    try {
      // Pass phone to both email and phone params if required by backend,
      // or just to phone. Given the context, we use phone.
      await _registerUseCase('', phone, password, 'customer');
      _setLoading(false);

      // Navigate to login or showing success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Register account successful!, Please login'),
          backgroundColor: AppColors.bgPrimary,
          behavior: SnackBarBehavior.floating,
        ),
      );
      context.go(AppRoutes.login);
    } catch (e) {
      _handleFailure(context, e);
    }
  }

  // Handle failure
  void _handleFailure(BuildContext context, Object error) {
    String errorMessage = 'Unknown error';

    if (error is DioException) {
      final data = error.response?.data;

      if (data is Map<String, dynamic>) {
        errorMessage = data['message']?.toString() ?? errorMessage;
      } else {
        errorMessage = error.message ?? errorMessage;
      }
    } else {
      errorMessage = error.toString();
    }

    final message = _translateError(errorMessage);

    state = state.copyWith(isLoading: false, errorMessage: message);

    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppColors.typoError,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  // Translate error messages
  String _translateError(String errorMessage) {
    final error = errorMessage.replaceFirst('Exception: ', '').trim();
    switch (error) {
      case 'Email already exists':
        return 'register.errors.phone_exists'.tr();
      case 'Phone number already exists':
        return 'register.errors.phone_exists'.tr();
      case 'email must be an email':
        return 'register.errors.invalid_phone'.tr();
      case 'phone must be a phone':
        return 'register.errors.invalid_phone'.tr();
      default:
        return 'register.errors.unexpected'.tr();
    }
  }

  // Set loading state
  void _setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  // Navigate to Login page
  void onPressBack(BuildContext context) {
    context.go(AppRoutes.login);
  }

  // Navigate to Login page
  void onSignIn(BuildContext context) {
    context.go(AppRoutes.login);
  }

  // Handle Google login (not implemented yet)
  void onRegisterWithGoogle(BuildContext context) {}

  // Handle Facebook login (not implemented yet)
  void onRegisterWithFacebook(BuildContext context) {}

  @override
  void dispose() {
    state.phoneController.dispose();
    state.passwordController.dispose();
    state.confirmPasswordController.dispose();
    super.dispose();
  }
}
