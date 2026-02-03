import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/card/food_item_card.dart';
import '../../../../../core/widgets/header/header_with_back.dart';
import '../../presentation/providers/cart_provider.dart';
import '../widgets/cart_footer.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(cartNotifierProvider);
    final notifier = ref.read(cartNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: HeaderWithBack(
        title: 'cart.title'.tr(),
        showBack: false,
        showMore: false,
      ),
      body: SafeArea(
        child: state.isLoading && state.items.isEmpty
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.bgPrimary),
              )
            : Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 16.h,
                      ),
                      itemCount: state.items.length,
                      separatorBuilder: (_, __) => Column(
                        children: [
                          SizedBox(height: 16.h),
                          const Divider(color: Color(0xFFF3F4F6), thickness: 1),
                          SizedBox(height: 16.h),
                        ],
                      ),
                      itemBuilder: (context, index) {
                        final item = state.items[index];
                        return FoodItemCard(
                          imageUrl: item.imageUrl,
                          name: item.name,
                          description: item.description,
                          showDelete: true,
                          onDelete: () => notifier.removeItem(item.id),
                          showTime: true,
                          time: item.preparationTime,
                          showQuantityControls: true,
                          quantity: item.quantity,
                          onIncrease: () => notifier.updateQuantity(
                            item.id,
                            item.quantity + 1,
                          ),
                          onDecrease: () => notifier.updateQuantity(
                            item.id,
                            item.quantity - 1,
                          ),
                        );
                      },
                    ),
                  ),

                  // Footer
                  CartFooter(
                    formattedTotal: notifier.formatTotal(state.total),
                    onSendOrder: () {
                      // Handle checkout
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
