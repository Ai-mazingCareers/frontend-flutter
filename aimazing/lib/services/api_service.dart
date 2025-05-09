import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://10.0.2.2:5001/api";

  static Future<Map<String, dynamic>> loginUser(
      String email, String password) async {
    final url = Uri.parse('$baseUrl/user/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body); // contains token & user info
      } else {
        return {"error": jsonDecode(response.body)['message']};
      }
    } catch (e) {
      return {"error": "An error occurred: $e"};
    }
  }
}
