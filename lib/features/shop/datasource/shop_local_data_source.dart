// shop_local_data_source.dart

import 'package:drift/drift.dart';

import '../models/category.dart';
import '../models/product.dart';
import '../../database/database.dart';

class ShopLocalDataSource {
  final AppDatabase _db;

  ShopLocalDataSource(this._db);

  // Получить все категории с товарами
  Future<List<Category>> getCategoriesWithProducts() async {
    final categories = await _db.select(_db.categories).get();
    final result = <Category>[];

    for (final cat in categories) {
      final products = await (_db.select(_db.products)
        ..where((p) => p.categoryId.equals(cat.id))
        ..where((p) => p.isAvailable.equals(true))
      ).get();

      result.add(Category(
        id: cat.id,
        name: cat.name,
        imageUrl: cat.imageUrl,
        products: products.map((p) => Product(
          id: p.id,
          name: p.name,
          description: p.description,
          price: p.price,
          imageUrl: p.imageUrl,
          weight: p.weight,
          isAvailable: p.isAvailable,
        )).toList(),
      ));
    }

    return result;
  }

  // Сохранить категории с товарами (транзакция)
  Future<void> saveCategoriesWithProducts(List<Category> categories) async {
    await _db.transaction(() async {
      // Очищаем старые данные
      await _db.delete(_db.categories).go();
      await _db.delete(_db.products).go();

      // Вставляем новые
      for (final cat in categories) {
        await _db.into(_db.categories).insert(CategoriesCompanion.insert(
          id: cat.id,
          name: cat.name,
          imageUrl: Value(cat.imageUrl),
          sortOrder: 0,
        ));

        for (final prod in cat.products) {
          await _db.into(_db.products).insert(ProductsCompanion.insert(
            id: prod.id,
            name: prod.name,
            description: Value(prod.description),
            price: prod.price,
            imageUrl: Value(prod.imageUrl),
            weight: Value(prod.weight),
            isAvailable: prod.isAvailable,
            categoryId: cat.id,
          ));
        }
      }
    });
  }


  // Проверить, есть ли данные локально
  Future<bool> hasCachedData() async {
    final count = await _db.select(_db.categories).get();
    return count.isNotEmpty;
  }
}