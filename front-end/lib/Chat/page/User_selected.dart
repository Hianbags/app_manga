
// File: jwt_utils.dart

// File: jwt_utils.dart
import 'package:appmanga/DatabaseHelper/database_helper.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

Future<void> main() async {
  // Lấy token từ DatabaseHelper
  String? token = await DatabaseHelper().getToken();
  if (token != null) {
    String userId = getUserIdFromToken(token);
    print('User ID: $userId');
  } else {
    print('Token is null. Unable to retrieve user ID.');
  }
}

// Hàm để lấy ID người dùng từ token
String getUserIdFromToken(String token) {
  print('Token: $token')  ;

  Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
  print('Decoded token: $decodedToken');

  String userId = decodedToken['sub']; // Thay 'sub' bằng key tương ứng trong token của bạn
  return userId;
}
