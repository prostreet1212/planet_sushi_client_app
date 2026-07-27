

import 'package:dartz/dartz.dart';


import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/category.dart';


class ShopDataSource {
  final Supabase supabase;

  ShopDataSource({required this.supabase});

  // Получаем категории вместе с их товарами одним запросом
  Future<Either<String,List<Category>>> getCategoriesWithProducts() async {
    try {
      final response = await supabase.client
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

      if (response.isEmpty) return Right([]);
      List<Category> categotyList=response.map((json) {
        Category category=Category.fromJson(json);
        return category;
      }).toList();

      return Right(categotyList);
    } catch (e) {
      String error='Ошибка загрузки меню: $e';
      print(error);
      return Left(error);
    }
  }


}