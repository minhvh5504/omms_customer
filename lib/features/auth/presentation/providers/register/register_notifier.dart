// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/config/routing/app_routes.dart';
import '../../../../../core/providers/app_provider.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/validation.dart';
import '../../../domain/usecases/register_account.dart';

class RegisterState {
  final TextEditingController fullNameController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  final bool hasFullNameError;
  final bool hasPhoneError;
  final bool hasPasswordError;
  final bool hasConfirmPasswordError;
  final bool isValid;
  final bool isLoading;
  final String? errorMessage;

  const RegisterState({
    required this.fullNameController,
    required this.phoneController,
    required this.passwordController,
    required this.confirmPasswordController,
    this.hasFullNameError = false,
    this.hasPhoneError = false,
    this.hasPasswordError = false,
    this.hasConfirmPasswordError = false,
    this.isValid = false,
    this.isLoading = false,
    this.errorMessage,
  });

  RegisterState copyWith({
    bool? hasFullNameError,
    bool? hasPhoneError,
    bool? hasPasswordError,
    bool? hasConfirmPasswordError,
    bool? isValid,
    bool? isLoading,
    String? errorMessage,
  }) {
    return RegisterState(
      fullNameController: fullNameController,
      phoneController: phoneController,
      passwordController: passwordController,
      confirmPasswordController: confirmPasswordController,
      hasFullNameError: hasFullNameError ?? this.hasFullNameError,
      hasPhoneError: hasPhoneError ?? this.hasPhoneError,
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
          fullNameController: TextEditingController(),
          phoneController: TextEditingController(),
          passwordController: TextEditingController(),
          confirmPasswordController: TextEditingController(),
        ),
      ) {
    _addListeners();
  }

  // Add listeners
  void _addListeners() {
    state.fullNameController.addListener(_validateAll);
    state.phoneController.addListener(_validateAll);
    state.passwordController.addListener(_validateAll);
    state.confirmPasswordController.addListener(_validateAll);
  }

  // Validate all input fields
  void _validateAll() {
    final fullName = state.fullNameController.text.trim();
    final phone = state.phoneController.text.trim();
    final password = state.passwordController.text.trim();
    final confirmPassword = state.confirmPasswordController.text.trim();

    final fullNameValid = fullName.length >= 2;
    final phoneValid = Validation.isPhoneValid(phone);
    final passwordValid = Validation.isStrongPassword(password);
    final confirmPasswordValid = confirmPassword == password;

    final isValid =
        fullNameValid && phoneValid && passwordValid && confirmPasswordValid;

    state = state.copyWith(
      hasFullNameError: !fullNameValid && fullName.isNotEmpty,
      hasPhoneError: !phoneValid && phone.isNotEmpty,
      hasConfirmPasswordError:
          !confirmPasswordValid && confirmPassword.isNotEmpty,
      isValid: isValid,
    );
  }

  /// Get error full name text
  String? get fullNameErrorText {
    final text = state.fullNameController.text.trim();

    if (text.isEmpty) return null;

    if (text.length < 2) {
      return 'register.error_invalid_fullname'.tr();
    }

    return null;
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

    final fullName = state.fullNameController.text.trim();
    final phone = state.phoneController.text.trim();
    final password = state.passwordController.text.trim();

    try {
      await _registerUseCase(fullName, phone, password, 'customer');
      _setLoading(false);

      ref.read(previousPageProvider.notifier).state = 'register';
      context.go(AppRoutes.verifyaccount);
    } catch (e) {
      if (!context.mounted) return;
      _handleFailure(context, e);
    }
  }

  // Handle failure
  void _handleFailure(BuildContext context, Object error) {
    String errorCode = '';
    String errorMessage = 'Unknown error';

    if (error is DioException) {
      final data = error.response?.data;

      if (data is Map<String, dynamic>) {
        errorCode =
            data['messageCode']?.toString() ??
            data['errorCode']?.toString() ??
            '';
        errorMessage = data['message']?.toString() ?? errorMessage;
      } else {
        errorMessage = error.message ?? errorMessage;
      }
    } else {
      errorMessage = error.toString();
    }

    final message = _translateError(
      errorCode.isNotEmpty ? errorCode : errorMessage,
    );

    state = state.copyWith(isLoading: false, errorMessage: message);

    if (!context.mounted) return;
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
  String _translateError(String error) {
    final key = error.replaceFirst('Exception: ', '').trim();
    switch (key) {
      case 'AUTH.REGISTER.PHONE_EXISTS':
      case 'Phone number already registered':
        return 'register.errors.phone_exists'.tr();
      case 'USER_NOT_FOUND':
      case 'User not found':
        return 'register.errors.user_not_found'.tr();
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
    state.fullNameController.dispose();
    state.phoneController.dispose();
    state.passwordController.dispose();
    state.confirmPasswordController.dispose();
    super.dispose();
  }
}
