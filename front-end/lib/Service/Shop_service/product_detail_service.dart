import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:appmanga/Model/Shop_Model/product_detail_model.dart';

class ProductService {
  Future<ProductDetail> fetchProduct(int productId) async {
    final response = await http.get(Uri.parse('https://magiabaiser.id.vn/api/product/$productId'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body)['data'];
      return ProductDetail.fromJson(data);
    } else {
      throw Exception('Failed to load product');
    }
  }
}
