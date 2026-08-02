
import 'package:equatable/equatable.dart';
import 'package:planet_sushi_client_app/features/shop/models/product.dart';

class Category extends Equatable{
  final String id;
  final String name;
  final String? imageUrl;
  final List<Product> products; // Вложенные товары

  Category({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.products,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      imageUrl: json['image_url'],
      products: (json['products'] as List?)
          ?.map((p) => Product.fromJson(p))
          .where((p) => p.isAvailable) // Сразу фильтруем недоступные
          .toList() ?? [],
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [id,name,imageUrl,products];
}
