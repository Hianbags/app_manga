import 'dart:convert';
import 'package:appmanga/DatabaseHelper/database_helper.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteService {
    final String baseUrl = "https://magiabaiser.id.vn/api/favorite";
    Future<Map<String, dynamic>> markAsFavorite(int mangaId) async {
    final url = Uri.parse('$baseUrl?manga_id=$mangaId');

    String? token = await DatabaseHelper().getToken();
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to mark as favorite: ${response.statusCode}');
    }
  }

}