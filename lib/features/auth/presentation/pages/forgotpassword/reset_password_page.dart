import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/button/button.dart';
import '../../../../../core/widgets/textinput/input_textfield.dart';
import '../../providers/forgotpassword/reset_password_provider.dart';
import '../../widgets/auth_header.dart';

class ResetPasswordPage extends ConsumerWidget {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(resetPasswordNotifierProvider);
    final notifier = ref.read(resetPasswordNotifierProvider.notifier);

    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: AppColors.bgWhite,
      extendBody: true,
      resizeToAvoidBottomInset: true,

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Header
                AuthHeader(
                  title: 'reset_password.title'.tr(),
                  onBack: () => notifier.onPressBack(context),
                ),

                SizedBox(height: 8.h),

                // Subtitle
                Text(
                  'reset_password.subtitle'.tr(),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 13.sp,
                    color: AppColors.typoHeading,
                  ),
                ),

                SizedBox(height: 16.h),

                // New password field
                InputTextField(
                  controller: state.newPasswordController,
                  label: 'reset_password.new_password_label'.tr(),
                  isPassword: true,
                  hasError: state.hasNewPassError,
                  errorText: notifier.passwordErrorText,
                ),

                SizedBox(height: 8.h),

                // Confirm password field
                InputTextField(
                  controller: state.confirmPasswordController,
                  label: 'reset_password.confirm_new_password_label'.tr(),
                  isPassword: true,
                  hasError: state.hasConfirmPassError,
                  errorText: notifier.confirmPasswordErrorText,
                ),

                SizedBox(height: 60.h),
              ],
            ),
          ),
        ),
      ),

      // Submit button
      bottomNavigationBar: AnimatedPadding(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(
          left: 24.w,
          right: 24.w,
          bottom: keyboardHeight > 0 ? keyboardHeight + 16.h : 32.h,
        ),
        child: Button(
          text: 'reset_password.button_submit'.tr(),
          onPressed: state.isValid ? () => notifier.onSubmit(context) : null,
        ),
      ),
    );
  }
}
