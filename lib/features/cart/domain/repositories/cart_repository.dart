import '../entities/cart_item.dart';

abstract class CartRepository {
  Future<List<CartItem>> getCartItems();
  Future<void> updateQuantity(String itemId, int quantity);
  Future<void> removeItem(String itemId);
}
