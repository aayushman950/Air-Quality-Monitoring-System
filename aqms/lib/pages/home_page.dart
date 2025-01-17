import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import intl package
import 'package:aqms/widgets/aqi_gauge_and_status.dart';
import 'package:aqms/widgets/both_pm_tile.dart';
import 'package:aqms/services/csv_parser.dart';

class HomePage extends StatefulWidget {
  final String csvData; // CSV data passed to the widget

  const HomePage({super.key, required this.csvData});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<Map<String, dynamic>> _latestDataFuture;

  @override
  void initState() {
    super.initState();
    _latestDataFuture = fetchLatestData();
  }

  Future<Map<String, dynamic>> fetchLatestData() async {
    try {
      // Parse the CSV data to fetch PM values
      final latestValues = CsvParser.getLatestValues(widget.csvData);

      // Construct a map with the required data
      return {
        'PM10': double.tryParse(latestValues['pm10'] ?? '0') ?? 0.0,
        'PM2.5': double.tryParse(latestValues['pm25'] ?? '0') ?? 0.0,
        'AQI': 50.0, // Placeholder AQI value (replace with actual calculation if needed)
        'time': DateTime.now().toUtc().toString(), // Add current time as placeholder
      };
    } catch (e) {
      throw Exception("Failed to fetch latest data: $e");
    }
  }

  Future<void> _refreshData() async {
    // Re-fetch the data and update the state
    setState(() {
      _latestDataFuture = fetchLatestData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.place),
              SizedBox(width: 5),
              Text(
                "Sensor 1",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          centerTitle: true,
        ),
        body: RefreshIndicator(
          onRefresh: _refreshData,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: FutureBuilder<Map<String, dynamic>>(
              future: _latestDataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  );
                } else if (snapshot.hasData) {
                  final data = snapshot.data!;
                  final double aqi = data['AQI'] ?? 0.0;
                  final double pm10 = data['PM10'] ?? 0.0;
                  final double pmTwoPointFive = data['PM2.5'] ?? 0.0;
                  final String rawTime = data['time'] ?? "";

                  // Format the current or retrieved timestamp
                  final String formattedTime =
                      DateFormat('yyyy/MM/dd - hh:mm a').format(DateTime.parse(rawTime).toLocal());

                  return ListView(
                    // ListView is required for RefreshIndicator to work
                    children: [
                      AQIGaugeAndStatus(aqiRating: aqi.toInt()),
                      BothPMTile(
                        pmTwoPointFiveValue: pmTwoPointFive.toInt(),
                        pmTenValue: pm10.toInt(),
                      ),
                      const SizedBox(height: 30),
                      Center(
                        child: Text(
                          "Last Updated: $formattedTime",
                          style: const TextStyle(
                              fontSize: 14, fontStyle: FontStyle.italic),
                        ),
                      ),
                    ],
                  );
                } else {
                  return const Center(
                    child: Text(
                      'No data available',
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
