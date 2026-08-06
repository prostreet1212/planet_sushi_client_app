import 'package:drift/drift.dart';
import 'package:planet_sushi_client_app/features/database/database.dart';
import 'package:uuid/uuid.dart';
import '../../shop/models/product.dart';
import '../models/cart_item.dart';

class CartLocalDataSource {
  final AppDatabase _db;

  CartLocalDataSource({required this._db});

  Future<List<CartItem>> getCartItems() async {
    final cartItems = await _db.select(_db.cartItems).get();
    final result = <CartItem>[];

    for (final cart in cartItems) {
      var product =
          await (_db.select(_db.products)
                ..where((p) => p.id.equals(cart.productId))
              //..where((p) => p.isAvailable.equals(true))
              )
              .getSingle();

      result.add(
        CartItem(
          id: cart.id,
          userId: 'userId',//доделать
          productId: cart.productId,
          product: Product(
            id: product.id,
            name: product.name,
            price: product.price,
            description: product.description,
            imageUrl: product.imageUrl,
            weight: product.weight,
            isAvailable: product.isAvailable,
          ),
          quantity: cart.quantity,
        ),
      );
    }
    ;

    return result;
  }


  void insertCartItem(String userId, Product product)async{
    const uuid = Uuid();
    final String id = uuid.v7();
    await _db.into(_db.cartItems).insert(CartItemsCompanion.insert(id: id, userId: userId, productId: product.id, quantity: 1));
  }

  /// Полная перезапись корзины (транзакция)
  /* Future<void> saveCartItems(List<CartItem> items) async {
    await _db.transaction(() async {
      await _db.delete(_db.cartItems).go();
      for (final item in items) {
        await _db.into(_db.cartItems).insert(CartItemsCompanion.insert(
          productId: item.product.id,
          name: item.product.name,
          description: Value(item.product.description),
          price: item.product.price,
          imageUrl: Value(item.product.imageUrl),
          weight: Value(item.product.weight),
          isAvailable: item.product.isAvailable,
          quantity: item.quantity,
        ));
      }
    });
  }*/

  Future<void> clear() async {
    await _db.delete(_db.cartItems).go();
  }
}
