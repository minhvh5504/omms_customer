// // ignore_for_file: use_build_context_synchronously

// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:heroicons/heroicons.dart';

// import '../../../../../core/presentation/theme/app_colors.dart';
// import '../../../../../core/presentation/widget/header/header_with_back.dart';
// import '../../../../core/presentation/widget/button/button.dart';
// import '../../../../core/presentation/widget/textinput/input_textfield.dart';
// import '../providers/changeprofile/change_profile_provider.dart';

// class ChangeProfilePage extends ConsumerWidget {
//   const ChangeProfilePage({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final state = ref.watch(changeProfileNotifierProvider);
//     final notifier = ref.read(changeProfileNotifierProvider.notifier);

//     return Scaffold(
//       backgroundColor: AppColors.bgWhite,
//       extendBody: true,

//       appBar: HeaderWithBack(
//         title: 'change_profile.title'.tr(),
//         onBack: () => notifier.onBack(context),
//         onMore: () {},
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
//           child: Column(
//             children: [
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       // Avatar
//                       Stack(
//                         clipBehavior: Clip.none,
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(60.r),
//                             child:
//                                 (state.user?.picture?.startsWith('http') ==
//                                     true)
//                                 ? Image.network(
//                                     state.user!.picture!,
//                                     width: 130.w,
//                                     height: 130.w,
//                                     fit: BoxFit.cover,
//                                     errorBuilder: (_, __, ___) {
//                                       return Image.asset(
//                                         'assets/images/user/avatar.png',
//                                         width: 130.w,
//                                         height: 130.w,
//                                         fit: BoxFit.cover,
//                                       );
//                                     },
//                                   )
//                                 : Image.asset(
//                                     'assets/images/user/avatar.png',
//                                     width: 130.w,
//                                     height: 130.w,
//                                     fit: BoxFit.cover,
//                                   ),
//                           ),
//                           Positioned(
//                             bottom: 10.w,
//                             left: 100.w,
//                             child: InkWell(
//                               onTap: () => notifier.showPicker(context),
//                               child: Container(
//                                 width: 24.w,
//                                 height: 24.w,
//                                 decoration: const BoxDecoration(
//                                   color: AppColors.bgPrimary,
//                                   borderRadius: BorderRadius.all(
//                                     Radius.circular(8),
//                                   ),
//                                 ),
//                                 child: const Center(
//                                   child: HeroIcon(
//                                     HeroIcons.pencil,
//                                     style: HeroIconStyle.solid,
//                                     color: AppColors.typoWhite,
//                                     size: 14,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),

//                       SizedBox(height: 14.h),

//                       /// Full name
//                       InputTextField(
//                         hint: 'change_profile.full_name'.tr(),
//                         controller: state.fullNameController,
//                         hasError: state.hasNameError,
//                       ),

//                       SizedBox(height: 14.h),

//                       /// Gender popup
//                       Builder(
//                         builder: (localContext) {
//                           return InkWell(
//                             borderRadius: BorderRadius.circular(16.r),
//                             onTap: () => notifier.openGenderPopup(localContext),

//                             child: Container(
//                               height: 38.h,
//                               padding: EdgeInsets.symmetric(horizontal: 16.w),
//                               decoration: BoxDecoration(
//                                 color: AppColors.bgHover,
//                                 borderRadius: BorderRadius.circular(16.r),
//                                 border: Border.all(
//                                   color: AppColors.bgDisable,
//                                   width: 0.5.w,
//                                 ),
//                               ),

//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Expanded(
//                                     child: Text(
//                                       state.gender == null
//                                           ? 'change_profile.select_gender'.tr()
//                                           : notifier.formatGender(
//                                               state.gender!,
//                                             ),
//                                       style: GoogleFonts.poppins(
//                                         fontSize: 14.sp,
//                                         color:
//                                             (state.gender == null ||
//                                                 state.gender!.trim().isEmpty)
//                                             ? AppColors.typoBody.withOpacity(
//                                                 0.5,
//                                               )
//                                             : AppColors.typoHeading,
//                                       ),
//                                     ),
//                                   ),
//                                   SvgPicture.asset(
//                                     height: 20.w,
//                                     width: 20.w,
//                                     state.isGenderSelecting
//                                         ? 'assets/icons/schedule/arrown_top.svg'
//                                         : 'assets/icons/schedule/arrown_down.svg',
//                                     color: AppColors.typoBody.withOpacity(0.7),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       ),

//                       SizedBox(height: 14.h),

//                       /// Phone
//                       InputTextField(
//                         hint: 'change_profile.phone'.tr(),
//                         controller: state.phoneController,
//                         keyboardType: TextInputType.phone,
//                         readOnly: true,
//                         isEmailOrPhone: true,
//                         suffixIcon: const HeroIcon(
//                           HeroIcons.chevronRight,
//                           color: AppColors.typoBody,
//                           size: 18,
//                         ),
//                         onTap: () => notifier.handlePhoneTap(context),
//                       ),

//                       SizedBox(height: 14.h),

//                       /// Email
//                       InputTextField(
//                         hint: 'change_profile.email'.tr(),
//                         controller: state.emailController,
//                         keyboardType: TextInputType.emailAddress,
//                         readOnly: true,
//                         isEmailOrPhone: true,
//                         suffixIcon: const HeroIcon(
//                           HeroIcons.chevronRight,
//                           color: AppColors.typoBody,
//                           size: 18,
//                         ),
//                         onTap: () => notifier.handleEmailTap(context),
//                       ),

//                       SizedBox(height: 14.h),

//                       // Birthday
//                       InputTextField(
//                         hint: 'change_profile.birthday'.tr(),
//                         controller: state.birthdayController,
//                         suffixIcon: const HeroIcon(
//                           HeroIcons.calendarDays,
//                           style: HeroIconStyle.solid,
//                           color: AppColors.typoBody,
//                           size: 20,
//                         ),
//                         onTap: () => notifier.pickBirthday(context),
//                       ),

//                       SizedBox(height: 14.h),
//                     ],
//                   ),
//                 ),
//               ),

//               // Button save
//               Button(
//                 text: 'change_profile.save'.tr(),
//                 onPressed: (!state.hasChanges || state.isLoading)
//                     ? null
//                     : () => notifier.onSave(context),
//               ),
//               SizedBox(height: 16.h),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
