import 'dart:convert';
import 'package:http/http.dart' as http;

class FetchLatestData {
  static final String baseUrl = "http://10.0.2.2:5000"; // Replace with Flask backend URL

  static Future<Map<String, dynamic>> getLatestData() async {
    final response = await http.get(Uri.parse('$baseUrl/latest'));

    if (response.statusCode == 200) {
      // Parse the JSON list
      final List<dynamic> jsonResponse = json.decode(response.body) as List<dynamic>;

      // Convert the list to a map, ensuring all values are treated as doubles
      final Map<String, dynamic> data = {
        for (var item in jsonResponse) item['field']: (item['value'] as num).toDouble()
      };

      return data;
    } else {
      throw Exception('Failed to fetch data: ${response.statusCode}');
    }
  }
}
