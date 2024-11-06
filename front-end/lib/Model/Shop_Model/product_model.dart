class Product {
  final int id;
  final String name;
  final String description;
  final int price;
  final String image;
  List<Category> category;
  final String createdAt;
  final String updatedAt;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      image: json['image'],
      category: (json['category'] as List<dynamic>)
          .map((category) => Category.fromJson(category))
          .toList(),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
class Category {
  int id;
  String title;

  Category({
    required this.id,
    required this.title,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      title: json['title'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
    };
  }
}
