import 'package:flutter/material.dart';
import 'package:aqms/models/aqi_data_model.dart';
import 'package:aqms/services/fetch_historic.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Future<List<AQIData>> historicalData;

  @override
  void initState() {
    super.initState();
    historicalData = fetchHistoricalData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historical Data'),
      ),
      body: FutureBuilder<List<AQIData>>(
        future: historicalData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          } else {
            final data = snapshot.data!;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data[index];
                return ListTile(
                  title: Text('AQI: ${item.aqi.toStringAsFixed(1)}'),
                  subtitle: Text('PM2.5: ${item.pm25.toStringAsFixed(1)} | PM10: ${item.pm10.toStringAsFixed(1)}'),
                  trailing: Text(item.time),
                );
              },
            );
          }
        },
      ),
    );
  }
}
