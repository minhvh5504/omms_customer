import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/button/button.dart';
import '../../../../../core/widgets/textinput/input_textfield.dart';
import '../../providers/register/register_provider.dart';
import '../../widgets/auth_header.dart';

class RegisterPage extends ConsumerWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(registerNotifierProvider);
    final notifier = ref.read(registerNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuthHeader(title: 'register.subtitle'.tr(), showBack: false),
              SizedBox(height: 40.h),

              // Full Name
              InputTextField(
                controller: state.fullNameController,
                label: 'register.fullname_label'.tr(),
                hint: 'register.fullname_hint'.tr(),
                keyboardType: TextInputType.name,
                hasError: state.hasFullNameError,
                errorText: notifier.fullNameErrorText,
              ),

              SizedBox(height: 8.h),

              // Phone
              InputTextField(
                controller: state.phoneController,
                label: 'register.phone_label'.tr(),
                hint: 'register.phone_hint'.tr(),
                keyboardType: TextInputType.phone,
                hasError: state.hasPhoneError,
                errorText: notifier.phoneErrorText,
              ),

              SizedBox(height: 8.h),

              // Password Field
              InputTextField(
                controller: state.passwordController,
                label: 'register.password_label'.tr(),
                hint: 'register.password_hint'.tr(),
                isPassword: true,
                hasError: state.hasPasswordError,
                errorText: notifier.passwordErrorText,
              ),

              SizedBox(height: 8.h),

              // Confirm Password Field
              InputTextField(
                controller: state.confirmPasswordController,
                label: 'register.confirm_password_label'.tr(),
                hint: 'register.confirm_password_hint'.tr(),
                isPassword: true,
                hasError: state.hasConfirmPasswordError,
                errorText: notifier.confirmPasswordErrorText,
              ),

              SizedBox(height: 24.h),

              // Sign Up Button
              Button(
                text: 'register.button_sign_up'.tr(),
                isLoading: state.isLoading,
                onPressed: state.isValid
                    ? () => notifier.onSignUp(context)
                    : null,
              ),

              SizedBox(height: 24.h),

              // Switch to Login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'register.footer_question'.tr(),
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => notifier.onSignIn(context),
                    child: Text(
                      'register.footer_action'.tr(),
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.typoPrimary,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.typoPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
