import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planet_sushi_client_app/features/cart/datasource/cart_local_data_source.dart';
import 'package:planet_sushi_client_app/features/cart/presentation/cubits/cart_state.dart';

import '../../../../../core/routers/app_router.dart';
import '../../../../../injection_container.dart';
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
                  ? context.read<CartCubit>().totalPrice/*state.items.fold<double>(
                      0,
                      (sum, item) => sum + item.totalPrice,
                    )*/
                  : 0;
            },
            builder: (context, totalPrice) {
              return ElevatedButton(
                child: Text(
                  /*'Оформить'*/
                  'Сделать заказ • ${ /*context.read<CartCubit>().*/ totalPrice.toStringAsFixed(0)} ₽',
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
                  context.router.push(const OrderRoute());
                 sl<CartLocalDataSource>().clear();
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
