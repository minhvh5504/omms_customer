import '../entities/menu_category.dart';
import '../entities/menu_item.dart';

abstract class MenuRepository {
  Future<List<MenuCategory>> getCategories();
  Future<List<MenuItem>> getMenuItems(String categoryId);
}
