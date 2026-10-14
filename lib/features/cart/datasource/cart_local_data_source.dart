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
              .getSingleOrNull();
      if (product == null) continue; // или обработать как недоступный

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

  Stream<List<CartItem>> watchCartItems() {
    JoinedSelectStatement query = _db.select(_db.cartItems).join([
      innerJoin(_db.products, _db.products.id.equalsExp(_db.cartItems.productId)),
    ]);
    return query.watch().map((rows) => rows.map((row) {
      final cart = row.readTable(_db.cartItems);
      final p = row.readTable(_db.products);
      return CartItem(
        id: cart.id,
        userId: cart.userId ?? '',
        productId: cart.productId,
        product: Product(
          id: p.id, name: p.name, price: p.price,
          description: p.description, imageUrl: p.imageUrl,
          weight: p.weight, isAvailable: p.isAvailable,
        ),
        quantity: cart.quantity,
      );
    }).toList());
  }


  Future<void> insertCartItem(String? userId, Product product)async{
    const uuid = Uuid();
    final String id = uuid.v7();
    try{
         _db.into(_db.cartItems).insert(CartItemsCompanion.insert(id: id, userId: Value(userId), productId: product.id, quantity: 1));
    }catch(e){
      print('local db error:$e');
    }
  }
  
  Future<void> updateCartItem(CartItem cart,int count)async{
    _db.update(_db.cartItems)..where((tbl)=>tbl.id.equals(cart.id))..write(CartItemsCompanion(quantity: Value(count)));

    // await (update(todoItems)
    //   ..where((tbl) => tbl.id.equals(1)))
    //     .write(const TodoItemsCompanion(
    //   content: Value('Only this column changes!'),
    // ));
    
  }

  Future<void> deleteCartItem(CartItem cart)async{
    await _db.delete(_db.cartItems)..where((tbl)=>tbl.id.equals(cart.id))..go();
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
