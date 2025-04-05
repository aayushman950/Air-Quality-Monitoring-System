import 'package:csv/csv.dart';
import 'package:http/http.dart' as http;

class FetchLatestData {
  static Future<Map<String, dynamic>> getLatestData() async {
    final response = await http.get(
      Uri.parse(
        'https://mr14920914789139185.pythonanywhere.com/read?from_date=2024-01-01T08:00:00Z&to_date=2026-01-01T20:00:01Z',
      ),
    );

    if (response.statusCode == 200) {
      final csvData = const CsvToListConverter().convert(response.body);

      // Filter out invalid rows
      final validData = csvData.where((row) => row.length > 7).toList();

      // Find PM10 and PM2.5 rows
      final pm10Row = validData.firstWhere(
        (row) => row[7] == 'pm10',
        orElse: () => [],
      );
      final pm25Row = validData.firstWhere(
        (row) => row[7] == 'pm25',
        orElse: () => [],
      );

      if (pm25Row != null) {
        return {
          'PM10': double.parse(pm10Row[5].toString()),
          'PM2.5': double.parse(pm25Row[5].toString()),
          'time': pm10Row[4], // Assuming time is consistent
        };
      } else {
        throw Exception("PM10 or PM2.5 data not found");
      }
    } else {
      throw Exception("Failed to fetch data: ${response.statusCode}");
    }
  }
}
