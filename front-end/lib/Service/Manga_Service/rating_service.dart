import 'dart:convert';
import 'package:appmanga/DatabaseHelper/database_helper.dart';
import 'package:http/http.dart' as http;

class RatingService {
  Future<Map<String, dynamic>> submitRating(int mangaId, int rating) async {
    print('Getting token from database...');
    String? token = await DatabaseHelper().getToken();
    print('Token retrieved: $token');

    final url = Uri.parse('https://magiabaiser.id.vn/api/rating/$mangaId');
    print('URL: $url');
    print('Sending POST request with rating: $rating');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'rating': rating}),
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        print('Rating submitted successfully');
        return {'success': true, 'message': jsonDecode(response.body)['message']};
      } else {
        print('Failed to submit rating: ${response.body}');
        return {'success': false, 'message': jsonDecode(response.body)['error']};
      }
    } catch (e) {
      print('Error occurred: $e');
      return {'success': false, 'message': 'An error occurred'};
    }
  }
}
