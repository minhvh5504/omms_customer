import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';

import '../../theme/app_colors.dart';
import '../button/button_dialog.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String cancelText;
  final String confirmText;
  final Color confirmColor;
  final HeroIcons icon;
  final Color iconColor;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;

  const ConfirmDialog({
    super.key,
    this.title = 'Are you sure?',
    required this.message,
    this.cancelText = 'Cancel',
    this.confirmText = 'Confirm',
    this.confirmColor = const Color(0xFF2563EB),
    this.icon = HeroIcons.exclamationCircle,
    this.iconColor = const Color(0xFF2563EB),
    required this.onConfirm,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: 30.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            HeroIcon(
              icon,
              color: iconColor,
              size: 64.w,
              style: HeroIconStyle.solid,
            ),
            SizedBox(height: 12.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.typoHeading,
              ),
            ),
            SizedBox(height: 10.w),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 12.sp,
                color: AppColors.typoBody,
              ),
            ),
            SizedBox(height: 30.w),
            Row(
              children: [
                Expanded(
                  child: ButtonDialog(
                    text: cancelText,
                    onTap: () => onCancel?.call(),
                    isPrimary: false,
                    textColor: AppColors.typoBody,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ButtonDialog(
                    text: confirmText,
                    onTap: () => {context.pop(), onConfirm()},
                    isPrimary: true,
                    color: confirmColor,
                    textColor: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.w),
          ],
        ),
      ),
    );
  }
}
