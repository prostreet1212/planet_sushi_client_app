import 'package:cached_network_image/cached_network_image.dart';
import 'package:customizable_counter/customizable_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planet_sushi_client_app/features/cart/datasource/cart_local_data_source.dart';
import 'package:planet_sushi_client_app/features/cart/presentation/cubits/cart_cubit.dart';
import 'package:planet_sushi_client_app/features/cart/presentation/cubits/cart_state.dart';
import 'package:planet_sushi_client_app/features/cart/presentation/pages/widgets/cart_counter.dart';
import 'package:planet_sushi_client_app/injection_container.dart' as di;

import '../../models/cart_item.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<CartCubit, CartState>(
        builder: (context, cartState) {
          if (cartState is CartEmpty) {
            return Center(child: Text('Корзина пуста'));
          } else if (cartState is CartLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (cartState is CartLoaded) {
            List<CartItem> cartList = cartState.items;
            return ListView.builder(
              itemCount: cartList.length,
              itemBuilder: (context, index) {
                var cart = cartList[index];
                return SizedBox(
                  height: 150,
                  child: Card(
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(5),
                          ),

                          child: CachedNetworkImage(
                            imageUrl: cartList[index].product!.imageUrl ?? '',
                            //width: double.infinity,
                            //fit:BoxFit.fitWidth,
                            placeholderFadeInDuration: Duration(
                              milliseconds: 0,
                            ),
                            fadeInDuration: Duration(milliseconds: 0),
                            fadeOutDuration: Duration(milliseconds: 0),
                            errorWidget: (context, url, error) => Container(
                              width: 100,
                              height: 100,
                              color: Colors.grey[200],
                              child: const Icon(
                                Icons.broken_image,
                                color: Colors.grey,
                              ),
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
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: Text(
                                    cartList[index].product!.name,
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
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    CartCounter(
                                      counter: cart.quantity,
                                      onCounterChange: (newCounter) {
                                        di
                                            .sl<CartLocalDataSource>()
                                            .updateCartItem(
                                              cartList[index],
                                              newCounter,
                                            );
                                      },
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        di.sl<CartLocalDataSource>().deleteCartItem(cart);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        minimumSize: Size.zero,
                                          //tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        fixedSize: Size(40, 48),
                                        iconColor: Colors.black,
                                        elevation: 0,
                                        padding: EdgeInsets.all(0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8.0), // Скругление углов (по желанию)
                                          side: const BorderSide(color: Colors.blue, width: 2.0), // Цвет и толщина рамки
                                        ),
                                      ),
                                      child: Icon(Icons.delete_forever_outlined)
                                    )
                                  ],
                                ),

                                // CustomizableCounter(
                                //   borderColor: Colors.black,
                                //   borderWidth: 1,
                                //   borderRadius: 100,
                                //   //backgroundColor: Colors.amberAccent,
                                //   showButtonText: false,
                                //   //buttonText: "Add Item",
                                //   textColor: Colors.black,
                                //   textSize: 22,
                                //
                                //   count: 0,
                                //   step: 1,
                                //   minCount: 0,
                                //   maxCount: 10,
                                //   incrementIcon: const Icon(
                                //       Icons.add,
                                //       color: Colors.black,
                                //     ),
                                //
                                //   decrementIcon: const Icon(
                                //     Icons.remove,
                                //     color: Colors.black,
                                //   ),
                                //   onCountChange: (count) {},
                                //   onIncrement: (count) {
                                //
                                //   },
                                //   onDecrement: (count) {},
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
