import 'package:aqms/services/fetch_cloud_final.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Displays historical air quality data as line charts,
/// showing the average value for each day of the week (Mon-Sun).
class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Future<Map<String, dynamic>> _futureData;

  @override
  void initState() {
    super.initState();
    // Fetch data when the page is initialized
    _futureData = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historical Data',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show loading spinner while waiting for data
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            // Show error message if fetch failed
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Show message if no data is available
            return const Center(
              child: Text('No historical data available.'),
            );
          } else {
            // Extract processed data from the fetchData() result
            final Map<String, dynamic> data = snapshot.data!;
            final pm10History = data['pm10_history'];
            final pm25History = data['pm25_history'];
            final pm25AqiHistory = data['pm25_aqi_history'];

            // Display three charts: AQI, PM2.5, PM10
            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildChart(
                    data: pm25AqiHistory,
                    title: "AQI Levels",
                    color: Colors.red,
                  ),
                  _buildChart(
                    data: pm25History,
                    title: "PM2.5 Levels",
                    color: Colors.green,
                  ),
                  _buildChart(
                    data: pm10History,
                    title: "PM10 Levels",
                    color: Colors.blue,
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  /// Builds a line chart for a given metric's 7-day (weekday) history.
  Widget _buildChart({
    required List<Map<String, dynamic>> data,
    required String title,
    required Color color,
  }) {
    if (data.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text("No data available for $title."),
      );
    }

    // Weekday names for x-axis labels (1=Mon, 7=Sun)
    const weekdayNames = [
      '', // 0 index unused
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun',
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: true),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 50, // Y-axis interval
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(fontSize: 10),
                          textAlign: TextAlign.center,
                        );
                      },
                      reservedSize: 40,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final int index = value.toInt();
                        if (index >= 0 && index < data.length) {
                          // Weekday index: 0=Mon, ..., 6=Sun
                          int weekday = index + 1;
                          return Text(
                            weekdayNames[weekday],
                            style: const TextStyle(fontSize: 10),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles:
                        SideTitles(showTitles: false), // Hide right titles
                  ),
                  topTitles: const AxisTitles(
                    sideTitles:
                        SideTitles(showTitles: false), // Hide top titles
                  ),
                ),
                borderData: FlBorderData(show: true),
                minX: 0,
                maxX: data.length.toDouble() - 1,
                minY: 0,
                maxY: data.length > 0
                    ? data
                            .map((e) => (e['value'] as num).toDouble())
                            .reduce((a, b) => a > b ? a : b) *
                        1.1
                    : 200, // Add margin for better visualization
                lineBarsData: [
                  LineChartBarData(
                    spots: data
                        .asMap()
                        .entries
                        .map((entry) => FlSpot(entry.key.toDouble(),
                            (entry.value['value'] as num).toDouble()))
                        .toList(),
                    isCurved: true,
                    color: color,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: color.withOpacity(0.3),
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
