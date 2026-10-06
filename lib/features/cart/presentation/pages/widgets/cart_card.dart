import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planet_sushi_client_app/features/cart/models/cart_item.dart';

import '../../cubits/cart_cubit.dart';
import '../../cubits/cart_state.dart';
import 'cart_counter.dart';

class CartCard extends StatelessWidget {
  const CartCard({super.key, required this.cart});

  final CartItem cart;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Card(
        // color: Colors.red,
        child: Row(
          //mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.zero,
                  bottomRight: Radius.zero,
                  bottomLeft: Radius.circular(4),
                ),

                color: Colors.grey.withValues(alpha: 0.3),
                // color: Colors.yellow
              ),
              height: double.infinity,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.zero,
                  bottomRight: Radius.zero,
                  bottomLeft: Radius.circular(4),
                ),

                child: CachedNetworkImage(
                  imageUrl: cart.product!.imageUrl ?? '',
                  width: 106.5,
                  //fit:BoxFit.fitWidth,
                  placeholderFadeInDuration: Duration(milliseconds: 0),
                  fadeInDuration: Duration(milliseconds: 0),
                  fadeOutDuration: Duration(milliseconds: 0),
                  errorWidget: (context, url, error) => Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey[200],
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  ),
                ),
                /*Image.network(
                                  product.imageUrl ?? '',
                                  width: double.infinity,
                                  // height:double.infinity,
                                  fit: BoxFit.fitWidth, //contain
                                  //alignment: Alignment.topCenter,
                                  errorBuilder: (_, __, ___) =>
                                      const Icon(Icons.image, size: 60),
                                ),*/
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  //mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        cart.product!.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'RobotoCondensed',
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CartCounter(
                          counter: cart.quantity,
                          onCounterChange: (newCounter) {
                            context.read<CartCubit>().updateCartQuantity(
                              cart,
                              newCounter,
                            );
                          },
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await context.read<CartCubit>().deleteCart(cart);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            minimumSize: Size.zero,
                            //tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            fixedSize: Size(32, 40),
                            iconColor: Colors.black,
                            elevation: 0,
                            overlayColor: Colors.grey[800],
                            padding: EdgeInsets.all(0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              // Скругление углов (по желанию)
                              side: const BorderSide(
                                color: Colors.blue,
                                width: 2.0,
                              ), // Цвет и толщина рамки
                            ),
                          ),

                          child: Icon(Icons.delete_forever_outlined, size: 26),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 104,
                          child: Center(
                            child: BlocSelector<CartCubit, CartState, double>(
                              selector: (state) {
                                if (state is! CartLoaded) return cart.totalPrice;
                                final item = state.items.firstWhere(
                                      (i) => i.id == cart.id,
                                  orElse: () => cart,
                                );
                                return item.totalPrice;
                              },
                              builder: (context, price) {
                                return Text(
                                  '${/*cart.totalPrice*/price.toString()} ₽',
                                  style: TextStyle(fontSize: 18),
                                );
                              },
                            ),
                          ),
                        ),
                        BlocSelector<CartCubit, CartState, int>(
                          selector: (state) {
                            if (state is! CartLoaded) return cart.totalWeight;
                            final item = state.items.firstWhere(
                                  (i) => i.id == cart.id,
                              orElse: () => cart,
                            );
                            return item.totalWeight;
                          },
                          builder: (context, weight) {
                            return   Text(
                          cart.product!.weight != null
                              ? '${weight} гр.'
                              : '',
                          style: TextStyle(fontSize: 16),
                        );
                          },
                        ),

                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
