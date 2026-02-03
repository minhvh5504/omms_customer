// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/config/routing/app_routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/validation.dart';
import '../../../domain/usecases/login_account.dart';
import '../../../domain/usecases/login_with_google.dart';
import '../auth/auth_provider.dart';

/// STATE
class LoginState {
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final bool remember;
  final bool usernameValid;
  final bool passwordValid;
  final bool hasUserNameError;
  final bool hasPasswordError;
  final bool isValid;
  final bool isLoading;
  final String? errorMessage;

  const LoginState({
    required this.usernameController,
    required this.passwordController,
    this.remember = false,
    this.usernameValid = false,
    this.passwordValid = false,
    this.hasUserNameError = false,
    this.hasPasswordError = false,
    this.isValid = false,
    this.isLoading = false,
    this.errorMessage,
  });

  LoginState copyWith({
    bool? remember,
    bool? usernameValid,
    bool? passwordValid,
    bool? hasUserNameError,
    bool? hasPasswordError,
    bool? isValid,
    bool? isLoading,
    String? errorMessage,
  }) {
    return LoginState(
      usernameController: usernameController,
      passwordController: passwordController,
      remember: remember ?? this.remember,
      usernameValid: usernameValid ?? this.usernameValid,
      passwordValid: passwordValid ?? this.passwordValid,
      hasUserNameError: hasUserNameError ?? this.hasUserNameError,
      hasPasswordError: hasPasswordError ?? this.hasPasswordError,
      isValid: isValid ?? this.isValid,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

/// NOTIFIER
class LoginNotifier extends StateNotifier<LoginState> {
  final LoginAccount _loginUseCase;
  // ignore: unused_field
  final LoginWithGoogle _loginWithGoogleUseCase;
  final Ref ref;

  LoginNotifier(this._loginUseCase, this._loginWithGoogleUseCase, this.ref)
    : super(
        LoginState(
          usernameController: TextEditingController(),
          passwordController: TextEditingController(),
        ),
      ) {
    _loadSavedAccount();
    state.usernameController.addListener(_validateAll);
    state.passwordController.addListener(_validateAll);
  }

  /// Load saved credentials from SharedPreferences
  Future<void> _loadSavedAccount() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUserName = prefs.getString('saved_username') ?? '';
    final savedPassword = prefs.getString('saved_password') ?? '';
    final remember = prefs.getBool('remember_me') ?? false;

    state.usernameController.text = savedUserName;
    state.passwordController.text = savedPassword;
    state = state.copyWith(remember: remember);
    _validateAll();
  }

  /// Validate all input fields
  void _validateAll() {
    final usernameText = state.usernameController.text.trim();
    final passText = state.passwordController.text.trim();

    // true = valid
    final usernameValid = Validation.isValidEmail(usernameText);
    final passwordValid = Validation.isStrongPassword(passText);

    // true = form valid
    final valid = usernameValid && passwordValid;

    state = state.copyWith(
      // true = valid input
      usernameValid: usernameValid,
      passwordValid: passwordValid,

      // true = show red border
      hasUserNameError: !usernameValid && usernameText.isNotEmpty,
      hasPasswordError: !passwordValid && passText.isNotEmpty,

      // true = enable submit button
      isValid: valid,
    );
  }

  /// Get error text
  String? get usernameErrorText {
    final text = state.usernameController.text.trim();

    if (text.isEmpty) return null;

    if (!Validation.isValidEmail(text)) {
      return 'login.error_invalid_email'.tr();
    }

    return null;
  }

  /// Get error text
  String? get passwordErrorText {
    final text = state.passwordController.text;

    if (text.isEmpty) return null;

    if (text.length < 8) {
      return 'login.error_password_min_length'.tr();
    }

    if (!RegExp(r'[a-z]').hasMatch(text)) {
      return 'login.error_password_lowercase'.tr();
    }

    if (!RegExp(r'[A-Z]').hasMatch(text)) {
      return 'login.error_password_uppercase'.tr();
    }

    if (!RegExp(r'[!@#$%^&*]').hasMatch(text)) {
      return 'login.error_password_special'.tr();
    }

    return null;
  }

  /// Toggle remember
  void toggleRemember(bool? value) {
    state = state.copyWith(remember: value ?? false);
  }

  /// Handle sign-in process
  Future<void> onSignIn(BuildContext context) async {
    if (state.isLoading) return;
    if (!state.isValid) return;

    _setLoading(true);

    context.go(AppRoutes.menu);

    // final username = state.usernameController.text.trim();
    // final password = state.passwordController.text.trim();

    // try {
    //   final user = await _loginUseCase(username, password, 'nurse', 'app');
    //   await ref
    //       .read(authProvider.notifier)
    //       .login(
    //         accessToken: user.accessToken,
    //         refreshToken: user.refreshToken,
    //       );

    //   await _handleLoginSuccess(context, username, password);
    // } catch (e) {
    //   _setLoading(false);

    //   _handleFailure(context, e);

    //   String backendMessage = '';

    //   if (e is DioException) {
    //     final data = e.response?.data;
    //     if (data is Map<String, dynamic>) {
    //       backendMessage = data['message']?.toString().toLowerCase() ?? '';
    //     }
    //   }

    //   if (backendMessage.contains('user not verified')) {
    //     await _showUnverifiedAccountPopup(context);
    //     return;
    //   }
    // }
  }

  /// Handle successful login
  Future<void> _handleLoginSuccess(
    BuildContext context,
    String username,
    String password,
  ) async {
    ScaffoldMessenger.of(context).clearSnackBars();
    final prefs = await SharedPreferences.getInstance();

    if (state.remember) {
      await prefs.setString('saved_username', username);
      await prefs.setString('saved_password', password);
      await prefs.setBool('remember_me', true);
    } else {
      await prefs.remove('saved_username');
      await prefs.remove('saved_password');
      await prefs.setBool('remember_me', false);
    }

    _setLoading(false);

    if (!context.mounted) return;

    context.go(AppRoutes.menu);
  }

  /// Handle failure
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

  /// Set loading state
  void _setLoading(bool loading) {
    state = state.copyWith(isLoading: loading, errorMessage: null);
  }

  // Translate error messages
  String _translateError(String errorMessage) {
    final error = errorMessage.replaceFirst('Exception: ', '').trim();
    switch (error) {
      case 'User not verified':
        return 'login.errors.user_not_verified'.tr();
      case 'Wrong credentials':
        return 'login.errors.wrong_credentials'.tr();
      case 'Failed to connect to the server':
        return 'login.errors.failed_connect_server'.tr();
      case 'User not found':
        return 'login.errors.user_not_found'.tr();
      default:
        return 'login.errors.unexpected'.tr();
    }
  }

  /// Navigate to Forgot Password page
  void onForgotPassword(BuildContext context) {}

  /// Navigate to Sign Up page
  void onSignUp(BuildContext context) {
    context.go(AppRoutes.register);
  }

  /// Handle Facebook login
  void onLoginWithFacebook(BuildContext context) {}

  /// Show unverified account popup
  Future<void> _showUnverifiedAccountPopup(BuildContext context) async {
    _setLoading(false);

    await Future.delayed(const Duration(milliseconds: 200));

    // await showDialog(
    //   context: context,
    //   builder: (_) => UnlockFeaturePopup(
    //     title: 'unverified_account_popup.title'.tr(),
    //     subtitle: 'unverified_account_popup.subtitle'.tr(),
    //     primaryText: 'unverified_account_popup.primary'.tr(),
    //     secondaryText: 'unverified_account_popup.secondary'.tr(),
    //     onSecondary: () {},
    //     onPrimary: () async {
    //       await ref
    //           .read(verifyAccountNotifierProvider.notifier)
    //           .onResend(context);
    //       context.go(AppRoutes.verifyaccount);
    //     },
    //   ),
    // );
  }

  /// Dispose
  @override
  void dispose() {
    state.usernameController.dispose();
    state.passwordController.dispose();
    super.dispose();
  }
}
