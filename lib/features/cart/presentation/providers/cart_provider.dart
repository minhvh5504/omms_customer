import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/cart_remote_datasource.dart';
import '../../data/repositories/cart_repository_impl.dart';
import '../../domain/repositories/cart_repository.dart';
import '../../domain/usecases/get_cart_items.dart';
import 'cart_notifier.dart';

// DataSource
final cartRemoteDataSourceProvider = Provider<CartRemoteDataSource>((ref) {
  return CartRemoteDataSourceImpl();
});

// Repository
final cartRepositoryProvider = Provider<CartRepository>((ref) {
  return CartRepositoryImpl(ref.read(cartRemoteDataSourceProvider));
});

// UseCase
final getCartItemsProvider = Provider<GetCartItems>((ref) {
  return GetCartItems(ref.read(cartRepositoryProvider));
});

// Notifier
final cartNotifierProvider = StateNotifierProvider<CartNotifier, CartState>((
  ref,
) {
  return CartNotifier(
    ref.read(getCartItemsProvider),
    ref.read(cartRepositoryProvider),
  );
});
