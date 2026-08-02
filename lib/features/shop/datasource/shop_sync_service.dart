// shop_sync_service.dart

import 'package:dartz/dartz.dart';
import 'package:planet_sushi_client_app/features/shop/datasource/shop_local_data_source.dart';

import '../models/category.dart';
import 'shop_remote_data_source.dart';

class ShopSyncService {
  final ShopRemoteDataSource _remoteDataSource;
  final ShopLocalDataSource _localDao;

  ShopSyncService({
    required ShopRemoteDataSource remoteDataSource,
    required ShopLocalDataSource localDao,
  }) : _remoteDataSource = remoteDataSource,
       _localDao = localDao;

  /// Стратегия: сначала локальные данные, потом фоновая синхронизация
  /* Future<Either<String, List<Category>>> getCatalog() async {
   // 1. Пробуем достать из локальной БД
    final hasLocal = await _localDao.hasCachedData();
    if (hasLocal) {
      final localData = await _localDao.getCategoriesWithProducts();
      // 2. В фоне обновляем из Supabase
      _syncFromRemote();
      return Right(localData);
    }

    // 3. Если локально пусто — грузим из сети
    final remote = await _remoteDataSource.getCategoriesWithProducts();
    return remote.fold(
          (error) => Left(error),
          (data) {
        // Сохраняем локально
        _localDao.saveCategoriesWithProducts(data);
        return Right(data);
      },
    );
  }

  Future<void> _syncFromRemote() async {
    final remote = await _remoteDataSource.getCategoriesWithProducts();
    remote.fold(
          (_) {}, // игнорируем ошибку фоновой синхронизации
          (data){
            _localDao.saveCategoriesWithProducts(data);
          }
    );
  }*/

  /// Только локальные данные (быстро)
  Future<Either<String, List<Category>>> getLocalCatalog() async {
    final hasLocal = await _localDao.hasCachedData();
    if (hasLocal) {
      final localData = await _localDao.getCategoriesWithProducts();
      return Right(localData);
    }
    return Right([]);
  }

  /// Синхронизация с Supabase → сохранение локально → возврат свежих данных
  Future<Either<String, List<Category>>> syncFromRemote() async {
    final remote = await _remoteDataSource.getCategoriesWithProducts();
    return remote.fold((error) => Left(error), (data) async {
      await _localDao.saveCategoriesWithProducts(data);
      return Right(data);
    });
  }
}
