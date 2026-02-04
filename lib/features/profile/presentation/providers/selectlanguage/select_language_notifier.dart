// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/config/routing/app_routes.dart';
import '../../../../../core/theme/app_colors.dart';

/// State
class SelectLanguageState {
  final String selectedLanguage;
  final String initialLanguage;
  final bool isChanged;
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;

  const SelectLanguageState({
    this.selectedLanguage = 'English',
    this.initialLanguage = 'English',
    this.isChanged = false,
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
  });

  SelectLanguageState copyWith({
    String? selectedLanguage,
    String? initialLanguage,
    bool? isChanged,
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return SelectLanguageState(
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      initialLanguage: initialLanguage ?? this.initialLanguage,
      isChanged: isChanged ?? this.isChanged,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
    );
  }
}

/// Notifier
class SelectLanguageNotifier extends StateNotifier<SelectLanguageState> {
  SelectLanguageNotifier() : super(const SelectLanguageState());

  /// Init current language
  Future<void> init(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final savedLang = prefs.getString('languageCode');

    String langCode;
    if (savedLang != null && savedLang.isNotEmpty) {
      langCode = savedLang;
    } else {
      langCode = context.locale.languageCode;
    }

    final lang = langCode == 'vi' ? 'Vietnamese' : 'English';

    state = state.copyWith(
      selectedLanguage: lang,
      initialLanguage: lang,
      isChanged: false,
    );
  }

  /// Select language
  void onSelect(String value) {
    final changed = value != state.initialLanguage;
    state = state.copyWith(selectedLanguage: value, isChanged: changed);
  }

  /// Save language
  Future<void> onSave(BuildContext context) async {
    if (!state.isChanged) return;

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final prefs = await SharedPreferences.getInstance();

      if (state.selectedLanguage == 'Vietnamese') {
        await context.setLocale(const Locale('vi'));
        await prefs.setString('languageCode', 'vi');
      } else {
        await context.setLocale(const Locale('en'));
        await prefs.setString('languageCode', 'en');
      }

      await Future.delayed(const Duration(milliseconds: 600));

      state = state.copyWith(
        isLoading: false,
        isSuccess: true,
        isChanged: false,
        initialLanguage: state.selectedLanguage,
      );

      context.go(AppRoutes.profile);
    } catch (e) {
      _handleFailure(context, e);
    }
  }

  /// Back
  void onPressBack(BuildContext context) {
    context.go(AppRoutes.profile);
  }

  /// Handle failure
  void _handleFailure(BuildContext context, Object error) {
    String errorMessage = 'Unknown error';

    if (error is DioException) {
      final data = error.response?.data;

      if (data is Map<String, dynamic>) {
        errorMessage = data['message']?.toString() ?? errorMessage;
      } else {
        errorMessage = error.message ?? errorMessage;
      }
    } else {
      errorMessage = error.toString();
    }

    final message = errorMessage;

    state = state.copyWith(isLoading: false, errorMessage: message);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.typoError,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
