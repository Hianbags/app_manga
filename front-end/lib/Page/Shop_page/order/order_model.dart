class OrderResponse {
  final int userId;
  final int totalPrice;
  final String status;
  final DateTime updatedAt;
  final DateTime createdAt;
  final int id;
  final String shippingAddressId;

  OrderResponse({
    required this.userId,
    required this.totalPrice,
    required this.status,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
    required this.shippingAddressId,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      userId: json['user_id'],
      totalPrice: json['total_price'],
      status: json['status'],
      updatedAt: DateTime.parse(json['updated_at']),
      createdAt: DateTime.parse(json['created_at']),
      id: json['id'],
      shippingAddressId: json['shipping_address_id'],
    );
  }
}
