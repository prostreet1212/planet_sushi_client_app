
import 'package:planet_sushi_client_app/shop/models/product.dart';

class Category {
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
}
