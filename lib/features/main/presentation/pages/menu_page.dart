import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'models/category.dart';
import 'models/product.dart';


class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: ElevatedButton(onPressed: ()async{
          final SupabaseClient _supabase = Supabase.instance.client;
          PostgrestList categoriesResponse = await _supabase.from('categories')
              .select('*')
              .eq('is_active', true)
              .order('sort_order');
          final categories = (categoriesResponse as List)
              .map((json) => Category.fromJson(json))
              .toList();
          // Получаем все активные продукты с категориями и вариантами
          final productsResponse = await _supabase
              .from('products')
              .select('''
            *,
            categories!inner(name)
            
          ''')
              .eq('is_available', true)
              .order('sort_order');

          final products = (productsResponse as List)
              .map((json) => Product.fromJson(json))
              .toList();
          products.map((product){
            print(product.name);
          }).toList();

        },
            child: Text('получить меню')),
      ),
    );
  }
}
