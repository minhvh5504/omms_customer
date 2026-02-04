// // Represents the state of the Send Request screen
// // ignore_for_file: use_build_context_synchronously

// import 'package:dio/dio.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';

// import '../../../../../core/config/routing/app_routes.dart';
// import '../../../../../core/theme/app_colors.dart';
// import '../../../../../core/utils/validation.dart';
// import '../../../domain/usecases/send_request.dart';

// class SendRequestState {
//   final TextEditingController phoneController;
//   final String phone;
//   final bool phoneValid;
//   final bool hasPhoneError;
//   final bool isValid;
//   final bool isLoading;
//   final bool isSuccess;
//   final String? errorMessage;

//   const SendRequestState({
//     required this.phoneController,
//     this.phone = '',
//     this.phoneValid = false,
//     this.hasPhoneError = false,
//     this.isValid = false,
//     this.isLoading = false,
//     this.isSuccess = false,
//     this.errorMessage,
//   });

//   SendRequestState copyWith({
//     TextEditingController? phoneController,
//     String? phone,
//     bool? phoneValid,
//     bool? hasPhoneError,
//     bool? isValid,
//     bool? isLoading,
//     bool? isSuccess,
//     String? errorMessage,
//   }) {
//     return SendRequestState(
//       phoneController: phoneController ?? this.phoneController,
//       phone: phone ?? this.phone,
//       phoneValid: phoneValid ?? this.phoneValid,
//       hasPhoneError: hasPhoneError ?? this.hasPhoneError,
//       isValid: isValid ?? this.isValid,
//       isLoading: isLoading ?? this.isLoading,
//       isSuccess: isSuccess ?? this.isSuccess,
//       errorMessage: errorMessage,
//     );
//   }
// }

// class SendRequestNotifier extends StateNotifier<SendRequestState> {
//   final SendRequest _sendRequestUseCase;

//   SendRequestNotifier(this._sendRequestUseCase)
//     : super(SendRequestState(phoneController: TextEditingController())) {
//     _initListeners();
//   }

//   // Listen to input changes and validate
//   void _initListeners() {
//     state.phoneController.addListener(_validateInput);
//   }

//   // Validate phone input
//   void _validateInput() {
//     final text = state.phoneController.text.trim();

//     // true = valid input
//     final valid = Validation.isPhoneValid(text);

//     // true = show red border
//     final hasPhoneError = !valid && text.isNotEmpty;

//     state = state.copyWith(
//       phone: text,
//       phoneValid: valid,
//       hasPhoneError: hasPhoneError,
//       isValid: valid,
//     );
//   }

//   // Trigger when user presses "Send Code"
//   Future<void> onSendCode(BuildContext context) async {
//     final input = state.phone.trim();

//     try {
//       _setLoading(true);
//       await _sendRequestUseCase(input);
//       await _handleSuccess(context);
//     } catch (e) {
//       _handleFailure(context, e);
//     }
//   }

//   /// Get error text
//   String? get phoneErrorText {
//     final text = state.phoneController.text.trim();

//     if (text.isEmpty) return null;

//     if (!Validation.isPhoneValid(text)) {
//       return 'send_request.error_invalid_phone'.tr();
//     }

//     return null;
//   }

//   // Handle success
//   Future<void> _handleSuccess(BuildContext context) async {
//     _setLoading(false);
//     state = state.copyWith(isSuccess: true);

//     context.go(AppRoutes.verifypassword);
//   }

//   // Handle failure
//   void _handleFailure(BuildContext context, Object error) {
//     if (state.isLoading) return;
//     if (!state.isValid) return;
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

//   // Translate error messages
//   String _translateError(String errorMessage) {
//     final error = errorMessage.replaceFirst('Exception: ', '').trim();

//     switch (error) {
//       case 'User not found':
//         return 'send_request.errors.user_not_found'.tr();
//       default:
//         return 'send_request.errors.unexpected'.tr();
//     }
//   }

//   // Navigate to Login page
//   void onPressBack(BuildContext context) {
//     context.go(AppRoutes.login);
//   }

//   // Dispose controller when not needed
//   @override
//   void dispose() {
//     state.phoneController.dispose();
//     super.dispose();
//   }
// }
