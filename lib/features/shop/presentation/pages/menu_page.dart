import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planet_sushi_client_app/features/shop/presentation/pages/widgets/catalog_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:planet_sushi_client_app/injection_container.dart' as di;

import '../../models/category.dart';
import '../cubits/catalog_cubit/catalog_cubit.dart';
import '../cubits/catalog_cubit/catalog_state.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

// Получаем категории вместе с их товарами одним запросом
Future<List<Category>> getCategoriesWithProducts() async {
  try {
    final response = await Supabase.instance.client
        .from('categories')
        .select('''
            id,
            name,
            image_url,
            products!inner (
              id,
              name,
              description,
              price,
              image_url,
              weight,
              is_available
            )
          ''')
        .order('sort_order', ascending: true) // Сортировка категорий
        .order(
      'name',
      ascending: true,
      referencedTable: 'products',
    ); // Сортировка товаров внутри

    if (response.isEmpty) return [];

    return response.map((json) {
      Category category = Category.fromJson(json);
      return category;
    }).toList();
  } catch (e) {
    print('Ошибка загрузки меню: $e');
    rethrow;
  }
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
    return  BlocProvider<CatalogCubit>(
        create: (context) => di.sl<CatalogCubit>()..getCatalog(),
        child: SafeArea(
          child: Padding(
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
          ),
        ),
      )
    ;
  }
}
