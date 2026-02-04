import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';

class SettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? trailingText;
  final bool showChevron;
  final VoidCallback? onTap;

  const SettingItem({
    super.key,
    required this.icon,
    required this.title,
    this.trailingText,
    this.showChevron = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Row(
          children: [
            // Icon
            Icon(icon, color: AppColors.typoBlack, size: 24),
            SizedBox(width: 12.w),

            // Title
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  color: AppColors.typoBlack,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),

            // Trailing Text & Chevron
            if (trailingText != null || showChevron)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (trailingText != null)
                    Text(
                      trailingText!,
                      style: GoogleFonts.poppins(
                        fontSize: 13.sp,
                        color: AppColors.typoBlack,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  if (trailingText != null && showChevron) SizedBox(width: 4.w),
                  if (showChevron)
                    const Icon(
                      Icons.chevron_right,
                      color: AppColors.typoBlack,
                      size: 16,
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
