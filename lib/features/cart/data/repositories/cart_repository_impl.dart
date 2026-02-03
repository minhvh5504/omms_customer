import '../../domain/entities/cart_item.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_remote_datasource.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remoteDataSource;
  // In a real app, we might modify a local cache or send updates to backend.
  // Here we just simulate it with checking the list, but since the list is fetched freshly,
  // state management will handle the temporary changes.

  CartRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<CartItem>> getCartItems() {
    return remoteDataSource.getCartItems();
  }

  @override
  Future<void> updateQuantity(String itemId, int quantity) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 200));
  }

  @override
  Future<void> removeItem(String itemId) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 200));
  }
}
