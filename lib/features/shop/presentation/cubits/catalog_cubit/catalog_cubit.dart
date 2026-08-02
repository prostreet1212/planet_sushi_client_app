import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart' as fnd;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planet_sushi_client_app/features/shop/models/category.dart';

import '../../../datasource/shop_sync_service.dart';

import 'catalog_state.dart';

/*class CatalogCubit extends Cubit<CatalogState> {
  final ShopDataSource _shopDataSource;

  CatalogCubit({required this._shopDataSource}) : super(CatalogInit());

  void getCatalog() async {
    emit(CatalogLoading());
    final catalogData = await _shopDataSource.getCategoriesWithProducts();
    catalogData.fold((error) {
      emit(CatalogError(message: error));
    },
            (catalogList) {
      if(catalogList.isEmpty){
        emit((CatalogEmpty()));
      }
      emit(CatalogSuccess(categoryList: catalogList));
            });
  }
}*/

class CatalogCubit extends Cubit<CatalogState> {
  final ShopSyncService _syncService;

  CatalogCubit({required ShopSyncService this._syncService})
      :super(CatalogInit());

  /*void getCatalog() async {
    emit(CatalogLoading());
    final result = await _syncService.getCatalog();
    result.fold(
          (error) => emit(CatalogError(message: error)),
          (catalogList) {
        if (catalogList.isEmpty) {
          emit(CatalogEmpty());
        } else {
          emit(CatalogSuccess(categoryList: catalogList));
        }
      },
    );
  }*/

  void getCatalog() async {
    emit(CatalogLoading());

    // 1. Мгновенно показываем локальные данные
    final localData = await _syncService.getLocalCatalog();
    localData.fold(
          (error) {},
          (catalogList) {
        if (catalogList.isNotEmpty) {
          print('локальный каталог загружен');
          emit(CatalogSuccess(categoryList: catalogList));
        }
      },
    );

    // 2. Синхронизируем с Supabase и обновляем UI
    final remoteData = await _syncService.syncFromRemote();
    remoteData.fold(
          (error) {
        // Если локальных данных не было — показываем ошибку
        if (localData.isRight() && (localData as Right).value.isEmpty) {
          emit(CatalogError(message: error));
        }
      },
          (catalogList) {
        if (catalogList.isEmpty) {
          emit(CatalogEmpty());
        } else {
          //проверить на равенство

          List<Category> localListCategory=(localData as Right).value;
          List<Category> remoteListCategory=(remoteData as Right).value;
         bool isEqual= fnd.listEquals(localListCategory, remoteListCategory);

          if(!isEqual){
            print('серверный каталог загружен');
            emit(CatalogSuccess(categoryList: catalogList));
          }
        }
      },
    );
  }


}
