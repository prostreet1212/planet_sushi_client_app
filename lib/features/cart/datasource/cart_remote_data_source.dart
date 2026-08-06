
import 'package:planet_sushi_client_app/features/cart/models/cart_item.dart';
import 'package:planet_sushi_client_app/features/shop/models/product.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class CartRemoteDataSource {
  final Supabase supabase;

  CartRemoteDataSource({required this.supabase});

  void insertCart(String userId, String productId) async {
    const uuid = Uuid();
    final String id = uuid.v7();
    var a=CartItem(id: id, userId: userId,productId: productId, quantity: 1).toJson();
    try {
      await supabase.client.from('cart_items').insert(a);
    } catch (e) {
      print(e.toString());
  }
  }
}