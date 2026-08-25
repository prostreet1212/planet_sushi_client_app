import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:planet_sushi_client_app/core/error/exception.dart';
import 'package:planet_sushi_client_app/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../database/database.dart';
import '../../shop/models/product.dart';

class ProfileLocalDataSource {
  final AppDatabase _db;

  ProfileLocalDataSource({required this._db});

  Future<UserModel?> getProfile() async {
    try {
      List<UsersTable> users = await _db.select(_db.users).get();
      UsersTable userTable = users[0];
      UserModel user = UserModel(
        phone: userTable.phone,
        name: userTable.name,
        id: userTable.id,
        avatarUrl: userTable.avatar_url,
      );
      return user;
    } catch (e) {
      String error = 'Ошибка загрузки профиля: $e';
      print(error);
      throw CacheException(error: error.toString());
    }
  }

  Future<void> insertProfile(UserModel user) async {
    try {
      await _db
          .into(_db.users)
          .insert(
            UsersCompanion.insert(
              id: user.id!,
              phone: user.phone,
              name: user.name,
              avatar_url: Value(user.avatarUrl),
            ),
          );
    }on SqliteException catch (e) {
      throw CacheException(error: e.message);

  } catch (e) {
      print('local db error:$e');
      throw CacheException(error: e.toString());
    }
  }

  Future<void> deleteCProfile(UserModel user) async {
    _db.delete(_db.users)
      ..where((tbl) => tbl.id.equals(user.id!))
      ..go();
  }

  // Проверить, есть ли данные локально
  Future<bool> hasCachedData() async {
    final count = await _db.select(_db.users).get();
    return count.isNotEmpty;
  }

}
