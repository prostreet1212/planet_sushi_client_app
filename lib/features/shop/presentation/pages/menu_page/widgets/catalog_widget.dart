import 'package:flutter/material.dart';
import 'package:planet_sushi_client_app/features/shop/presentation/pages/menu_page/widgets/product_card.dart';
import '../../../../models/category.dart';
import '../../../../models/product.dart';

class CatalogWidget extends StatelessWidget {
  final List<Category> categoryList;

  const CatalogWidget({super.key, required this.categoryList});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: categoryList.length,
      itemBuilder: (context, index) {
        Category category = categoryList[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(categoryList[index].name, style: TextStyle(fontSize: 24,fontFamily: 'RobotoCondensed')),
            SizedBox(height: 12),
            SizedBox(
              //height: (category.products.length ~/ 2 + (category.products.length % 2 > 0 ? 1 : 0)) * 180,
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 189.7, // Максимальная ширина элемента
                  //mainAxisExtent: 330,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.58,//0.57

                ),
                /*SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  mainAxisExtent:330,
                ),*/
                itemCount: categoryList[index].products.length,
                itemBuilder: (context, productIndex) {
                  Product product = category.products[productIndex];
                  return ProductCard(product: product);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
