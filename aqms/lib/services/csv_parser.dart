import 'dart:convert'; // For utf8.decode
import 'package:csv/csv.dart';

class CsvParser {
  /// Parses CSV data and extracts the latest values for `pm10` and `pm2.5`.
  static Map<String, String> getLatestValues(String csvData) {
    final decodedData = utf8.decode(csvData.codeUnits);

    try {
      // Parse the CSV data
      List<List<dynamic>> rows = const CsvToListConverter(eol: "\n").convert(decodedData);

      // Ensure we have data
      if (rows.isEmpty) {
        throw Exception("The CSV file is empty!");
      }

      // Extract the headers (first row)
      List<String> headers = rows[0].map((e) => e.toString()).toList();

      // Identify indices for required columns
      int timeIndex = headers.indexOf('_time');
      int valueIndex = headers.indexOf('_value');
      int fieldIndex = headers.indexOf('_field');

      if (timeIndex == -1 || valueIndex == -1 || fieldIndex == -1) {
        throw Exception("One or more required columns (_time, _value, _field) are missing in the CSV file.");
      }

      // Filter rows for `pm10` and `pm2.5` and sort by time descending
      final pm10Rows = rows
          .skip(1)
          .where((row) => row[fieldIndex]?.toString() == 'pm10')
          .toList()
        ..sort((a, b) => b[timeIndex].toString().compareTo(a[timeIndex].toString()));

      final pm25Rows = rows
          .skip(1)
          .where((row) => row[fieldIndex]?.toString() == 'pm25')
          .toList()
        ..sort((a, b) => b[timeIndex].toString().compareTo(a[timeIndex].toString()));

      // Get the latest values
      String latestPm10 = pm10Rows.isNotEmpty ? pm10Rows.first[valueIndex].toString() : "N/A";
      String latestPm25 = pm25Rows.isNotEmpty ? pm25Rows.first[valueIndex].toString() : "N/A";

      return {
        'pm10': latestPm10,
        'pm25': latestPm25,
      };
    } catch (e) {
      throw Exception("Error while parsing CSV: $e");
    }
  }
}
