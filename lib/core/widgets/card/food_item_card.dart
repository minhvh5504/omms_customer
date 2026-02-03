import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_colors.dart';

class FoodItemCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String description;
  final String? price;
  final String? time;
  final int quantity;
  final bool showAdd;
  final bool showQuantityControls;
  final bool showDelete;
  final bool showTime;
  final bool showPrice;
  final VoidCallback? onAdd;
  final VoidCallback? onDelete;
  final VoidCallback? onIncrease;
  final VoidCallback? onDecrease;
  final VoidCallback? onTap;

  const FoodItemCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.description,
    this.price,
    this.time,
    this.quantity = 1,
    this.showAdd = false,
    this.showQuantityControls = false,
    this.showDelete = false,
    this.showTime = false,
    this.showPrice = false,
    this.onAdd,
    this.onDelete,
    this.onIncrease,
    this.onDecrease,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipOval(
            child: Image.network(
              imageUrl,
              width: 80.w,
              height: 80.w,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 80.w,
                  height: 80.w,
                  color: Colors.grey.shade200,
                  child: Icon(Icons.fastfood, color: Colors.grey.shade400),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.typoBlack,
                        ),
                      ),
                    ),
                    if (showDelete)
                      GestureDetector(
                        onTap: onDelete,
                        behavior: HitTestBehavior.opaque,
                        child: Icon(
                          Icons.delete_outline,
                          color: const Color(0xFFFF8B8B),
                          size: 20.sp,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  description,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: Colors.grey.shade400,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left Bottom: Price or Time
                    Row(
                      children: [
                        if (showPrice && price != null)
                          Text(
                            price!,
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.typoBlack,
                            ),
                          ),
                        if (showTime && time != null) ...[
                          Icon(
                            Icons.access_time,
                            size: 14.sp,
                            color: Colors.grey.shade400,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            time!,
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ],
                      ],
                    ),

                    // Right Bottom: Add Button or Quantity Controls
                    if (showAdd)
                      GestureDetector(
                        onTap: onAdd,
                        child: Container(
                          width: 28.w,
                          height: 28.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Icon(
                            Icons.add,
                            size: 16.sp,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),

                    if (showQuantityControls)
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: onDecrease,
                              child: Icon(
                                Icons.remove,
                                size: 16.sp,
                                color: AppColors.typoBlack,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Text(
                              '$quantity',
                              style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.typoBlack,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            GestureDetector(
                              onTap: onIncrease,
                              child: Icon(
                                Icons.add,
                                size: 16.sp,
                                color: AppColors.typoBlack,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
