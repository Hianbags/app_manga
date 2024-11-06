class OrderDetail {
  final int id;
  final ShippingAddress shippingAddress;
  final List<Product> products;
  final String status;
  final String totalPrice;
  final String createdAt;
  final String updatedAt;

  OrderDetail({
    required this.id,
    required this.shippingAddress,
    required this.products,
    required this.status,
    required this.totalPrice,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      id: json['id'],
      shippingAddress: ShippingAddress.fromJson(json['shipping_address']),
      products: List<Product>.from(json['product'].map((x) => Product.fromJson(x))),
      status: json['status'],
      totalPrice: json['total_price'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class ShippingAddress {
  final int id;
  final String recipientName;
  final String streetAddress;
  final String phoneNumber;
  final String province;
  final String district;
  final String ward;

  ShippingAddress({
    required this.id,
    required this.recipientName,
    required this.streetAddress,
    required this.phoneNumber,
    required this.province,
    required this.district,
    required this.ward,
  });

  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    return ShippingAddress(
      id: json['id'],
      recipientName: json['recipient_name'],
      streetAddress: json['street_address'],
      phoneNumber: json['phone_number'],
      province: json['province'],
      district: json['district'],
      ward: json['ward'],
    );
  }
}

class Product {
  final int id;
  final String name;
  final int price;
  final int quantity;
  final String? imagePath;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    this.imagePath,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      quantity: json['quantity'],
      imagePath: json['image_path'],
    );
  }
}
