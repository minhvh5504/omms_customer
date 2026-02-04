// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/profile/profile_provider.dart';
import '../widgets/setting_item.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(profileNotifierProvider.notifier).fetchData(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileNotifierProvider);
    final notifier = ref.read(profileNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.bgWhite,
      extendBody: true,
      body: SafeArea(
        child: state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User Info
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50.r),
                          child:
                              (state.user?.picture?.startsWith('http') == true)
                              ? Image.network(
                                  state.user!.picture!,
                                  width: 56.w,
                                  height: 56.w,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) {
                                    return Image.asset(
                                      'assets/images/user/avatar.png',
                                      width: 56.w,
                                      height: 56.w,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                )
                              : Image.asset(
                                  'assets/images/user/avatar.png',
                                  width: 56.w,
                                  height: 56.w,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        SizedBox(width: 12.w),
                        // Name and Phone
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                state.user?.fullName ?? 'Guest',
                                style: GoogleFonts.poppins(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.typoBlack,
                                ),
                              ),
                              Text(
                                state.user?.phone ?? '0336286050',
                                style: GoogleFonts.poppins(
                                  fontSize: 13.sp,
                                  color: AppColors.typoBody,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 24.h),

                    // Setting section
                    Text(
                      'profile.setting'.tr(),
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.typoBlack,
                      ),
                    ),

                    SizedBox(height: 12.h),

                    SettingItem(
                      icon: Icons.person_outline,
                      title: 'profile.my_account'.tr(),
                      onTap: () => notifier.onTapMyAccount(context),
                    ),
                    SettingItem(
                      icon: Icons.security,
                      title: 'profile.security'.tr(),
                      onTap: () => notifier.onTapSecurity(context),
                    ),
                    SettingItem(
                      icon: Icons.language,
                      title: 'profile.language'.tr(),
                      trailingText: state.currentLanguage,
                      onTap: () => notifier.onTapLanguage(context),
                    ),

                    SizedBox(height: 24.h),

                    // Information section
                    Text(
                      'profile.information'.tr(),
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.typoBlack,
                      ),
                    ),

                    SizedBox(height: 12.h),

                    SettingItem(
                      icon: Icons.help_outline,
                      title: 'profile.help_support'.tr(),
                      showChevron: false,
                      onTap: () => notifier.onTapHelpSupport(context),
                    ),
                    SettingItem(
                      icon: Icons.access_time,
                      title: 'profile.app_version'.tr(),
                      trailingText: 'v1.0.0',
                      showChevron: false,
                    ),

                    const Spacer(),

                    // Button logout
                    Center(
                      child: Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(bottom: 20.h),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: AppColors.bgDisable,
                              width: 1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                          ),
                          onPressed: () => notifier.onTapLogout(context),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.logout,
                                color: AppColors.typoError,
                                size: 20,
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                'profile.logout'.tr(),
                                style: GoogleFonts.poppins(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.typoError,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
