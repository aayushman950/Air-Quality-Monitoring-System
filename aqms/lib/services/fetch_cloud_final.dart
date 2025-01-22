import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> fetchData() async {
  final url =
      "https://mr14920914789139185.pythonanywhere.com/read?from_date=2024-01-01T08:00:00Z&to_date=2026-01-01T20:00:01Z";

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    String data = response.body.trim();
    String cleanedData = data.replaceAll(RegExp(r'^[,"\r\n]+|[,"\r\n]+$'), '');
    String normalizedData = cleanedData.replaceAll(RegExp(r'\r\n|\r'), '\n');
    List<String> dataList = normalizedData.split(',');

    if (dataList.isNotEmpty && dataList[0] == '') {
      dataList.removeAt(0);
    }

    int rowLength = 10;
    List<List<String>> rows = [];
    for (int i = 0; i < dataList.length; i += rowLength) {
      rows.add(dataList.sublist(
          i, i + rowLength > dataList.length ? dataList.length : i + rowLength));
    }

    if (rows.isNotEmpty) {
      List<List<String>> dataRows = rows.skip(1).toList();
      List<List<String>> pm10Rows =
          dataRows.where((row) => row[6].trim() == 'pm10').toList();
      List<List<String>> pm25Rows =
          dataRows.where((row) => row[6].trim() == 'pm25').toList();

      // Sort rows by timestamp in descending order
      pm10Rows.sort((a, b) =>
          DateTime.parse(b[4].trim()).compareTo(DateTime.parse(a[4].trim())));
      pm25Rows.sort((a, b) =>
          DateTime.parse(b[4].trim()).compareTo(DateTime.parse(a[4].trim())));

      // Get latest values
      List<String>? latestPm10Row = pm10Rows.isNotEmpty ? pm10Rows.first : null;
      List<String>? latestPm25Row = pm25Rows.isNotEmpty ? pm25Rows.first : null;

      double? latestPm10 = latestPm10Row != null
          ? double.tryParse(latestPm10Row[5])
          : null;
      double? latestPm25 = latestPm25Row != null
          ? double.tryParse(latestPm25Row[5])
          : null;
      int? latestPm25Aqi = latestPm25 != null
          ? calculatePm25Aqi(latestPm25)
          : null;

      // Get historical values (last 5 for each type)
      List<Map<String, dynamic>> pm10History = pm10Rows
          .take(5)
          .map((row) => {
                'timestamp': row[4].trim(),
                'value': double.tryParse(row[5]) ?? 0,
              })
          .toList();

      List<Map<String, dynamic>> pm25History = pm25Rows
          .take(5)
          .map((row) => {
                'timestamp': row[4].trim(),
                'value': double.tryParse(row[5]) ?? 0,
              })
          .toList();

      List<Map<String, dynamic>> pm25AqiHistory = pm25Rows
          .take(5)
          .map((row) => {
                'timestamp': row[4].trim(),
                'value': calculatePm25Aqi(double.tryParse(row[5]) ?? 0),
              })
          .toList();

      return {
        'pm10': latestPm10,
        'pm25': latestPm25,
        'pm25_aqi': latestPm25Aqi,
        'pm10_history': pm10History,
        'pm25_history': pm25History,
        'pm25_aqi_history': pm25AqiHistory,
      };
    }
  }
  throw Exception('Failed to fetch data. HTTP Status Code: ${response.statusCode}');
}

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
      return ((bp['I_hi'] - bp['I_lo']) / (bp['C_hi'] - bp['C_lo']) *
                  (concentration - bp['C_lo']) +
              bp['I_lo'])
          .round();
    }
  }
  return -1; // Invalid AQI if out of range
}
