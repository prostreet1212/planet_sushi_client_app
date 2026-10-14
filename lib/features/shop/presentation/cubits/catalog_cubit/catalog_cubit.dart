import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart' as fnd;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planet_sushi_client_app/features/shop/models/category.dart';

import '../../../../../core/error/failure.dart';
import '../../../datasource/shop_repository.dart';

import 'catalog_state.dart';

class CatalogCubit extends Cubit<CatalogState> {
  final ShopRepository _shopRepository;

  CatalogCubit({required ShopRepository this._shopRepository})
      :super(CatalogInit());

  /*void getCatalog() async {
    emit(CatalogLoading());
    final result = await _shopRepository.getCatalog();
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

  Future<void> getCatalog() async {
    emit(CatalogLoading());

    // 1. Мгновенно показываем локальные данные
    final localData = await _shopRepository.getLocalCatalog();
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
    final remoteData = await _shopRepository.syncFromRemote();
    remoteData.fold(
          (Failure fail) {
        // Если локальных данных не было — показываем ошибку
        if (localData.isRight() && (localData as Right).value.isEmpty) {
          emit(CatalogError(message: _mapFailureToMessage(fail)));
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

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return (failure as CacheFailure).error;
      case CacheFailure:
        return (failure as ServerFailure).error;;
      default:
        return 'Unexpected Error';
    }
  }

}
