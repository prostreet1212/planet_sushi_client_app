



import '../../../models/category.dart';

abstract class CatalogState{}

class CatalogInit extends CatalogState{}
class CatalogLoading extends CatalogState{}
class CatalogEmpty extends CatalogState{}

class CatalogSuccess extends CatalogState{
  final List<Category> categoryList;
  CatalogSuccess({required this.categoryList});


}
class CatalogError extends CatalogState{
  final String message;

  CatalogError({required this.message});

}