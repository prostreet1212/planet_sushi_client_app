import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planet_sushi_client_app/shop/datasource/shop_data_source.dart';
import 'package:planet_sushi_client_app/shop/presentation/cubits/catalog_cubit/catalog_state.dart';

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
