import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Future<List<AQIData>> _futureHistoricalData;

  @override
  void initState() {
    super.initState();
    _futureHistoricalData = fetchHistoricalData();
  }

  // Fetch historical data from the Flask backend
  Future<List<AQIData>> fetchHistoricalData() async {
    const url = 'http://10.0.2.2:5000/history'; // Adjust URL as needed
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => AQIData.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load historical data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historical Data'),
      ),
      body: FutureBuilder<List<AQIData>>(
        future: _futureHistoricalData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No historical data available.'),
            );
          } else {
            final List<AQIData> historicalData = snapshot.data!;
            return ListView.builder(
              itemCount: historicalData.length,
              itemBuilder: (context, index) {
                final AQIData record = historicalData[index];
                return ListTile(
                  leading: Icon(_getIconForField(record.field)),
                  title: Text(record.field),
                  subtitle: Text('Value: ${record.value.toStringAsFixed(2)}'),
                  trailing: Text(
                    _formatTime(record.time),
                    style: const TextStyle(fontSize: 12),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  // Utility function to format time
  String _formatTime(DateTime time) {
    return '${time.day}/${time.month}/${time.year} ${time.hour}:${time.minute}';
  }

  // Utility function to return an appropriate icon for each field
  IconData _getIconForField(String field) {
    switch (field) {
      case "AQI":
        return Icons.air;
      case "PM25":
        return Icons.cloud;
      case "PM10":
        return Icons.cloud_circle;
      default:
        return Icons.help;
    }
  }
}

// Data model for AQI, PM2.5, and PM10
class AQIData {
  final DateTime time;
  final String field;
  final double value;

  AQIData({required this.time, required this.field, required this.value});

  factory AQIData.fromJson(Map<String, dynamic> json) {
    final dateFormat = DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'");
    return AQIData(
      time: dateFormat.parse(json['time'], true).toLocal(),
      field: json['field'],
      value: (json['value'] as num).toDouble(),
    );
  }
}
