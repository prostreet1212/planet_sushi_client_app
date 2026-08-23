import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planet_sushi_client_app/features/cart/datasource/cart_local_data_source.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../shop/models/product.dart';
import '../../models/cart_item.dart';
import 'cart_state.dart';
import 'package:planet_sushi_client_app/injection_container.dart' as di;

class CartCubit extends Cubit<CartState> {
  final CartLocalDataSource _cartLocalDataSource;
  List<CartItem> _items = [];


  CartCubit({required this._cartLocalDataSource}) : super(CartLoaded(items: [])) {
    //loadCart();
  }

  List<CartItem> get items => _items;



  Future<void> insertCart(String userId, Product product) async {
    await _cartLocalDataSource.insertCartItem(userId, product);
    await loadCart();
  }

  Future<void> deleteCart (CartItem cart)async{
    await _cartLocalDataSource.deleteCartItem(cart);
    await loadCart();
  }

  Future<void> updateCartQuantity (CartItem cart,int count)async{
    await _cartLocalDataSource.updateCartItem(cart, count);
  }

  Future<void> loadCart() async {
    String? a=di.sl<Supabase>().client.auth.currentUser?.id??'a';
    print('пользователь $a');
    _items = await _cartLocalDataSource.getCartItems();
    if (_items.isEmpty) {
      emit(CartEmpty());
    } else {
      emit(CartLoaded(items: _items));
    }
  }
}
