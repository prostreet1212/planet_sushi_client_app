
// --- Таблица категорий ---
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

@DataClassName('CategoryTable')
class Categories extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn? get imageUrl => text().nullable()();
  IntColumn get sortOrder => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

// --- Таблица товаров ---
@DataClassName('ProductTable')
class Products extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn? get description => text().nullable()();
  RealColumn get price => real()();
  TextColumn? get imageUrl => text().nullable()();
  IntColumn? get weight => integer().nullable()();
  BoolColumn get isAvailable => boolean()();
  TextColumn get categoryId => text().references(Categories, #id)();

  @override
  Set<Column> get primaryKey => {id};
}

// --- Таблица корзины ---
@DataClassName('CartItemTable')
class CartItems extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get productId => text()();
  IntColumn get quantity => integer()();

  @override
  Set<Column> get primaryKey => {id};
}


// --- База данных ---
@DriftDatabase(tables: [Categories, Products,CartItems])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'planet_sushi_db'));

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createAll(); // создаст недостающую таблицу cart_items
      }
    },
  );

}