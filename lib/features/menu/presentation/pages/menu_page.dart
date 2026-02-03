import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/menu_provider.dart';

class MenuPage extends ConsumerWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(menuNotifierProvider);
    final notifier = ref.read(menuNotifierProvider.notifier);

    if (state.isLoading && state.categories.isEmpty) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.bgPrimary),
        ),
      );
    }

    if (state.errorMessage != null && state.categories.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: Text('Error: ${state.errorMessage}')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20.h),
            // Header
            Text(
              'Menu',
              textAlign: TextAlign.center,
              style: GoogleFonts.playfairDisplay(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.typoBlack,
              ),
            ),
            SizedBox(height: 16.h),

            // Categories
            SizedBox(
              height: 30.h,
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                scrollDirection: Axis.horizontal,
                itemCount: state.categories.length,
                separatorBuilder: (_, __) => SizedBox(width: 32.w),
                itemBuilder: (context, index) {
                  final isSelected = state.selectedCategoryIndex == index;
                  final category = state.categories[index];

                  return GestureDetector(
                    onTap: () => notifier.selectCategory(index),
                    child: IntrinsicWidth(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            category.name,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 14.sp,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              color: isSelected
                                  ? AppColors.typoBlack
                                  : Colors.grey.shade400,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          if (isSelected)
                            Container(height: 2.h, color: AppColors.bgPrimary)
                          else
                            SizedBox(height: 2.h),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 16.h),

            // Item List
            Expanded(
              child: state.isLoading && state.items.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.bgPrimary,
                      ),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 16.h,
                      ),
                      itemCount: state.items.length,
                      separatorBuilder: (_, __) => Column(
                        children: [
                          SizedBox(height: 16.h),
                          const Divider(color: Color(0xFFF3F4F6), thickness: 1),
                          SizedBox(height: 16.h),
                        ],
                      ),
                      itemBuilder: (context, index) {
                        final item = state.items[index];
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Image
                            ClipOval(
                              child: Image.network(
                                item.imageUrl,
                                width: 80.w,
                                height: 80.w,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 80.w,
                                    height: 80.w,
                                    color: Colors.grey.shade200,
                                    child: Icon(
                                      Icons.fastfood,
                                      color: Colors.grey.shade400,
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(width: 16.w),

                            // Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    style: GoogleFonts.inter(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.typoBlack,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    item.description,
                                    style: GoogleFonts.inter(
                                      fontSize: 12.sp,
                                      color: Colors.grey.shade400,
                                      height: 1.4,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 12.h),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        item.price,
                                        style: GoogleFonts.inter(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.typoBlack,
                                        ),
                                      ),
                                      Container(
                                        width: 28.w,
                                        height: 28.w,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            8.r,
                                          ),
                                          border: Border.all(
                                            color: Colors.grey.shade200,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.add,
                                          size: 16.sp,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
