import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:aqms/models/aqi_data_model.dart';

Future<List<AQIData>> fetchHistoricalData() async {
  final response = await http.get(Uri.parse('http://your-flask-server-url/history'));

  if (response.statusCode == 200) {
    List<dynamic> jsonData = jsonDecode(response.body);
    return jsonData.map((data) => AQIData.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load historical data');
  }
}
