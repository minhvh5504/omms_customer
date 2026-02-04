import '../api/menu_api.dart';
import '../models/menu_category_model.dart';
import '../models/menu_item_model.dart';
import '../../domain/entities/menu_category.dart';
import '../../domain/entities/menu_item.dart';

abstract class MenuRemoteDataSource {
  Future<List<MenuCategory>> getCategories();
  Future<List<MenuItem>> getMenuItems(String categoryId);
}

class MenuRemoteDataSourceImpl implements MenuRemoteDataSource {
  final MenuApi _api;

  MenuRemoteDataSourceImpl(this._api);

  @override
  Future<List<MenuCategory>> getCategories() async {
    final response = await _api.getCategories();
    final List<dynamic> data = response['data'] ?? [];
    return MenuCategoryModel.fromJsonList(data);
  }

  @override
  Future<List<MenuItem>> getMenuItems(String categoryId) async {
    final response = await _api.getDishes({'categoryId': categoryId});
    final List<dynamic> data = response['data'] ?? [];
    return MenuItemModel.fromJsonList(data);
  }
}
