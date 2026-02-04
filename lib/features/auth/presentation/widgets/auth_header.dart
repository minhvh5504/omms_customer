import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';

class AuthHeader extends StatelessWidget {
  final String? title;
  final VoidCallback? onBack;
  final bool showBack;

  const AuthHeader({
    super.key,
    this.title = '',
    this.onBack,
    this.showBack = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Back button
        if (showBack)
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: InkWell(
                borderRadius: BorderRadius.circular(8.r),
                onTap: onBack,
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 24.sp,
                  color: Colors.grey[600],
                ),
              ),
            ),
          )
        else
          SizedBox(height: 40.h),

        SizedBox(height: 12.h),

        // Logo Text
        Text(
          'OMMS',
          textAlign: TextAlign.center,
          style: GoogleFonts.playfairDisplay(
            fontSize: 32.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.typoBlack,
            letterSpacing: 1.2,
          ),
        ),

        if (title != null && title!.trim().isNotEmpty) ...[
          SizedBox(height: 12.h),
          Text(
            title!,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: AppColors.typoBody,
              height: 1.5,
            ),
          ),
        ],
      ],
    );
  }
}
