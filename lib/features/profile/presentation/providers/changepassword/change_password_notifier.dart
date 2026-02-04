// import 'package:dio/dio.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';

// import '../../../../../core/config/routing/app_routes.dart';
// import '../../../../../core/presentation/theme/app_colors.dart';
// import '../../../../../core/utils/validation.dart';
// import '../../../domain/usecases/change_password.dart';

// /// State
// class ChangePasswordState {
//   final TextEditingController currentPasswordController;
//   final TextEditingController newPasswordController;
//   final TextEditingController confirmPasswordController;
//   final bool currentPassValid;
//   final bool newPassValid;
//   final bool confirmPassValid;
//   final bool hasCurrentPassError;
//   final bool hasNewPassError;
//   final bool hasConfirmPassError;
//   final bool isValid;
//   final bool isLoading;
//   final bool isSuccess;
//   final String? errorMessage;

//   const ChangePasswordState({
//     required this.currentPasswordController,
//     required this.newPasswordController,
//     required this.confirmPasswordController,
//     this.currentPassValid = false,
//     this.newPassValid = false,
//     this.confirmPassValid = false,
//     this.hasCurrentPassError = false,
//     this.hasNewPassError = false,
//     this.hasConfirmPassError = false,
//     this.isValid = false,
//     this.isLoading = false,
//     this.isSuccess = false,
//     this.errorMessage,
//   });

//   ChangePasswordState copyWith({
//     bool? isValid,
//     bool? isLoading,
//     bool? isSuccess,
//     String? errorMessage,
//     bool? currentPassValid,
//     bool? newPassValid,
//     bool? confirmPassValid,
//     bool? hasCurrentPassError,
//     bool? hasNewPassError,
//     bool? hasConfirmPassError,
//   }) {
//     return ChangePasswordState(
//       currentPasswordController: currentPasswordController,
//       newPasswordController: newPasswordController,
//       confirmPasswordController: confirmPasswordController,
//       currentPassValid: currentPassValid ?? this.currentPassValid,
//       newPassValid: newPassValid ?? this.newPassValid,
//       confirmPassValid: confirmPassValid ?? this.confirmPassValid,
//       hasCurrentPassError: hasCurrentPassError ?? this.hasCurrentPassError,
//       hasNewPassError: hasNewPassError ?? this.hasNewPassError,
//       hasConfirmPassError: hasConfirmPassError ?? this.hasConfirmPassError,
//       isValid: isValid ?? this.isValid,
//       isLoading: isLoading ?? this.isLoading,
//       isSuccess: isSuccess ?? this.isSuccess,
//       errorMessage: errorMessage,
//     );
//   }
// }

// /// Notifier
// class ChangePasswordNotifier extends StateNotifier<ChangePasswordState> {
//   final ChangePassword _changePasswordUseCase;

//   ChangePasswordNotifier(this._changePasswordUseCase)
//     : super(
//         ChangePasswordState(
//           currentPasswordController: TextEditingController(),
//           newPasswordController: TextEditingController(),
//           confirmPasswordController: TextEditingController(),
//         ),
//       ) {
//     _initListeners();
//   }

//   /// Validation
//   void _initListeners() {
//     state.currentPasswordController.addListener(_validateAll);
//     state.newPasswordController.addListener(_validateAll);
//     state.confirmPasswordController.addListener(_validateAll);
//   }

//   // Validate all password fields
//   void _validateAll() {
//     final current = state.currentPasswordController.text.trim();
//     final newPass = state.newPasswordController.text.trim();
//     final confirmPass = state.confirmPasswordController.text.trim();

//     final currentValid = Validation.isStrongPassword(current);
//     final newValid = Validation.isStrongPassword(newPass);
//     final confirmValid = confirmPass == newPass;

//     final valid = currentValid && newValid && confirmValid;

//     state = state.copyWith(
//       isValid: valid,

//       hasCurrentPassError: !currentValid && current.isNotEmpty,
//       hasNewPassError: !newValid && newPass.isNotEmpty,
//       hasConfirmPassError: !confirmValid && confirmPass.isNotEmpty,
//     );
//   }

//   /// Get error current password text
//   String? get currentPasswordErrorText {
//     final text = state.currentPasswordController.text;

//     if (text.isEmpty) return null;

//     if (text.length < 8) {
//       return 'change_password.error_password_min_length'.tr();
//     }

//     if (!RegExp(r'[a-z]').hasMatch(text)) {
//       return 'change_password.error_password_lowercase'.tr();
//     }

//     if (!RegExp(r'[A-Z]').hasMatch(text)) {
//       return 'change_password.error_password_uppercase'.tr();
//     }

//     if (!RegExp(r'[!@#$%^&*]').hasMatch(text)) {
//       return 'change_password.error_password_special'.tr();
//     }

//     return null;
//   }

//   /// Get error password text
//   String? get passwordErrorText {
//     final text = state.newPasswordController.text;

//     if (text.isEmpty) return null;

//     if (text.length < 8) {
//       return 'change_password.error_password_min_length'.tr();
//     }

//     if (!RegExp(r'[a-z]').hasMatch(text)) {
//       return 'change_password.error_password_lowercase'.tr();
//     }

//     if (!RegExp(r'[A-Z]').hasMatch(text)) {
//       return 'change_password.error_password_uppercase'.tr();
//     }

//     if (!RegExp(r'[!@#$%^&*]').hasMatch(text)) {
//       return 'change_password.error_password_special'.tr();
//     }

//     return null;
//   }

//   /// Get error confirm password text
//   String? get confirmPasswordErrorText {
//     final text = state.confirmPasswordController.text;

//     if (text.isEmpty) return null;

//     if (text != state.newPasswordController.text) {
//       return 'change_password.error_password_match'.tr();
//     }

//     return null;
//   }

//   /// Submit
//   Future<void> onSubmit(BuildContext context) async {
//     if (!state.isValid) return;

//     state = state.copyWith(isLoading: true, errorMessage: null);

//     final currentPass = state.currentPasswordController.text.trim();
//     final newPass = state.newPasswordController.text.trim();

//     try {
//       await _changePasswordUseCase(currentPass, newPass);

//       await Future.delayed(const Duration(milliseconds: 600));

//       state = state.copyWith(isLoading: false, isSuccess: true);

//       context.go(AppRoutes.profile);
//     } catch (e) {
//       _handleFailure(context, e);
//     }
//   }

//   /// Navigation
//   void onPressBack(BuildContext context) {
//     context.go(AppRoutes.profile);
//   }

//   /// Handle failure
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

//     final message = errorMessage;

//     state = state.copyWith(isLoading: false, errorMessage: message);

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: AppColors.typoError,
//         behavior: SnackBarBehavior.floating,
//       ),
//     );
//   }

//   /// Dispose
//   @override
//   void dispose() {
//     state.currentPasswordController.dispose();
//     state.newPasswordController.dispose();
//     state.confirmPasswordController.dispose();
//     super.dispose();
//   }
// }
