import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/air_quality_data.dart'; // Import the model

class ApiService {
  final String baseUrl = "http://127.0.0.1:5000"; // Replace with Flask backend URL

  Future<List<AirQualityData>> fetchLatestData() async {
    final response = await http.get(Uri.parse('$baseUrl/latest'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((data) => AirQualityData.fromJson(data)).toList();
    } else {
      throw Exception('Failed to fetch data: ${response.statusCode}');
    }
  }
}

