// // ignore_for_file: use_build_context_synchronously

// import 'dart:async';
// import 'package:dio/dio.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';

// import '../../../../../core/config/routing/app_routes.dart';
// import '../../../../../core/providers/app_provider.dart';
// import '../../../../../core/theme/app_colors.dart';
// import '../../../../../core/utils/validation.dart';
// import '../../../domain/usecases/resend_code.dart';
// import '../../../domain/usecases/verify.dart';

// class VerifyPasswordState {
//   final String otpCode;
//   final bool isValid;
//   final bool isLoading;
//   final bool isSuccess;
//   final bool isResending;
//   final String? errorMessage;
//   final int remainingSeconds;

//   const VerifyPasswordState({
//     this.otpCode = '',
//     this.isValid = false,
//     this.isLoading = false,
//     this.isSuccess = false,
//     this.isResending = false,
//     this.errorMessage,
//     this.remainingSeconds = 300,
//   });

//   VerifyPasswordState copyWith({
//     String? otpCode,
//     bool? isValid,
//     bool? isLoading,
//     bool? isSuccess,
//     bool? isResending,
//     String? errorMessage,
//     int? remainingSeconds,
//   }) {
//     return VerifyPasswordState(
//       otpCode: otpCode ?? this.otpCode,
//       isValid: isValid ?? this.isValid,
//       isLoading: isLoading ?? this.isLoading,
//       isSuccess: isSuccess ?? this.isSuccess,
//       isResending: isResending ?? this.isResending,
//       errorMessage: errorMessage,
//       remainingSeconds: remainingSeconds ?? this.remainingSeconds,
//     );
//   }
// }

// class VerifyPasswordNotifier extends StateNotifier<VerifyPasswordState> {
//   final Verify _verifyCodeUseCase;
//   final ResendCode _resendCodeUseCase;
//   final Ref _ref;
//   Timer? _timer;

//   VerifyPasswordNotifier(
//     this._verifyCodeUseCase,
//     this._resendCodeUseCase,
//     this._ref,
//   ) : super(const VerifyPasswordState()) {
//     _startTimer();
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }

//   // Start countdown timer
//   void _startTimer() {
//     _timer?.cancel();
//     state = state.copyWith(remainingSeconds: 300);
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (state.remainingSeconds > 0) {
//         state = state.copyWith(remainingSeconds: state.remainingSeconds - 1);
//       } else {
//         timer.cancel();
//       }
//     });
//   }

//   // Called when user completes input code
//   void onCodeCompleted(String code) {
//     final valid = Validation.isCodeActive(code);
//     state = state.copyWith(otpCode: code, isValid: valid);
//   }

//   // Format remaining seconds to MM:SS
//   String formatTime(int seconds) {
//     final minutes = seconds ~/ 60;
//     final secs = seconds % 60;
//     return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
//   }

//   // Verify code when pressing "Verify"
//   Future<void> onVerify(BuildContext context) async {
//     if (state.isLoading) return;
//     if (!state.isValid) return;

//     try {
//       _setLoading(true);

//       final phone = _ref.read(sendRequestNotifierProvider).phone;

//       await _verifyCodeUseCase(phone, state.otpCode);
//       _setLoading(false);

//       context.go(AppRoutes.resetpassword);
//     } catch (e) {
//       _handleFailure(context, e);
//     }
//   }

//   // Handle resend code
//   Future<void> onResend(BuildContext context) async {
//     try {
//       state = state.copyWith(isResending: true, errorMessage: null);

//       final phone = _ref.read(sendRequestNotifierProvider).phone;

//       await _resendCodeUseCase(phone);

//       state = state.copyWith(isResending: false);
//       _startTimer();
//       _handleSuccess(
//         context,
//         message: 'verify_password.success.resend_code'.tr(),
//       );
//     } catch (e) {
//       state = state.copyWith(isResending: false);
//       _handleFailure(context, e);
//     }
//   }

//   // Handle success
//   void _handleSuccess(BuildContext context, {required String message}) {
//     state = state.copyWith(
//       isLoading: false,
//       isSuccess: true,
//       errorMessage: null,
//     );

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: AppColors.bgPrimary,
//         behavior: SnackBarBehavior.floating,
//       ),
//     );
//   }

//   // Handle failure
//   void _handleFailure(BuildContext context, Object error) {
//     String errorMessage = 'Unknown error';

//     if (error is DioException) {
//       final data = error.response?.data;

//       if (data is Map<String, dynamic>) {
//         errorMessage = data['message']?.toString() ?? errorMessage;
//       } else {
//         errorMessage = error.message ?? errorMessage;
//       }
//     } else {
//       errorMessage = error.toString();
//     }

//     final message = _translateError(errorMessage);

//     state = state.copyWith(isLoading: false, errorMessage: message);

//     ScaffoldMessenger.of(context)
//       ..clearSnackBars()
//       ..showSnackBar(
//         SnackBar(
//           content: Text(message),
//           backgroundColor: AppColors.typoError,
//           behavior: SnackBarBehavior.floating,
//         ),
//       );
//   }

//   // Update loading state
//   void _setLoading(bool value) {
//     state = state.copyWith(isLoading: value, errorMessage: null);
//   }

//   // Translate errors from use case or API
//   String _translateError(String errorMessage) {
//     final error = errorMessage.replaceFirst('Exception: ', '').trim();

//     switch (error) {
//       case 'Invalid phone':
//         return 'verify_password.errors.invalid_phone'.tr();
//       case 'Invalid code':
//         return 'verify_password.errors.invalid_code'.tr();
//       case 'Expired code':
//         return 'verify_password.errors.expired_code'.tr();
//       case 'Invalid OTP':
//         return 'verify_password.errors.invalid_otp'.tr();

//       default:
//         return 'verify_password.errors.unexpected'.tr();
//     }
//   }

//   // Navigate back to SendRequest page
//   void onPressBack(BuildContext context) {
//     context.go(AppRoutes.sendrequest);
//   }
// }
