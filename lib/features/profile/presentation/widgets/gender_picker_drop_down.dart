import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';

class GenderPickerDropdown extends StatelessWidget {
  final Function(String) onSelect;

  const GenderPickerDropdown({super.key, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final genders = [
      {'display': 'change_profile.male'.tr(), 'value': 'male'},
      {'display': 'change_profile.female'.tr(), 'value': 'female'},
      {'display': 'change_profile.other'.tr(), 'value': 'other'},
    ];

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(maxHeight: 200.h, minHeight: 50.h),
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),

      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: genders.length,
        itemBuilder: (_, index) {
          final item = genders[index];

          return InkWell(
            onTap: () {
              Navigator.pop(context);
              onSelect(item['value']!);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Center(
                child: Text(
                  item['display']!,
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.typoBlack,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
