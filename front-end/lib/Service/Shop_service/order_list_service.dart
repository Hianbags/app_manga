import 'dart:convert';
import 'package:appmanga/DatabaseHelper/database_helper.dart';
import 'package:appmanga/Model/Shop_Model/order_detail_model.dart';
import 'package:appmanga/Model/Shop_Model/order_model.dart';
import 'package:http/http.dart' as http;

class OrderService {
  final String apiUrl = 'https://magiabaiser.id.vn/api/order';

  Future<OrderResponse> fetchOrders(String status) async {
    String? token = await DatabaseHelper().getToken();
    final response = await http.get(
      Uri.parse('$apiUrl?status=$status'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return OrderResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load orders');
    }
  }

  Future<OrderDetail> fetchOrderDetail(int id) async {
    String? token = await DatabaseHelper().getToken();
    final response = await http.get(Uri.parse('$apiUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },);
    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body)['data'];
      return OrderDetail.fromJson(json);
    } else {
      throw Exception('Failed to load order detail');
    }
  }
}
