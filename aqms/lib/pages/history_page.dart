import 'package:aqms/services/fetch_cloud_final.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// Displays historical air quality data as line charts,
/// showing the average value for each day of the week (Mon-Sun),
/// and the last 30 and 90 calendar days.
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
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No historical data available.'));
          } else {
            final Map<String, dynamic> data = snapshot.data!;

            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildWeekdayChart(data['pm25_aqi_history'], 'AQI (7-Day)', Colors.red),
                  _buildWeekdayChart(data['pm25_history'], 'PM2.5 (7-Day)', Colors.green),
                  _buildWeekdayChart(data['pm10_history'], 'PM10 (7-Day)', Colors.blue),

                  _buildDayChart(data['pm25_aqi_30d'], 'AQI (30-Day)', Colors.red),
                  _buildDayChart(data['pm25_30d'], 'PM2.5 (30-Day)', Colors.green),
                  _buildDayChart(data['pm10_30d'], 'PM10 (30-Day)', Colors.blue),

                  _buildDayChart(data['pm25_aqi_90d'], 'AQI (90-Day)', Colors.red),
                  _buildDayChart(data['pm25_90d'], 'PM2.5 (90-Day)', Colors.green),
                  _buildDayChart(data['pm10_90d'], 'PM10 (90-Day)', Colors.blue),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildWeekdayChart(List<Map<String, dynamic>> data, String title, Color color) {
    const weekdayNames = ['', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return _buildChart(
      title: title,
      color: color,
      spots: data.asMap().entries.map((entry) =>
          FlSpot(entry.key.toDouble(), (entry.value['value'] as num).toDouble())).toList(),
      bottomTitles: (value) {
        int index = value.toInt();
        if (index >= 0 && index < data.length) {
          int weekday = index + 1;
          return Text(weekdayNames[weekday], style: const TextStyle(fontSize: 10));
        }
        return const Text('');
      },
    );
  }

  Widget _buildDayChart(List<Map<String, dynamic>> data, String title, Color color) {
    return _buildChart(
      title: title,
      color: color,
      spots: data.asMap().entries.map((entry) =>
          FlSpot(entry.key.toDouble(), (entry.value['value'] as num).toDouble())).toList(),
      bottomTitles: (value) {
        int index = value.toInt();
        if (index >= 0 && index < data.length) {
          return Text(data[index]['date'].toString().substring(5), style: const TextStyle(fontSize: 8));
        }
        return const Text('');
      },
    );
  }

  Widget _buildChart({
    required List<FlSpot> spots,
    required String title,
    required Color color,
    required Widget Function(double) bottomTitles,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                      reservedSize: 40,
                      interval: 50,
                      getTitlesWidget: (value, meta) => Text(value.toInt().toString(), style: const TextStyle(fontSize: 10)),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) => bottomTitles(value),
                    ),
                  ),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: true),
                minX: 0,
                maxX: spots.length > 1 ? spots.length.toDouble() - 1 : 1,
                minY: 0,
                maxY: spots.isNotEmpty ? spots.map((e) => e.y).reduce((a, b) => a > b ? a : b) * 1.1 : 100,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
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
