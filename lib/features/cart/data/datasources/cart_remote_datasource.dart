import '../../domain/entities/cart_item.dart';

abstract class CartRemoteDataSource {
  Future<List<CartItem>> getCartItems();
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  @override
  Future<List<CartItem>> getCartItems() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      CartItem(
        id: '1',
        name: 'Pan-Fried Chicken Breast',
        description: 'Domates, zeytin, pepperoni, bibar ve mısır',
        price: 405000,
        imageUrl:
            'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        quantity: 1,
        preparationTime: '20-30 min',
      ),
      CartItem(
        id: '2',
        name: 'Marinara Pizza',
        description: 'Domates, zeytin, pepperoni, bibar ve mısır',
        price: 250000,
        imageUrl:
            'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        quantity: 1,
        preparationTime: '10-15 min',
      ),
      CartItem(
        id: '3',
        name: 'Wagyu Beef Burger',
        description: 'Domates, zeytin, pepperoni, bibar ve mısır',
        price: 340000,
        imageUrl:
            'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        quantity: 1,
        preparationTime: '5-10 min',
      ),
    ];
  }
}
