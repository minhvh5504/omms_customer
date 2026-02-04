// // ignore_for_file: use_build_context_synchronously

// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// import '../../../../../core/presentation/theme/app_colors.dart';
// import '../../../../../core/presentation/widget/header/header_with_back.dart';
// import '../../../../core/presentation/widget/button/button.dart';
// import '../../../../core/presentation/widget/textinput/input_textfield.dart';
// import '../providers/changepassword/change_password_provider.dart';

// class ChangePasswordPage extends ConsumerWidget {
//   const ChangePasswordPage({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final state = ref.watch(changePasswordNotifierProvider);
//     final notifier = ref.read(changePasswordNotifierProvider.notifier);

//     return Scaffold(
//       backgroundColor: AppColors.bgWhite,
//       extendBody: true,

//       appBar: HeaderWithBack(
//         title: 'change_password.title'.tr(),
//         onBack: () => notifier.onPressBack(context),
//         onMore: () {},
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
//           child: Column(
//             children: [
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Current Password
//                       Text(
//                         'change_password.current_password'.tr(),
//                         style: TextStyle(
//                           fontSize: 14.sp,
//                           fontWeight: FontWeight.w500,
//                           color: AppColors.typoBody,
//                         ),
//                       ),
//                       SizedBox(height: 6.h),
//                       InputTextField(
//                         controller: state.currentPasswordController,
//                         isPassword: true,
//                         hasError: state.hasCurrentPassError,
//                         errorText: notifier.currentPasswordErrorText,
//                       ),

//                       SizedBox(height: 16.h),

//                       // New Password
//                       Text(
//                         'change_password.new_password'.tr(),
//                         style: TextStyle(
//                           fontSize: 14.sp,
//                           fontWeight: FontWeight.w500,
//                           color: AppColors.typoBody,
//                         ),
//                       ),
//                       SizedBox(height: 6.h),
//                       InputTextField(
//                         controller: state.newPasswordController,
//                         isPassword: true,
//                         hasError: state.hasNewPassError,
//                         errorText: notifier.passwordErrorText,
//                       ),

//                       SizedBox(height: 16.h),

//                       // Confirm New Password
//                       Text(
//                         'change_password.confirm_new_password'.tr(),
//                         style: TextStyle(
//                           fontSize: 14.sp,
//                           fontWeight: FontWeight.w500,
//                           color: AppColors.typoBody,
//                         ),
//                       ),
//                       SizedBox(height: 6.h),
//                       InputTextField(
//                         controller: state.confirmPasswordController,
//                         isPassword: true,
//                         hasError: state.hasConfirmPassError,
//                         errorText: notifier.confirmPasswordErrorText,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//               // Submit button
//               Button(
//                 text: 'change_password.submit'.tr(),
//                 onPressed: (state.isValid && !state.isLoading)
//                     ? () => notifier.onSubmit(context)
//                     : null,
//               ),

//               SizedBox(height: 16.h),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
