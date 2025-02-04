import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Replace with your actual API endpoint
  final String apiUrl = 'https://your-api-endpoint.com/submit';

  // Function to send data to the API and return a success flag
  Future<bool> submitResumeData(String name) async {
    // Prepare the data to send
    Map<String, dynamic> requestData = {
      'name': name,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json', // Ensure content type is JSON
        },
        body: json.encode(requestData), // Send the name as JSON data
      );

      if (response.statusCode == 200) {
        // Handle success
        return true;
      } else {
        // Handle error if the response status is not 200
        throw Exception('Failed to submit data');
      }
    } catch (e) {
      // Handle network or other errors
      print('Error: $e');
      throw Exception('Error: $e');
    }
  }
}
