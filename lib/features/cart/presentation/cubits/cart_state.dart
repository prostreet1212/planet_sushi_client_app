import '../../models/cart_item.dart';

abstract class CartState {}

class CartLoading extends CartState {}

class CartEmpty extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> items;
  CartLoaded({required this.items});

  // double get totalPrice =>
  //     items.fold(0, (sum, item) => sum + item.totalPrice);
  // int get totalCount =>
  //     items.fold(0, (sum, item) => sum + item.quantity);
}