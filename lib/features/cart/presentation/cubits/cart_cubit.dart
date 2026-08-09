import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planet_sushi_client_app/features/cart/datasource/cart_local_data_source.dart';

import '../../models/cart_item.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CartLocalDataSource _cartLocalDataSource;
  final List<CartItem> _items = [];



  CartCubit({required this._cartLocalDataSource})
      : super(CartLoading()) {
    //loadCart();
  }

  List<CartItem>  get items => _items;

  void loadCart()async{
    List<CartItem> _items=await _cartLocalDataSource.getCartItems();
    if(_items.isEmpty){
      emit(CartEmpty());
    }else{
      emit(CartLoaded(items: _items));
    }

  }
}