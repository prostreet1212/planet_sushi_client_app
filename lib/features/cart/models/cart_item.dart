import 'package:equatable/equatable.dart';
import '../../shop/models/product.dart';


class CartItem extends Equatable {
  final String id;
  final String userId;
  final String productId;
  final Product? product;
  final int quantity;

  const CartItem({required this.id, required this.userId,required this.productId,  this.product, required this.quantity});

  CartItem copyWith({String? id, String? userId,String? productId, Product? product, int? quantity}) => CartItem(
    id: id??this.id,
    userId: userId??this.userId,
    productId: productId??this.productId,
    product: product ?? this.product,
    quantity: quantity ?? this.quantity,
  );

  double get totalPrice => product!.price * quantity;

  int get totalWeight=>product!.weight!*quantity;

  /// Сериализация для локальной БД и Supabase
  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'product_id': productId,
    'quantity': quantity,
  };

  /*factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      product: Product(
        id: json['product_id'] ?? json['id'] ?? '',
        name: json['name'] ?? '',
        description: json['description'],
        price: double.tryParse(json['price'].toString()) ?? 0.0,
        imageUrl: json['image_url'],
        weight: json['weight'],
        isAvailable: json['is_available'] ?? true,
      ),
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
    );
  }*/

  @override
  List<Object?> get props => [product, quantity];
}