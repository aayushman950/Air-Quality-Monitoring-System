import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> fetchData() async {
  final url =
      "https://mr14920914789139185.pythonanywhere.com/read?from_date=2024-01-10T08:09:41Z&to_date=2026-01-01T20:00:01Z";

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

      List<String>? latestPm10Row = pm10Rows.isNotEmpty
          ? pm10Rows.reduce((a, b) =>
              DateTime.parse(a[4].trim()).isAfter(DateTime.parse(b[4].trim()))
                  ? a
                  : b)
          : null;

      List<String>? latestPm25Row = pm25Rows.isNotEmpty
          ? pm25Rows.reduce((a, b) =>
              DateTime.parse(a[4].trim()).isAfter(DateTime.parse(b[4].trim()))
                  ? a
                  : b)
          : null;

      double? pm25 = latestPm25Row != null ? double.tryParse(latestPm25Row[5]) : null;
      int? pm25Aqi = pm25 != null ? calculatePm25Aqi(pm25) : null;

      return {
        'pm10': latestPm10Row?[5],
        'pm25': latestPm25Row?[5],
        'pm25_aqi': pm25Aqi,
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
