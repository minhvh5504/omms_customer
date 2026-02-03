import '../../domain/entities/menu_category.dart';
import '../../domain/entities/menu_item.dart';

abstract class MenuRemoteDataSource {
  Future<List<MenuCategory>> getCategories();
  Future<List<MenuItem>> getMenuItems(String categoryId);
}

class MenuRemoteDataSourceImpl implements MenuRemoteDataSource {
  // Fake data can be here or fetched from a mock API call
  @override
  Future<List<MenuCategory>> getCategories() async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    ); // Simulate network delay
    return [
      MenuCategory(id: '1', name: 'Maincourse'),
      MenuCategory(id: '2', name: 'Soup'),
      MenuCategory(id: '3', name: 'Salad'),
      MenuCategory(id: '4', name: 'Entry'),
      MenuCategory(id: '5', name: 'Dessert'),
      MenuCategory(id: '6', name: 'Drink'),
    ];
  }

  @override
  Future<List<MenuItem>> getMenuItems(String categoryId) async {
    await Future.delayed(
      const Duration(milliseconds: 800),
    ); // Simulate network delay

    // In a real app, query by categoryId. Here we return the same list or variations.
    return [
      MenuItem(
        id: '1',
        name: 'Pan-Fried Chicken Breast',
        description: 'Domates, zeytin, pepperoni, bibar ve mısır',
        price: '405,000 VND',
        imageUrl:
            'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      ),
      MenuItem(
        id: '2',
        name: 'Black Wagyu Rib Eye',
        description: 'Domates, zeytin, pepperoni, bibar ve mısır',
        price: '405,000 VND',
        imageUrl:
            'https://images.unsplash.com/photo-1546964124-0cce460f38ef?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      ),
      MenuItem(
        id: '3',
        name: 'Black Wagyu Striploin',
        description: 'Domates, zeytin, pepperoni, bibar ve mısır',
        price: '405,000 VND',
        imageUrl:
            'https://images.unsplash.com/photo-1544025162-d76690b6d01d?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      ),
      MenuItem(
        id: '4',
        name: 'Crispy Skin Seabass',
        description: 'Domates, zeytin, pepperoni, bibar ve mısır',
        price: '405,000 VND',
        imageUrl:
            'https://images.unsplash.com/photo-1599084993091-1e8b0289b3c2?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      ),
      MenuItem(
        id: '5',
        name: 'Chicken Laksa',
        description: 'Domates, zeytin, pepperoni, bibar ve mısır',
        price: '405,000 VND',
        imageUrl:
            'https://images.unsplash.com/photo-1628294895950-98052523e036?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      ),
    ];
  }
}
