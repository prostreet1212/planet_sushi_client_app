import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planet_sushi_client_app/features/cart/datasource/cart_local_data_source.dart';
import 'package:planet_sushi_client_app/features/cart/presentation/cubits/cart_cubit.dart';
import 'package:planet_sushi_client_app/features/cart/presentation/cubits/cart_state.dart';
import 'package:planet_sushi_client_app/features/cart/presentation/pages/widgets/cart_counter.dart';
import 'package:planet_sushi_client_app/features/cart/presentation/pages/widgets/cart_list_view.dart';
import 'package:planet_sushi_client_app/injection_container.dart' as di;

import '../../models/cart_item.dart';

@RoutePage()
class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    debugPrint('Строитель картпэйдж');
    return Container(
      //color: Colors.yellow,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<CartCubit, CartState>(
          buildWhen: (prev,next){
            //не перестравивать когда меняется только кол-во в карточке (у виджета cart_counter свой перестроитель)
            if((prev is CartLoaded)&&( prev.items.length==(next as CartLoaded).items.length)){
              return false;
            }else{
              return true;
            }

          },
          builder: (context, cartState) {
            if (cartState is CartEmpty) {
              return Center(child: Text('Корзина пуста'));
            } else if (cartState is CartLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (cartState is CartLoaded) {
              List<CartItem> cartList = cartState.items;
              return CartListView(cartList: cartList);
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
