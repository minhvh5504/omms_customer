import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/button/button.dart';
import '../../../../../core/widgets/textinput/input_textfield.dart';
import '../../providers/login/login_provider.dart';
import '../../widgets/auth_header.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(loginNotifierProvider);
    final notifier = ref.read(loginNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuthHeader(title: 'login.welcome_back'.tr(), showBack: false),
              SizedBox(height: 40.h),

              // Phone
              InputTextField(
                controller: state.phoneController,
                label: 'login.phone_label'.tr(),
                hint: 'login.phone_hint'.tr(),
                keyboardType: TextInputType.phone,
                hasError: state.hasPhoneError,
                errorText: notifier.phoneErrorText,
              ),
              SizedBox(height: 24.h),

              // Password Field
              InputTextField(
                controller: state.passwordController,
                label: 'login.password_label'.tr(),
                hint: 'login.password_hint'.tr(),
                isPassword: true,
                hasError: state.hasPasswordError,
                errorText: notifier.passwordErrorText,
                suffixLabel: GestureDetector(
                  onTap: () => notifier.onForgotPassword(context),
                  child: Text(
                    'login.forgot_password'.tr(),
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.typoPrimary,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              // Remember Me
              Row(
                children: [
                  SizedBox(
                    height: 20.h,
                    width: 20.w,
                    child: Checkbox(
                      value: state.remember,
                      onChanged: notifier.toggleRemember,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      activeColor: AppColors.bgPrimary,
                      side: const BorderSide(color: Color(0xFFD1D5DB)),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'login.remember_me'.tr(),
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 24.h),

              // Login Button
              Button(
                text: 'login.login_button'.tr(),
                isLoading: state.isLoading,
                onPressed: state.isValid
                    ? () => notifier.onSignIn(context)
                    : null,
              ),

              SizedBox(height: 24.h),

              // Sign Up Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'login.no_account'.tr(),
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => notifier.onSignUp(context),
                    child: Text(
                      'login.sign_up'.tr(),
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
