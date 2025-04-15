import 'package:http/http.dart' as http;

/// Fetches air quality data from the cloud API, processes it,
/// and returns a map containing the latest values and
/// 7-day (weekday) average histories for PM10, PM2.5, and PM2.5 AQI.
Future<Map<String, dynamic>> fetchData() async {
  const url =
      "https://mr14920914789139185.pythonanywhere.com/read?from_date=2024-01-01T08:00:00Z&to_date=2026-01-01T20:00:01Z";

  // Make HTTP GET request
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    // Clean and parse the CSV-like response
    String data = response.body.trim();
    String cleanedData = data.replaceAll(RegExp(r'^[,"\r\n]+|[,"\r\n]+$'), '');
    String normalizedData = cleanedData.replaceAll(RegExp(r'\r\n|\r'), '\n');
    List<String> dataList = normalizedData.split(',');

    // Remove empty first element if present
    if (dataList.isNotEmpty && dataList[0] == '') {
      dataList.removeAt(0);
    }

    // Split flat list into rows of 10 columns each
    int rowLength = 10;
    List<List<String>> rows = [];
    for (int i = 0; i < dataList.length; i += rowLength) {
      rows.add(dataList.sublist(
          i, i + rowLength > dataList.length ? dataList.length : i + rowLength));
    }

    if (rows.isNotEmpty) {
      // Skip header row
      List<List<String>> dataRows = rows.skip(1).toList();

      // Filter for PM10 and PM2.5 rows
      List<List<String>> pm10Rows =
          dataRows.where((row) => row[6].trim() == 'pm10').toList();
      List<List<String>> pm25Rows =
          dataRows.where((row) => row[6].trim() == 'pm25').toList();

      // Sort by timestamp descending (latest first)
      pm10Rows.sort((a, b) =>
          DateTime.parse(b[4].trim()).compareTo(DateTime.parse(a[4].trim())));
      pm25Rows.sort((a, b) =>
          DateTime.parse(b[4].trim()).compareTo(DateTime.parse(a[4].trim())));

      // Get latest values for PM10 and PM2.5
      List<String>? latestPm10Row = pm10Rows.isNotEmpty ? pm10Rows.first : null;
      List<String>? latestPm25Row = pm25Rows.isNotEmpty ? pm25Rows.first : null;

      double? latestPm10 =
          latestPm10Row != null ? double.tryParse(latestPm10Row[5]) : null;
      double? latestPm25 =
          latestPm25Row != null ? double.tryParse(latestPm25Row[5]) : null;
      int? latestPm25Aqi =
          latestPm25 != null ? calculatePm25Aqi(latestPm25) : null;

      /// Helper function to group data by weekday and calculate average.
      /// Returns a list of 7 maps (one for each weekday, Mon=1..Sun=7).
      List<Map<String, dynamic>> _averageByWeekday(List<List<String>> rows, {bool isAqi = false}) {
        Map<int, List<double>> weekdayValues = {};
        for (var row in rows) {
          DateTime dt = DateTime.parse(row[4].trim());
          int weekday = dt.weekday; // 1=Mon, 7=Sun
          double value = double.tryParse(row[5]) ?? 0;
          if (isAqi) value = calculatePm25Aqi(value).toDouble();
          weekdayValues.putIfAbsent(weekday, () => []).add(value);
        }
        // Build result for all 7 days
        List<Map<String, dynamic>> result = [];
        for (int i = 1; i <= 7; i++) {
          List<double> values = weekdayValues[i] ?? [];
          double avg = values.isNotEmpty
              ? values.reduce((a, b) => a + b) / values.length
              : 0;
          // Use the most recent timestamp for that weekday, or empty string
          String? timestamp;
          if (rows.isNotEmpty) {
            var filtered = rows.where((row) => DateTime.parse(row[4].trim()).weekday == i).toList();
            if (filtered.isNotEmpty) {
              filtered.sort((a, b) => DateTime.parse(b[4].trim()).compareTo(DateTime.parse(a[4].trim())));
              timestamp = filtered.first[4].trim();
            }
          }
          result.add({
            'timestamp': timestamp ?? '',
            'value': avg,
          });
        }
        return result;
      }

      // Calculate 7-day (weekday) averages for each metric
      List<Map<String, dynamic>> pm10History = _averageByWeekday(pm10Rows);
      List<Map<String, dynamic>> pm25History = _averageByWeekday(pm25Rows);
      List<Map<String, dynamic>> pm25AqiHistory = _averageByWeekday(pm25Rows, isAqi: true);

      String? latestPm25Timestamp =
          latestPm25Row != null ? latestPm25Row[4].trim() : null;

      // Return all results in a map
      return {
        'pm10': latestPm10,
        'pm25': latestPm25,
        'pm25_aqi': latestPm25Aqi,
        'latest_pm25_timestamp': latestPm25Timestamp,
        'pm10_history': pm10History,
        'pm25_history': pm25History,
        'pm25_aqi_history': pm25AqiHistory,
      };
    }
  }
  // If HTTP request failed, throw an error
  throw Exception(
      'Failed to fetch data. HTTP Status Code: ${response.statusCode}');
}

/// Calculates the AQI for a given PM2.5 concentration using EPA breakpoints.
int calculatePm25Aqi(double concentration) {
  List<Map<String, dynamic>> breakpoints = [
    {'C_lo': 0, 'C_hi': 12, 'I_lo': 0, 'I_hi': 50},
    {'C_lo': 12.1, 'C_hi': 35.4, 'I_lo': 51, 'I_hi': 100},
    {'C_lo': 35.5, 'C_hi': 55.4, 'I_lo': 101, 'I_hi': 150},
    {'C_lo': 55.5, 'C_hi': 150.4, 'I_lo': 151, 'I_hi': 200},
    {'C_lo': 150.5, 'C_hi': 250.4, 'I_lo': 201, 'I_hi': 300},
  ];

  for (var bp in breakpoints) {
    if (concentration >= bp['C_lo'] && concentration <= bp['C_hi']) {
      return ((bp['I_hi'] - bp['I_lo']) /
                  (bp['C_hi'] - bp['C_lo']) *
                  (concentration - bp['C_lo']) +
              bp['I_lo'])
          .round();
    }
  }
  return -1; // Invalid AQI if out of range
}
