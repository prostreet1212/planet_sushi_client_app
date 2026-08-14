import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planet_sushi_client_app/features/cart/datasource/cart_local_data_source.dart';
import 'package:planet_sushi_client_app/features/cart/datasource/cart_remote_data_source.dart';
import 'package:planet_sushi_client_app/features/cart/models/cart_item.dart';
import 'package:planet_sushi_client_app/features/cart/presentation/cubits/cart_cubit.dart';
import 'package:planet_sushi_client_app/features/cart/presentation/cubits/cart_state.dart';
import 'package:planet_sushi_client_app/features/shop/models/product.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:planet_sushi_client_app/injection_container.dart' as di;

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    //bool isInCart=false;
    return InkWell(
      onTap: () async {
        /*
        if(di.sl<Supabase>().client.auth.currentUser!=null){
          var id=di.sl<Supabase>().client.auth.currentUser?.id;
          print('пользователь авторизован $id');
        }else{
          print('пользователя нетю');
        }*/
        var id = di.sl<Supabase>().client.auth.currentUser?.id;
        //di.sl<CartLocalDataSource>().insertCartItem(id!, product);
        //di.sl<CartRemoteDataSource>().insertCart(id!, product.id);
        await context.read<CartCubit>().insertCart(id!, product);

        // List<CartItem> a=await di.sl<CartLocalDataSource>().getCartItems();
        // a.map((e){
        //   print(e.product!.name);
        // });
      },
      child: Card(
        //color: Colors.red,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          //mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      color: Colors.grey.withValues(alpha: 0.3),
                    ),
                    //color:
                  ),
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),

                    child: CachedNetworkImage(
                      imageUrl: product.imageUrl ?? '',
                      //width: double.infinity,
                      //fit:BoxFit.fitWidth,
                      placeholderFadeInDuration: Duration(milliseconds: 0),
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
                  Positioned(
                    top: -1,
                    right: -1,
                    child: SizedBox(
                      width: 36,
                      height: 36,
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: добавить/удалить из избранного
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                              topLeft: Radius.zero,
                              bottomRight: Radius.zero,
                            ),
                          ),
                          backgroundColor: Colors.white.withValues(alpha: 0.3),
                          //backgroundColor: Colors.yellow,
                          elevation: 0,
                        ),
                        child: BlocBuilder<CartCubit, CartState>(
                          buildWhen: (prev, next) {
                            if (next is CartLoading) return false; // не мигать при загрузке

                            final isInCartNow = next is CartLoaded &&
                                next.items.any((item) => item.productId == product.id);
                            final isInCartWas = prev is CartLoaded &&
                                prev.items.any((item) => item.productId == product.id);

                            return isInCartNow != isInCartWas;
                            /*if (next is! CartLoaded) return false;
                            final isInCartNow = next.items.any(
                              (item) => item.productId == product.id,
                            );
                            final isInCartWas =
                                prev is CartLoaded &&
                                prev.items.any(
                                  (item) => item.productId == product.id,
                                );
                            debugPrint(
                              'isInCartNow ${isInCartNow != isInCartWas}',
                            );
                            return isInCartNow != isInCartWas;*/
                          },

                          builder: (context, cartState) {
                            print('значок ${product.name}');
                            bool isInCart =
                                cartState is CartLoaded &&
                                cartState.items.any(
                                  (item) => item.productId == product.id,
                                );
                            return Icon(
                              isInCart
                                  ? Icons.shopping_cart_rounded
                                  : Icons.shopping_cart_outlined,
                              size: 20,
                              color: Colors.black54,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 79.7,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      //mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Container(
                            /*constraints:  BoxConstraints(
                              minHeight: 38, // Минимальная высота для двух строк
                              maxHeight: 38 // Максимальная высота для двух строк
                              ),*/
                            child: Text(
                              product.name,
                              maxLines: 2,
                              //textScaleFactor: 0.8,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'RobotoCondensed',
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        /*SizedBox(width: 10),
                            Text(
                              product.weight != null
                                  ? '${product.weight.toString()} гр.'
                                  : '',
                            ),*/
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${product.price.toString()}0 ₽',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          product.weight != null
                              ? '${product.weight.toString()} гр.'
                              : '',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            //const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
