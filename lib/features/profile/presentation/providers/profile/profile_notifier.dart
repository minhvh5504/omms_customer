// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/config/routing/app_routes.dart';
import '../../../domain/entities/user.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/dialog/confirm_dialog.dart';
import '../../../../auth/presentation/providers/auth/auth_provider.dart';
import '../../../domain/usecases/get_user.dart';

/// State
class ProfileState {
  final User? user;
  final bool isLoading;
  final String? errorMessage;
  final String currentLanguage;

  const ProfileState({
    this.user,
    this.isLoading = false,
    this.errorMessage,
    this.currentLanguage = 'English',
  });

  ProfileState copyWith({
    User? user,
    bool? isLoading,
    String? errorMessage,
    String? currentLanguage,
  }) {
    return ProfileState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      currentLanguage: currentLanguage ?? this.currentLanguage,
    );
  }
}

/// Notifier
class ProfileNotifier extends StateNotifier<ProfileState> {
  final GetUser _getUserUseCase;
  final Ref ref;

  ProfileNotifier(this._getUserUseCase, this.ref) : super(const ProfileState());

  /// Fetch data
  Future<void> fetchData(
    BuildContext context, {
    bool showLoading = true,
  }) async {
    final shouldFetchUser = state.user == null;

    if (showLoading && shouldFetchUser) {
      state = state.copyWith(isLoading: true);
    }

    try {
      final prefs = await SharedPreferences.getInstance();

      final user = await _getUserUseCase();

      final langCode = prefs.getString('languageCode') ?? 'vi';
      final currentLanguage = langCode == 'vi' ? 'Tiếng Việt' : 'English';

      state = state.copyWith(
        isLoading: false,
        user: user,
        currentLanguage: currentLanguage,
      );
    } catch (e) {
      _handleFailure(context, e);
    }
  }

  /// Refresh manually
  Future<void> onRefresh(BuildContext context) async {
    await fetchData(context, showLoading: false);
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

  /// My Account
  void onTapMyAccount(BuildContext context) {
    context.go(AppRoutes.changeprofile);
  }

  /// Security
  void onTapSecurity(BuildContext context) {
    context.go(AppRoutes.changepassword);
  }

  /// Language
  void onTapLanguage(BuildContext context) {
    context.go(AppRoutes.selectlanguage);
  }

  /// Help & Support
  void onTapHelpSupport(BuildContext context) {
    /// Implement logic later
  }

  void _clearUser() {
    state = const ProfileState(user: null);
  }

  void setUser(User user) {
    state = state.copyWith(user: user);
  }

  /// Logout
  void onTapLogout(BuildContext context) {
    final router = GoRouter.of(context);

    showDialog(
      context: context,
      builder: (context) => ConfirmDialog(
        title: 'logout_dialog.title'.tr(),
        message: 'logout_dialog.message'.tr(),
        confirmText: 'logout_dialog.confirm'.tr(),
        cancelText: 'logout_dialog.cancel'.tr(),
        confirmColor: AppColors.typoError.withOpacity(0.5),
        icon: HeroIcons.exclamationCircle,
        iconColor: AppColors.typoError.withOpacity(0.5),
        onCancel: () {
          context.pop();
        },
        onConfirm: () async {
          await ref.read(authProvider.notifier).logout();
          _clearUser();

          router.go(AppRoutes.login);
        },
      ),
    );
  }
}
