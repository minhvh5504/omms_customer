import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/helper.dart';
import '../../../../../core/widgets/button/button.dart';
import '../../providers/register/verify_account_provider.dart';
import '../../widgets/auth_header.dart';

class VerifyAccountPage extends ConsumerWidget {
  const VerifyAccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(verifyAccountNotifierProvider);
    final notifier = ref.read(verifyAccountNotifierProvider.notifier);

    final keyboardHeight = getKeyboardHeight(context);

    // Pin default
    final defaultPinTheme = PinTheme(
      width: 70.w,
      height: 55.w,
      textStyle: GoogleFonts.poppins(
        fontSize: 22.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.typoBody,
      ),
      decoration: BoxDecoration(
        color: AppColors.bgWhite,
        border: Border.all(color: AppColors.bgDisable),
        borderRadius: BorderRadius.circular(12.r),
      ),
    );

    // Pin focused
    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: AppColors.bgWhite,
        border: Border.all(color: AppColors.typoPrimary, width: 1.8),
        borderRadius: BorderRadius.circular(12.r),
      ),
    );

    // Pin submitted
    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: AppColors.bgWhite,
        border: Border.all(color: AppColors.bgDisable),
        borderRadius: BorderRadius.circular(12.r),
      ),
    );

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
                  title: 'verify_account.title'.tr(),
                  onBack: () => notifier.onPressBack(context),
                ),

                SizedBox(height: 8.h),

                // Subtitle
                Text(
                  'verify_account.subtitle'.tr(),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    color: AppColors.typoHeading,
                  ),
                ),

                SizedBox(height: 24.h),

                // OTP input
                Pinput(
                  length: 6,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: focusedPinTheme,
                  submittedPinTheme: submittedPinTheme,
                  keyboardType: TextInputType.number,
                  onCompleted: notifier.onCodeCompleted,
                ),

                SizedBox(height: 20.h),

                // Title & Resend
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'verify_account.question_not_receive'.tr(),
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        color: AppColors.typoBody,
                      ),
                    ),
                    if (state.remainingSeconds > 0)
                      Text(
                        notifier.formatTime(state.remainingSeconds),
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          color: AppColors.typoBody,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    else
                      InkWell(
                        borderRadius: BorderRadius.circular(8.r),
                        onTap: state.isResending
                            ? null
                            : () => notifier.onResend(context),
                        child: Text(
                          'verify_account.resend'.tr(),
                          style: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            color: state.isResending
                                ? AppColors.typoBody
                                : AppColors.typoPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),

                SizedBox(height: 60.h),
              ],
            ),
          ),
        ),
      ),

      // Button verify
      bottomNavigationBar: AnimatedPadding(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(
          left: 24.w,
          right: 24.w,
          bottom: keyboardHeight > 0 ? keyboardHeight + 16.h : 32.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Button(
              text: 'verify_account.button_verify'.tr(),
              onPressed: state.isValid
                  ? () => notifier.onVerify(context)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
