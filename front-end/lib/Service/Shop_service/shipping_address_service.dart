import 'dart:convert';
import 'package:appmanga/DatabaseHelper/database_helper.dart';
import 'package:appmanga/Model/Shop_Model/shipping_address_model.dart';
import 'package:http/http.dart' as http;


class ShippingAddressService {
  final String apiUrl = "https://magiabaiser.id.vn/api/shipping-address";


  Future<List<ShippingAddress>> fetchShippingAddresses() async {
    String? token = await DatabaseHelper().getToken();
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Add the authentication header
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((item) => ShippingAddress.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load shipping addresses');
    }
  }

  Future<void> storeAddress(String recipientName, String phoneNumber, String streetAddress, String province, String district, String ward) async {
    final url = Uri.parse(apiUrl);
    String? token = await DatabaseHelper().getToken();
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'recipient_name': recipientName,
        'phone_number': phoneNumber,
        'street_address': streetAddress,
        'province': province,
        'district': district,
        'ward': ward,
      }),
    );

    if (response.statusCode == 200) {
      print('Address saved successfully!');
    } else {
      final errorData = json.decode(response.body);
      print('Failed to save address: ${errorData['message']}');
    }
  }
}
