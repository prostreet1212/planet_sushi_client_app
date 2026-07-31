import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:planet_sushi_client_app/features/shop/models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.red,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        //mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Expanded(
             child: ClipRRect(

               borderRadius: const BorderRadius.vertical(
                 top: Radius.circular(12),
               ),

               child: Image.network(
                 product.imageUrl ?? '',
                 width:double.infinity,
                // height:double.infinity,
                 fit: BoxFit.fitWidth, //contain
                 //alignment: Alignment.topCenter,
                 errorBuilder: (_, __, ___) =>
                 const Icon(Icons.image, size: 60),
               ),
             ),
           ),

            /* Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: Image.network(
                    product.imageUrl ?? '',
                    width: double.infinity,
                    fit: BoxFit.fitWidth, //contain
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.image, size: 60),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: SizedBox(
                    width: 36,
                    height: 36,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: добавить/удалить из избранного
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.white.withValues(alpha: 0.9),
                        elevation: 2,
                      ),
                      child: const Icon(
                        Icons.favorite_border,
                        size: 18,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ],
            ),*/


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
    );
  }
}
