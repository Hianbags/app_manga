class OrderListModel {
  final int id;
  final String user;
  final double totalPrice;
  final List<Product> products;
  final String createdAt;
  final String updatedAt;

  OrderListModel({
    required this.id,
    required this.user,
    required this.totalPrice,
    required this.products,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderListModel.fromJson(Map<String, dynamic> json) {
    List<Product> products = [];
    if (json['products'] != null) {
      products = List<Product>.from(json['products'].map((product) => Product.fromJson(product)));
    }
    return OrderListModel(
      id: json['id'],
      user: json['user'],
      totalPrice: double.parse(json['total_price']), // Parse total_price to double
      products: products,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class Product {
  final int id;
  final String name;
  final double price;

  Product({
    required this.id,
    required this.name,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: double.parse(json['price'].toString()), // Ensure price is parsed as double
    );
  }
}
