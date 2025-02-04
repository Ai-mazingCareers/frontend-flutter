import 'dart:convert';
import 'package:http/http.dart' as http;

class ATSScoreAPI {
  Future<Map<String, dynamic>> fetchATSScore(
      String userEmail, String jobId) async {
    // Construct the URL with query parameters
    final url = Uri.parse(
        'http://10.0.2.2:2400/api/ats-score?email=sxin@gmail.com&_id=$jobId'); // Replace with your actual API URL

    // Perform the GET request
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Parse the response body
      final data = json.decode(response.body);

      // Check if the response contains the ATS score data
      if (data['message'] == 'ATS Score Calculated Successfully') {
        // Return all relevant data, including score, feedback, missing skills, certifications, and education
        return {
          'score': data['score'],
          'feedback': data['feedback'],
        };
      } else {
        throw Exception('Failed to fetch ATS score');
      }
    } else {
      // Log the API error
      print('API Error: ${response.statusCode} - ${response.body}');
      throw Exception('Failed to fetch ATS score');
    }
  }
}
