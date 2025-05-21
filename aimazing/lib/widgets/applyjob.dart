// lib/api/apply.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

Future<String> applyJob({
  required String jobId,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final email = prefs.getString('userEmail');

  if (email == null) {
    print('User email not found in SharedPreferences');
  }

  final url =
      Uri.parse('http://10.0.2.2:5001/api/apply'); // Change to your actual API

  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "email": email,
      "job_id": jobId,
    }),
  );

  if (response.statusCode == 200 || response.statusCode == 400) {
    final data = jsonDecode(response.body);
    return data['message'] ?? 'Applied successfully ✅';
  } else {
    throw Exception('Failed to apply: ${response.reasonPhrase}');
  }
}
