import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planet_sushi_client_app/features/cart/datasource/cart_local_data_source.dart';
import 'package:planet_sushi_client_app/features/cart/presentation/cubits/cart_state.dart';
import 'package:planet_sushi_client_app/features/profile/presentation/cubits/profile_cubit/profile_state.dart';

import '../../../../../core/routers/app_router.dart';
import '../../../../../core/utils/utils.dart';
import '../../../../../injection_container.dart';
import '../../../../order/presentation/cubits/chekout_cubit/chekout_cubit.dart';
import '../../../../profile/presentation/cubits/profile_cubit/profile_cubit.dart';
import '../../../models/cart_item.dart';
import '../../cubits/cart_cubit.dart';

class OrderButton extends StatelessWidget {
  const OrderButton({super.key});

  //final double totalPrice;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 85,
      left: 0,
      right: 0,
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: BlocSelector<CartCubit, CartState, double>(
            selector: (state) {
              return state is CartLoaded
                  ? context
                        .read<CartCubit>()
                        .totalPrice /*state.items.fold<double>(
                      0,
                      (sum, item) => sum + item.totalPrice,
                    )*/
                  : 0;
            },
            builder: (context, totalPrice) {
              return ElevatedButton(
                child: Text(
                  /*'Оформить'*/
                  'Сделать заказ • ${Utils.formatPrice(totalPrice)} ₽',
                  style: TextStyle(fontSize: 20, fontFamily: 'RobotoCondensed'),
                ),
                style: ElevatedButton.styleFrom(
                  //fixedSize: Size(double.infinity, 40),
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: Color(0xff07aa55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                onPressed: () {
                  _submit(context, totalPrice);
                  /*const snackBar = SnackBar(content: Text('Yay! A SnackBar!'),behavior: SnackBarBehavior.floating);
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);*/
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

Future<void> _submit(BuildContext context, double totalPrice) async {
  final cartState = context.read<CartCubit>().state;
  if (cartState is! CartLoaded || cartState.items.isEmpty) return;

  final profileState = context.read<ProfileCubit>().state;
  if (profileState is! ProfileSuccess) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Профиль не загружен')));
    return;
  }

  final items = cartState.items
      .map(
        (item) => {
          'product_id': item.product?.id,
          'name': item.product?.name,
          'price': item.product?.price,
          'quantity': item.quantity,
          'total_price': item.totalPrice,
          'total_weight': item.totalWeight,
        },
      )
      .toList();

  final ok = await context.read<CheckoutCubit>().submitOrder(
    userId: profileState.user.id!,
    items: items,
    totalPrice: totalPrice,
  );

  if (!context.mounted) return;

  if (ok) {
    // очистить корзину
    for (final item in List<CartItem>.from(cartState.items)) {
      await context.read<CartCubit>().deleteCart(item);
    }
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Заказ оформлен!')));
    context.router.pop();
  } else {
    final err = context.read<CheckoutCubit>().state.error ?? 'Ошибка';
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
  }
}
