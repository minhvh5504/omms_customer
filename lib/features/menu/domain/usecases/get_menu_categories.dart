import '../entities/menu_category.dart';
import '../repositories/menu_repository.dart';

class GetMenuCategories {
  final MenuRepository repository;

  GetMenuCategories(this.repository);

  Future<List<MenuCategory>> call() {
    return repository.getCategories();
  }
}
