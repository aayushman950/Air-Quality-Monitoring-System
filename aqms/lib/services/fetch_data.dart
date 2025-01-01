// Fetches the one latest data


import 'dart:convert';
import 'package:http/http.dart' as http;

class FetchLatestData {
  static final String baseUrl =
      "http://10.0.2.2:5000"; // Replace with Flask backend URL

  static Future<Map<String, dynamic>> getLatestData() async {
    final response = await http.get(Uri.parse('$baseUrl/latest'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse =
          json.decode(response.body) as List<dynamic>;
      final Map<String, dynamic> data = {
        for (var item in jsonResponse)
          item['field']: (item['value'] as num).toDouble(),
        "time": jsonResponse[0]
            ['time'], // Include the first record's time field
      };
      return data;
    } else {
      throw Exception('Failed to fetch data: ${response.statusCode}');
    }
  }
}
