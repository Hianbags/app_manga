import 'dart:convert';
import 'package:appmanga/DatabaseHelper/database_helper.dart';
import 'package:appmanga/User/model/avatar_model.dart';
import 'package:http/http.dart' as http;

class AvatarService {
  static const String _url = 'https://magiabaiser.id.vn/api/avatar'; // Update to your actual endpoint

  Future<List<Avatar>> fetchAvatars() async {
    final response = await http.get(Uri.parse(_url));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['avatars'];
      return data.map((json) => Avatar.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load avatars');
    }
  }
  Future<void> changeAvatar(int avatarId) async {
    String? token = await DatabaseHelper().getToken();
    print('Avatar ID: $avatarId');
    print('Token: $token');
    final response = await http.put(
      Uri.parse(_url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'avatar_id': avatarId}),
    );
    if (response.statusCode != 200) {
      print(response.body);
      throw Exception('Failed to change avatar');
    }
  }
}
