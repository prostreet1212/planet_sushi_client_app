// screens/cart_body.dart
/*import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class CartListView extends StatelessWidget {
  const CartListView({super.key, required this.cartList});

  final List<CartItem> cartList;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final profile = context.read<ProfileCubit>().state;
        final cubit = CheckoutCubit();
        if (profile is ProfileLoaded) {
          cubit.setName(profile.user.name ?? '');
          cubit.setPhone(profile.user.phone ?? '');
        }
        return cubit;
      },
      child: _CartListBody(cartList: cartList),
    );
  }
}

class _CartListBody extends StatelessWidget {
  const _CartListBody({required this.cartList});

  final List<CartItem> cartList;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.only(bottom: 8),
                sliver: SliverList.builder(
                  itemCount: cartList.length,
                  itemBuilder: (context, index) =>
                      CartCard(cart: cartList[index]),
                ),
              ),
              const SliverToBoxAdapter(child: CheckoutForm()),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
        OrderButton(), // отдельный, не Positioned
      ],
    );
  }
}*/