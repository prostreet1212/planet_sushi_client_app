import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planet_sushi_client_app/features/shop/presentation/pages/menu_page/widgets/catalog_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:planet_sushi_client_app/injection_container.dart' as di;

import '../../../models/category.dart';
import '../../cubits/catalog_cubit/catalog_cubit.dart';
import '../../cubits/catalog_cubit/catalog_state.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}



class _MenuPageState extends State<MenuPage> {

  //late Future<List<Category>> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    //_categoriesFuture = getCategoriesWithProducts();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Строитель менюпэйдж');
    return Padding(
        padding: EdgeInsetsGeometry.all(8),
        child: BlocConsumer<CatalogCubit,CatalogState>(
          listener: (context,catalogState){
          },
          builder: (context,catalogState){
            if(catalogState is CatalogLoading) {
              return Center(child: CircularProgressIndicator(),);
            }
            if(catalogState is CatalogError) {
              return Center(child: Text(catalogState.message),);
            }
            if(catalogState is CatalogEmpty) {
              return Center(child: Text('Каталог пуст'),);
            }
            if(catalogState is CatalogSuccess) {
              return CatalogWidget(categoryList: catalogState.categoryList);
            } else {
              return SizedBox();
            }
          },),
        /*child: FutureBuilder<List<Category>>(
                future: _categoriesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return Center(child: CircularProgressIndicator(),);
                  } else {
                    final categories = snapshot.data ?? [];
                    return ListView.builder(
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(category.name),
                              ...category.products.map((product) {
                                return Card(
                                  child: Column(
                                    children: [
                                      Text(product.name),
                                    ],
                                  ),
                                );
                              })
                            ],
                          );
                        });
                  }
                }),*/
      )
    ;
  }
}
