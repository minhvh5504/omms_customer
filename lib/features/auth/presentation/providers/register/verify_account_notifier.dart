// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/config/routing/app_routes.dart';
import '../../../../../core/providers/app_provider.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/validation.dart';
import '../../../domain/usecases/resend_code.dart';
import '../../../domain/usecases/verify.dart';

class VerifyAccountState {
  final String otpCode;
  final bool isValid;
  final bool isLoading;
  final bool isSuccess;
  final bool isResending;
  final String? errorMessage;
  final int remainingSeconds;

  const VerifyAccountState({
    this.otpCode = '',
    this.isValid = false,
    this.isLoading = false,
    this.isSuccess = false,
    this.isResending = false,
    this.errorMessage,
    this.remainingSeconds = 300,
  });

  VerifyAccountState copyWith({
    String? otpCode,
    bool? isValid,
    bool? isLoading,
    bool? isSuccess,
    bool? isResending,
    String? errorMessage,
    int? remainingSeconds,
  }) {
    return VerifyAccountState(
      otpCode: otpCode ?? this.otpCode,
      isValid: isValid ?? this.isValid,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      isResending: isResending ?? this.isResending,
      errorMessage: errorMessage,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
    );
  }
}

class VerifyAccountNotifier extends StateNotifier<VerifyAccountState> {
  final Verify _verifyCodeUseCase;
  final ResendCode _resendCodeUseCase;
  final Ref _ref;
  Timer? _timer;

  VerifyAccountNotifier(
    this._verifyCodeUseCase,
    this._resendCodeUseCase,
    this._ref,
  ) : super(const VerifyAccountState()) {
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Start countdown timer
  void _startTimer() {
    _timer?.cancel();
    state = state.copyWith(remainingSeconds: 300);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingSeconds > 0) {
        state = state.copyWith(remainingSeconds: state.remainingSeconds - 1);
      } else {
        timer.cancel();
      }
    });
  }

  // Called when user completes input code
  void onCodeCompleted(String code) {
    final valid = Validation.isCodeActive(code);
    state = state.copyWith(otpCode: code, isValid: valid);
  }

  // Format remaining seconds to MM:SS
  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  // Verify code when pressing "Verify"
  Future<void> onVerify(BuildContext context) async {
    if (state.isLoading) return;
    if (!state.isValid) return;

    try {
      _setLoading(true);

      final phone = _getPhone();

      await _verifyCodeUseCase(phone, state.otpCode);
      _setLoading(false);

      if (!context.mounted) return;
      _handleSuccess(context, message: 'verify_account.success.verified'.tr());
      context.go(AppRoutes.login);
    } catch (e) {
      if (!context.mounted) return;
      _handleFailure(context, e);
    }
  }

  // Handle resend code
  Future<void> onResend(BuildContext context) async {
    try {
      state = state.copyWith(isResending: true, errorMessage: null);

      final phone = _getPhone();

      await _resendCodeUseCase(phone);

      state = state.copyWith(isResending: false);
      _startTimer();
      if (!context.mounted) return;
      _handleSuccess(
        context,
        message: 'verify_account.success.resend_code'.tr(),
      );
    } catch (e) {
      state = state.copyWith(isResending: false);
      if (!context.mounted) return;
      _handleFailure(context, e);
    }
  }

  // Handle success
  void _handleSuccess(BuildContext context, {required String message}) {
    state = state.copyWith(
      isLoading: false,
      isSuccess: true,
      errorMessage: null,
    );

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.bgPrimary,
        behavior: SnackBarBehavior.floating,
      ),
    );
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

  // Update loading state
  void _setLoading(bool value) {
    state = state.copyWith(isLoading: value, errorMessage: null);
  }

  // Translate errors from use case or API
  String _translateError(String error) {
    final key = error.replaceFirst('Exception: ', '').trim();

    switch (key) {
      case 'AUTH.VERIFY.USER_NOT_FOUND':
      case 'USER_NOT_FOUND':
      case 'User not found':
        return 'verify_account.errors.user_not_found'.tr();
      case 'AUTH.VERIFY.INVALID_OTP':
      case 'INVALID_OTP':
      case 'Invalid OTP code':
        return 'verify_account.errors.invalid_otp'.tr();
      case 'Invalid verification code':
        return 'verify_account.errors.invalid_verification_code'.tr();
      case 'AUTH.VERIFY.OTP_EXPIRED':
      case 'OTP_EXPIRED':
      case 'OTP code has expired':
        return 'verify_account.errors.otp_expired'.tr();
      case 'Verification code has expired':
        return 'verify_account.errors.verification_expired'.tr();
      case 'AUTH.VERIFY.ALREADY_VERIFIED':
      case 'Phone number already verified':
        return 'verify_account.errors.already_verified'.tr();
      case 'Failed to connect to the server':
        return 'verify_account.errors.failed_connect_server'.tr();
      default:
        return 'verify_account.errors.unexpected'.tr();
    }
  }

  // Handle back
  void onPressBack(BuildContext context) {
    final prev = _ref.read(previousPageProvider);

    switch (prev) {
      case 'register':
        context.go(AppRoutes.register);
        break;
      case 'login':
        context.go(AppRoutes.login);
        break;
      default:
        context.go(AppRoutes.register);
    }
  }

  /// Get phone
  String _getPhone() {
    final prev = _ref.read(previousPageProvider);
    if (prev == 'register') {
      final registerState = _ref.read(registerNotifierProvider);
      final phone = registerState.phoneController.text.trim();
      return phone;
    }

    if (prev == 'login') {
      final loginState = _ref.read(loginNotifierProvider);
      final phone = loginState.phoneController.text.trim();
      return phone;
    }
    return '';
  }

  /// Get purpose
  // String _getPurpose() {
  //   final prev = _ref.read(previousPageProvider);

  //   switch (prev) {
  //     case 'register':
  //       return 'register';
  //     case 'login':
  //       return 'login';
  //     default:
  //       return 'register';
  //   }
  // }
}
