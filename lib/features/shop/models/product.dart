import 'package:equatable/equatable.dart';

class Product extends Equatable{
  final String id;
  final String name;
  final String? description;
  final double price;
  final String? imageUrl;
  final int? weight;
  final bool isAvailable;

  Product({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    this.imageUrl,
    this.weight,
    this.isAvailable = true,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: double.parse(json['price'].toString()),
      imageUrl: json['image_url'],
      weight: json['weight'],
      isAvailable: json['is_available'] ?? true,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [id,name,description,price,imageUrl,weight,isAvailable];
}
