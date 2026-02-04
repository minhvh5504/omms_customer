import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../data/api/menu_api.dart';
import '../../data/datasources/menu_remote_datasource.dart';
import '../../data/repositories/menu_repository_impl.dart';
import '../../domain/repositories/menu_repository.dart';
import '../../domain/usecases/get_menu_categories.dart';
import '../../domain/usecases/get_menu_items.dart';
import 'menu_notifier.dart';

// API
final menuApiProvider = Provider<MenuApi>((ref) {
  return ApiClient(ref).create(MenuApi.new);
});

// DataSource
final menuRemoteDataSourceProvider = Provider<MenuRemoteDataSource>((ref) {
  return MenuRemoteDataSourceImpl(ref.read(menuApiProvider));
});

// Repository
final menuRepositoryProvider = Provider<MenuRepository>((ref) {
  return MenuRepositoryImpl(ref.read(menuRemoteDataSourceProvider));
});

// UseCases
final getMenuCategoriesProvider = Provider<GetMenuCategories>((ref) {
  return GetMenuCategories(ref.read(menuRepositoryProvider));
});

final getMenuItemsProvider = Provider<GetMenuItems>((ref) {
  return GetMenuItems(ref.read(menuRepositoryProvider));
});

// Notifier
final menuNotifierProvider = StateNotifierProvider<MenuNotifier, MenuState>((
  ref,
) {
  return MenuNotifier(
    ref.read(getMenuCategoriesProvider),
    ref.read(getMenuItemsProvider),
  );
});
