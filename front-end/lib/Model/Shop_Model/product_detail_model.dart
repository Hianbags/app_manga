import 'package:appmanga/Model/Shop_Model/product_model.dart';

class ProductDetail {
  final int id;
  final String name;
  final String description;
  final int price;
  final List<String> images;
  List<Category> category;
  final String createdAt;
  final String updatedAt;

  ProductDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.images,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductDetail.fromJson(Map<String, dynamic> json) {
    return ProductDetail(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: (json['price'] as num).toInt(), // Convert price to int
      images: List<String>.from(json['images']),
      category: (json['category'] as List<dynamic>)
          .map((category) => Category.fromJson(category))
          .toList(),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'images': images,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

