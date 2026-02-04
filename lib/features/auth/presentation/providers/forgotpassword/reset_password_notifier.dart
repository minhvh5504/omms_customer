// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/config/routing/app_routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/validation.dart';
import '../../../domain/usecases/reset_password.dart';
import 'send_request_provider.dart';

class ResetPasswordState {
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;
  final bool newPassValid;
  final bool confirmPassValid;
  final bool hasNewPassError;
  final bool hasConfirmPassError;
  final bool isValid;
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;

  const ResetPasswordState({
    required this.newPasswordController,
    required this.confirmPasswordController,
    this.newPassValid = false,
    this.confirmPassValid = false,
    this.hasNewPassError = false,
    this.hasConfirmPassError = false,
    this.isValid = false,
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
  });

  ResetPasswordState copyWith({
    bool? isValid,
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    bool? newPassValid,
    bool? confirmPassValid,
    bool? hasNewPassError,
    bool? hasConfirmPassError,
  }) {
    return ResetPasswordState(
      newPasswordController: newPasswordController,
      confirmPasswordController: confirmPasswordController,
      newPassValid: newPassValid ?? this.newPassValid,
      confirmPassValid: confirmPassValid ?? this.confirmPassValid,
      hasNewPassError: hasNewPassError ?? this.hasNewPassError,
      hasConfirmPassError: hasConfirmPassError ?? this.hasConfirmPassError,
      isValid: isValid ?? this.isValid,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
    );
  }
}

class ResetPasswordNotifier extends StateNotifier<ResetPasswordState> {
  final ResetPassword _resetPasswordUseCase;
  final Ref _ref;

  ResetPasswordNotifier(this._resetPasswordUseCase, this._ref)
    : super(
        ResetPasswordState(
          newPasswordController: TextEditingController(),
          confirmPasswordController: TextEditingController(),
        ),
      ) {
    _initListeners();
  }

  // Listen to input changes
  void _initListeners() {
    state.newPasswordController.addListener(_validateAll);
    state.confirmPasswordController.addListener(_validateAll);
  }

  // Validate password and confirm password
  void _validateAll() {
    final newPass = state.newPasswordController.text.trim();
    final confirmPass = state.confirmPasswordController.text.trim();

    final passwordValid = Validation.isStrongPassword(newPass);
    final confirmPasswordValid = confirmPass == newPass;

    final isValid = passwordValid && confirmPasswordValid;

    state = state.copyWith(
      isValid: isValid,

      hasNewPassError: !passwordValid && newPass.isNotEmpty,
      hasConfirmPassError: !confirmPasswordValid && confirmPass.isNotEmpty,
    );
  }

  /// Get error password text
  String? get passwordErrorText {
    final text = state.newPasswordController.text;

    if (text.isEmpty) return null;

    if (text.length < 8) {
      return 'reset_password.error_password_min_length'.tr();
    }

    if (!RegExp(r'[a-z]').hasMatch(text)) {
      return 'reset_password.error_password_lowercase'.tr();
    }

    if (!RegExp(r'[A-Z]').hasMatch(text)) {
      return 'reset_password.error_password_uppercase'.tr();
    }

    if (!RegExp(r'[!@#$%^&*]').hasMatch(text)) {
      return 'reset_password.error_password_special'.tr();
    }

    return null;
  }

  /// Get error confirm password text
  String? get confirmPasswordErrorText {
    final text = state.confirmPasswordController.text;

    if (text.isEmpty) return null;

    if (text != state.newPasswordController.text) {
      return 'reset_password.error_password_match'.tr();
    }

    return null;
  }

  // Submit save new password
  Future<void> onSubmit(BuildContext context) async {
    if (state.isLoading) return;
    if (!state.isValid) return;

    final phone = _ref.read(sendRequestNotifierProvider).phone;
    final newPassword = state.newPasswordController.text.trim();

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      await _resetPasswordUseCase(phone, newPassword);

      context.go(AppRoutes.login);
    } catch (e) {
      _handleFailure(context, e);
    }
  }

  // // Handle success
  // void _handleSuccess(BuildContext context, {required String message}) {
  //   state = state.copyWith(
  //     isLoading: false,
  //     isSuccess: true,
  //     errorMessage: null,
  //   );

  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(message),
  //       backgroundColor: Colors.green,
  //       behavior: SnackBarBehavior.floating,
  //     ),
  //   );
  // }

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
      case 'Invalid phone':
        return 'reset_password.errors.invalid_phone'.tr();
      case 'Invalid password':
        return 'reset_password.errors.invalid_password'.tr();
      default:
        return 'reset_password.errors.unexpected'.tr();
    }
  }

  // Navigate back to VerifyPassword page
  void onPressBack(BuildContext context) {
    context.go(AppRoutes.verifypassword);
  }

  @override
  void dispose() {
    state.newPasswordController.dispose();
    state.confirmPasswordController.dispose();
    super.dispose();
  }
}
