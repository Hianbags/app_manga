class ShippingAddress {
  final int id;
  final String recipientName;
  final String phoneNumber;
  final String streetAddress;
  final String province;
  final String district;
  final String ward;

  ShippingAddress({
    required this.id,
    required this.recipientName,
    required this.phoneNumber,
    required this.streetAddress,
    required this.province,
    required this.district,
    required this.ward,
  });

  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    return ShippingAddress(
      id: json['id'],
      recipientName: json['recipient_name'],
      phoneNumber: json['phone_number'],
      streetAddress: json['street_address'],
      province: json['province'],
      district: json['district'],
      ward: json['ward'],
    );
  }
}
