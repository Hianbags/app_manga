import 'dart:convert';
import 'package:appmanga/DatabaseHelper/database_helper.dart';
import 'package:http/http.dart' as http;

class OrderService {
  static const String _baseUrl = 'https://magiabaiser.id.vn/api';

  Future<Map<String, dynamic>> createOrder(String shippingAddressId, List<int> productIds) async {
    String? token = await DatabaseHelper().getToken();
    final url = Uri.parse('$_baseUrl/order');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final body = jsonEncode({
      'shipping_address': shippingAddressId,
      'product_ids': productIds,
    });
    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to create order: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      return {'status': 'error', 'message': e.toString()};
    }
  }
}
