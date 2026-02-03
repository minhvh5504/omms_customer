import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_colors.dart';

class HeaderWithBack extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;
  final VoidCallback? onMore;
  final bool showBack;
  final bool showMore;

  const HeaderWithBack({
    super.key,
    required this.title,
    this.onBack,
    this.onMore,
    this.showBack = true,
    this.showMore = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.bgWhite,
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: showBack,
      // Title
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.typoBlack,
        ),
      ),

      // Back icon
      leading: showBack
          ? InkWell(
              borderRadius: BorderRadius.circular(50.r),
              onTap: onBack,
              child: Padding(
                padding: EdgeInsets.all(10.w),
                child: const Icon(
                  Icons.arrow_back,
                  color: AppColors.typoBody,
                  size: 22,
                ),
              ),
            )
          : null,

      // More icon
      actions: showMore
          ? [
              InkWell(
                borderRadius: BorderRadius.circular(50.r),
                onTap: onMore,
                child: Padding(
                  padding: EdgeInsets.all(10.w),
                  child: const Icon(
                    Icons.more_vert,
                    color: AppColors.typoBody,
                    size: 22,
                  ),
                ),
              ),
            ]
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
