// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_colors.dart';
import '../../config/routing/app_routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomBottomNavBar extends ConsumerStatefulWidget {
  final int initialIndex;

  const CustomBottomNavBar({super.key, required this.initialIndex});

  @override
  ConsumerState<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends ConsumerState<CustomBottomNavBar> {
  late int currentIndex;

  // SVG paths
  final List<String> icons = [
    'assets/icons/navigation/clipboard-text.svg',
    'assets/icons/navigation/cart.svg',
    'assets/icons/navigation/user.svg',
  ];

  final List<String> labels = ['Menu', 'Cart', 'Profile'];

  final List<String> routes = [
    AppRoutes.menu,
    AppRoutes.cart,
    AppRoutes.profile,
  ];

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.bgWhite,
        boxShadow: [
          BoxShadow(color: AppColors.bgBlur.withOpacity(0.25), blurRadius: 4.r),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(icons.length, (index) {
          return GestureDetector(
            onTap: () {
              setState(() => currentIndex = index);
              context.go(routes[index]);
            },
            child: Padding(
              padding: EdgeInsets.only(left: 10.w, right: 10.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedScale(
                    scale: 1.0,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOutBack,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 180),
                      opacity: 1.0,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          SvgPicture.asset(
                            icons[index],
                            width: 24.w,
                            height: 24.w,
                            colorFilter: ColorFilter.mode(
                              currentIndex == index
                                  ? Colors.orange
                                  : AppColors.typoDisable,
                              BlendMode.srcIn,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 4.w),

                  Text(
                    labels[index],
                    style: GoogleFonts.poppins(
                      fontSize: 10.sp,
                      color: currentIndex == index
                          ? Colors.orange
                          : AppColors.typoDisable,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
