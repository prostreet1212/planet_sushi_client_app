// lib/models/product.dart
class Product {
  final String id;
  final String categoryId;
  final String name;
  final String slug;
  final String? description;
  final double price;
  final double? oldPrice;
  final String? imageUrl;
  final List<String>? images;
  final List<String>? ingredients;
  final int? weightGrams;
  final int? calories;
  final bool isAvailable;
  final bool isNew;
  final bool isHit;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? categoryName;
  final List<ProductVariant>? variants;

  Product({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.slug,
    this.description,
    required this.price,
    this.oldPrice,
    this.imageUrl,
    this.images,
    this.ingredients,
    this.weightGrams,
    this.calories,
    this.isAvailable = true,
    this.isNew = false,
    this.isHit = false,
    this.sortOrder = 0,
    required this.createdAt,
    required this.updatedAt,
    this.categoryName,
    this.variants,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      categoryId: json['category_id'],
      name: json['name'],
      slug: json['slug'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      oldPrice: json['old_price'] != null ? (json['old_price'] as num).toDouble() : null,
      imageUrl: json['image_url'],
      images: json['images'] != null ? List<String>.from(json['images']) : null,
      ingredients: json['ingredients'] != null ? List<String>.from(json['ingredients']) : null,
      weightGrams: json['weight_grams'],
      calories: json['calories'],
      isAvailable: json['is_available'] ?? true,
      isNew: json['is_new'] ?? false,
      isHit: json['is_hit'] ?? false,
      sortOrder: json['sort_order'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      categoryName: json['categories'] != null ? json['categories']['name'] : null,
      variants: json['product_variants'] != null
          ? (json['product_variants'] as List).map((v) => ProductVariant.fromJson(v)).toList()
          : null,
    );
  }
}

// lib/models/product_variant.dart
class ProductVariant {
  final String id;
  final String productId;
  final String name;
  final double price;
  final int? weightGrams;
  final bool isDefault;
  final DateTime createdAt;

  ProductVariant({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
    this.weightGrams,
    this.isDefault = false,
    required this.createdAt,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      id: json['id'],
      productId: json['product_id'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      weightGrams: json['weight_grams'],
      isDefault: json['is_default'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}