import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/repositories/cart_repository.dart';
import '../../domain/usecases/get_cart_items.dart';

class CartState {
  final List<CartItem> items;
  final bool isLoading;
  final String? errorMessage;
  final double total;

  const CartState({
    this.items = const [],
    this.isLoading = false,
    this.errorMessage,
    this.total = 0,
  });

  CartState copyWith({
    List<CartItem>? items,
    bool? isLoading,
    String? errorMessage,
    double? total,
  }) {
    return CartState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      total: total ?? this.total,
    );
  }
}

class CartNotifier extends StateNotifier<CartState> {
  final GetCartItems _getCartItems;
  final CartRepository _cartRepository;

  CartNotifier(this._getCartItems, this._cartRepository)
    : super(const CartState()) {
    init();
  }

  String formatTotal(double value) {
    final formatter = NumberFormat('#,###', 'vi_VN');
    return '${formatter.format(value)} VND';
  }

  Future<void> init() async {
    state = state.copyWith(isLoading: true);
    try {
      final items = await _getCartItems();
      final total = _getTotal(items);
      state = state.copyWith(items: items, isLoading: false, total: total);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> updateQuantity(String itemId, int newQuantity) async {
    if (newQuantity < 1) return;

    final updatedItems = state.items.map((item) {
      if (item.id == itemId) {
        return item.copyWith(quantity: newQuantity);
      }
      return item;
    }).toList();

    // Optimistic update
    state = state.copyWith(items: updatedItems, total: _getTotal(updatedItems));

    try {
      await _cartRepository.updateQuantity(itemId, newQuantity);
    } catch (e) {
      // Revert if failed (simplified)
      init();
    }
  }

  Future<void> removeItem(String itemId) async {
    final updatedItems = state.items
        .where((item) => item.id != itemId)
        .toList();

    state = state.copyWith(items: updatedItems, total: _getTotal(updatedItems));

    try {
      await _cartRepository.removeItem(itemId);
    } catch (e) {
      init();
    }
  }

  double _getTotal(List<CartItem> items) {
    double total = 0;
    for (var item in items) {
      total += item.price * item.quantity;
    }
    return total;
  }
}
