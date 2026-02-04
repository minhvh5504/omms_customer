import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/menu_category.dart';
import '../../domain/entities/menu_item.dart';
import '../../domain/usecases/get_menu_categories.dart';
import '../../domain/usecases/get_menu_items.dart';

class MenuState {
  final List<MenuCategory> categories;
  final List<MenuItem> items;
  final int selectedCategoryIndex;
  final bool isLoading;
  final String? errorMessage;

  const MenuState({
    this.categories = const [],
    this.items = const [],
    this.selectedCategoryIndex = 0,
    this.isLoading = false,
    this.errorMessage,
  });

  MenuState copyWith({
    List<MenuCategory>? categories,
    List<MenuItem>? items,
    int? selectedCategoryIndex,
    bool? isLoading,
    String? errorMessage,
  }) {
    return MenuState(
      categories: categories ?? this.categories,
      items: items ?? this.items,
      selectedCategoryIndex:
          selectedCategoryIndex ?? this.selectedCategoryIndex,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class MenuNotifier extends StateNotifier<MenuState> {
  final GetMenuCategories _getMenuCategories;
  final GetMenuItems _getMenuItems;

  MenuNotifier(this._getMenuCategories, this._getMenuItems)
    : super(const MenuState()) {
    init();
  }

  /// Initialize the menu with categories and the first category's items
  Future<void> init() async {
    state = state.copyWith(isLoading: true);
    try {
      final categories = await _getMenuCategories();
      state = state.copyWith(categories: categories);

      if (categories.isNotEmpty) {
        await _fetchItems(categories[0].id);
      }
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  /// Fetch items for a specific category
  Future<void> _fetchItems(String categoryId) async {
    try {
      final items = await _getMenuItems(categoryId);
      state = state.copyWith(items: items);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  /// Select a category and fetch its items
  Future<void> selectCategory(int index) async {
    if (index < 0 || index >= state.categories.length) return;
    if (index == state.selectedCategoryIndex) return;

    state = state.copyWith(selectedCategoryIndex: index, isLoading: true);

    final categoryId = state.categories[index].id;
    await _fetchItems(categoryId);

    state = state.copyWith(isLoading: false);
  }

  Future<void> handleAddToCart(MenuItem item) async {}
}
