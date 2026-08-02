
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

// --- База данных ---
@DriftDatabase(tables: [Categories, Products])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'planet_sushi_db'));

  @override
  int get schemaVersion => 1;
}