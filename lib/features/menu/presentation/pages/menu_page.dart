import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/card/food_item_card.dart';
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
              'menu.title'.tr(),
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
                          SizedBox(height: 8.h),
                          const Divider(color: Color(0xFFF3F4F6), thickness: 1),
                          SizedBox(height: 16.h),
                        ],
                      ),
                      itemBuilder: (context, index) {
                        final item = state.items[index];
                        return FoodItemCard(
                          imageUrl: item.imageUrl,
                          name: item.name,
                          description: item.description,
                          price: item.price,
                          showPrice: true,
                          showAdd: true,
                          onAdd: () {
                            notifier.handleAddToCart(item);
                          },
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
