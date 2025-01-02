import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
        title: const Text('Historical Data Charts'),
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
            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildChart(
                    data: historicalData
                        .where((data) => data.field == "AQI")
                        .toList(),
                    title: "Air Quality Index (AQI)",
                    color: Colors.blue,
                  ),
                  _buildChart(
                    data: historicalData
                        .where((data) => data.field == "PM25")
                        .toList(),
                    title: "PM2.5 Levels",
                    color: Colors.green,
                  ),
                  _buildChart(
                    data: historicalData
                        .where((data) => data.field == "PM10")
                        .toList(),
                    title: "PM10 Levels",
                    color: Colors.red,
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildChart({
    required List<AQIData> data,
    required String title,
    required Color color,
  }) {
    if (data.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text("No data available for $title."),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final int index = value.toInt();
                        if (index >= 0 && index < data.length) {
                          return Text(
                            DateFormat('MM/dd').format(data[index].time),
                            style: const TextStyle(fontSize: 10),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: true),
                minX: 0,
                maxX: data.length.toDouble() - 1,
                minY: 0,
                maxY: data.map((e) => e.value).reduce((a, b) => a > b ? a : b),
                lineBarsData: [
                  LineChartBarData(
                    spots: data
                        .asMap()
                        .entries
                        .map((entry) =>
                            FlSpot(entry.key.toDouble(), entry.value.value))
                        .toList(),
                    isCurved: true,
                    color: color, // Single color instead of a list
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: color
                          .withOpacity(0.3), // Single color instead of a list
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
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
