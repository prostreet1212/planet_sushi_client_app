import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planet_sushi_client_app/core/routers/app_router.dart';
import 'package:planet_sushi_client_app/features/cart/models/cart_item.dart';
import 'package:planet_sushi_client_app/features/cart/presentation/pages/widgets/cart_card.dart';
import 'package:planet_sushi_client_app/features/cart/presentation/pages/widgets/cart_counter.dart';
import 'package:planet_sushi_client_app/features/cart/presentation/pages/widgets/order_button.dart';
import 'package:planet_sushi_client_app/features/profile/presentation/cubits/profile_cubit/profile_state.dart';

import '../../../../order/presentation/cubits/chekout_cubit/chekout_cubit.dart';
import '../../../../profile/presentation/cubits/profile_cubit/profile_cubit.dart';
import '../../cubits/cart_cubit.dart';
import '../../../../order/pages/widgets/checkout_form/checkout_form.dart';

class CartBody extends StatelessWidget {
  const CartBody({super.key, required this.cartList});

  final List<CartItem> cartList;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            /* ListView.builder(
            padding: EdgeInsets.only(bottom: 160),
            itemCount: cartList.length,
            itemBuilder: (context, index) {
              CartItem cart = cartList[index];
              return CartCard(cart: cart);
            },
          ),*/
            //корзина списком
            SliverPadding(
              padding: const EdgeInsets.only(bottom: 0),
              sliver: SliverList.builder(
                itemCount: cartList.length,
                itemBuilder: (context, index) =>
                    CartCard(cart: cartList[index]),
              ),
            ),
            const SliverToBoxAdapter(child: CheckoutForm()),
            const SliverToBoxAdapter(child: SizedBox(height: 120)),
          ],
        ),
        OrderButton(),
        /*Positioned(
          bottom: 85,
          left: 0,
          right: 0,
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                child: Text(/*'Оформить'*/'Сделать заказ • ${context.read<CartCubit>().totalPrice.toStringAsFixed(0)} ₽',style: TextStyle(fontSize: 20,fontFamily: 'RobotoCondensed'),),
                style: ElevatedButton.styleFrom(
                  //fixedSize: Size(double.infinity, 40),
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: Color(0xff07aa55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                onPressed: () {
                  context.router.push(const OrderRoute());
                },
              ),
            ),
          ),
        ),*/
      ],
    );
  }
}
