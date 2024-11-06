class Product {
  final int id;
  final String name;
  final int price;
  final String image;
  final int quantity;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.quantity,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      image: json['image_path'],
      quantity: json['quantity'],
    );
  }
}

class Order {
  final int id;
  final List<Product> products;
  final String totalPrice;
  final String createdAt;
  final String updatedAt;

  Order({
    required this.id,
    required this.products,
    required this.totalPrice,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    var productList = json['product'] as List;
    List<Product> productItems = productList.map((i) => Product.fromJson(i)).toList();
    return Order(
      id: json['id'],
      products: productItems,
      totalPrice: json['total_price'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class OrderResponse {
  final String status;
  final List<Order> data;

  OrderResponse({
    required this.status,
    required this.data,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    var dataList = json['data'] as List?;
    if (dataList == null) {
      throw Exception('No data available');
    }
    List<Order> orders = dataList.map((i) => Order.fromJson(i)).toList();
    return OrderResponse(
      status: json['status'],
      data: orders,
    );
  }

}
