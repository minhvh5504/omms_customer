import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/helper.dart';
import '../../../../../core/widgets/button/button.dart';
import '../../../../../core/widgets/textinput/input_textfield.dart';
import '../../providers/forgotpassword/send_request_provider.dart';
import '../../widgets/auth_header.dart';

class SendRequestPage extends ConsumerWidget {
  const SendRequestPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sendRequestNotifierProvider);
    final notifier = ref.read(sendRequestNotifierProvider.notifier);

    final keyboardHeight = getKeyboardHeight(context);

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
                  title: 'send_request.title'.tr(),
                  onBack: () => notifier.onPressBack(context),
                ),

                SizedBox(height: 24.h),

                // Text field phone
                InputTextField(
                  controller: state.phoneController,
                  label: 'send_request.phone_label'.tr(),
                  keyboardType: TextInputType.phone,
                  hasError: state.hasPhoneError,
                  errorText: notifier.phoneErrorText,
                ),

                SizedBox(height: 100.h),
              ],
            ),
          ),
        ),
      ),

      // Button send code
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
              text: 'send_request.button_send_code'.tr(),
              onPressed: state.isValid
                  ? () => notifier.onSendCode(context)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
