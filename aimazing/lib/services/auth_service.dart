import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'http://10.0.2.2:5001/api/user';

  Future<Map<String, dynamic>> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // If the response is successful, parse the response and return it
        print({response.statusCode});
        print('sucess:${response.body}');
        return jsonDecode(response.body);
      } else {
        // If the response is not successful, throw an exception with the error details
        print({response.statusCode});
        throw Exception('Failed to sign up: ${response.body}');
      }
    } catch (e) {
      // Handle network-related errors (e.g., connection issues, timeouts)
      throw Exception('Network err: ${e.toString()}');
    }
  }
}
