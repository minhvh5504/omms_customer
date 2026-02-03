import '../entities/menu_item.dart';
import '../repositories/menu_repository.dart';

class GetMenuItems {
  final MenuRepository repository;

  GetMenuItems(this.repository);

  Future<List<MenuItem>> call(String categoryId) {
    return repository.getMenuItems(categoryId);
  }
}
