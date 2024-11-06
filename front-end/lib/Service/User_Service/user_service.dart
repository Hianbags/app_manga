import 'dart:convert';
import 'package:appmanga/DatabaseHelper/database_helper.dart';
import 'package:appmanga/Model/User_model/user_model.dart';
import 'package:http/http.dart' as http;

class UserService {
  static Future<User> getUserInfo() async {
    String? token = await DatabaseHelper().getToken();
    final String apiUrl = 'https://magiabaiser.id.vn/api/details';
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      print('User info retrieved: $responseData'); // Print statement added here
      return User.fromJson(responseData['data']);
    } else {
      throw Exception('Failed to load user info');
    }
  }

  static Future<void> logout() async {
    DatabaseHelper().deleteToken();
  }
}
