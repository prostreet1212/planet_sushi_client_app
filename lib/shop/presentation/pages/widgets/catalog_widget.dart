
import 'package:flutter/material.dart';
import 'package:planet_sushi_client_app/shop/models/product.dart';

import '../../../models/category.dart';


class CatalogWidget extends StatelessWidget {
  final List<Category> categoryList;
  const CatalogWidget({super.key, required this.categoryList});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: categoryList.length,
        itemBuilder: (context,index){
        Category category=categoryList[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(categoryList[index].name,style: TextStyle(fontSize: 24),),
            SizedBox(height: 12,),
            SizedBox(
              //height: (category.products.length ~/ 2 + (category.products.length % 2 > 0 ? 1 : 0)) * 180,
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    mainAxisExtent: 300,
                  ),
                  itemCount: categoryList[index].products.length,
                  itemBuilder: (context,productIndex){
                    Product product=category.products[productIndex];
                    return                          // Image.network('https://pyihjwclvypcaeifmbcu.supabase.co/storage/v1/object/public/sushi_planet/products/o-YD4UFABsQfEpVo9Rymou3wjrZIiWdhgZkWywEEv7seJGlC9SHmJaSb5qslv7p7iDUaXrSoNUakS_Dml5UP4yHs.jpg');

                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                       crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                            child: Image.network(
                              product.imageUrl??'',
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(Icons.image, size: 60),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    product.name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Text(product.weight!=null?product.weight.toString():'0')
                              ],
                            )
                          ),
                          //const SizedBox(height: 8),
                        ],
                      ),
                    );
                  }),
            ),
            SizedBox(height: 20,),


          ],
        );
        });
  }
}
