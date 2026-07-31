import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../datasource/shop_data_source.dart';
import 'catalog_state.dart';

class CatalogCubit extends Cubit<CatalogState> {
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
}
