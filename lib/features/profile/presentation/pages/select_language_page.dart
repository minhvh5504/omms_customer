// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/button/button.dart';
import '../../../../core/widgets/header/header_with_back.dart';
import '../providers/selectlanguage/select_language_provider.dart';
import '../widgets/select_option_item.dart';

class SelectLanguagePage extends ConsumerStatefulWidget {
  const SelectLanguagePage({super.key});

  @override
  ConsumerState<SelectLanguagePage> createState() => _SelectLanguagePageState();
}

class _SelectLanguagePageState extends ConsumerState<SelectLanguagePage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(selectLanguageNotifierProvider.notifier).init(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(selectLanguageNotifierProvider);
    final notifier = ref.read(selectLanguageNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.bgWhite,
      extendBody: true,

      appBar: HeaderWithBack(
        title: 'language.language'.tr(),
        onBack: () => notifier.onPressBack(context),
        onMore: () {},
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    // English
                    SelectOptionItem(
                      label: 'language.english'.tr(),
                      value: 'English',
                      groupValue: state.selectedLanguage,
                      onChanged: notifier.onSelect,
                    ),

                    SizedBox(height: 12.h),

                    // Vietnamese
                    SelectOptionItem(
                      label: 'language.vietnamese'.tr(),
                      value: 'Vietnamese',
                      groupValue: state.selectedLanguage,
                      onChanged: notifier.onSelect,
                    ),
                  ],
                ),
              ),

              // Save button
              Button(
                text: 'language.save'.tr(),
                onPressed: state.isChanged && !state.isLoading
                    ? () => notifier.onSave(context)
                    : null,
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}
