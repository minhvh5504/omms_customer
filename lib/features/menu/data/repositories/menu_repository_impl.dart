import '../../domain/entities/menu_category.dart';
import '../../domain/entities/menu_item.dart';
import '../../domain/repositories/menu_repository.dart';
import '../datasources/menu_remote_datasource.dart';

class MenuRepositoryImpl implements MenuRepository {
  final MenuRemoteDataSource remoteDataSource;

  MenuRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<MenuCategory>> getCategories() {
    return remoteDataSource.getCategories();
  }

  @override
  Future<List<MenuItem>> getMenuItems(String categoryId) {
    return remoteDataSource.getMenuItems(categoryId);
  }
}
