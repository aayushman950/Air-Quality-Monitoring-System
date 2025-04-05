import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PredictPage extends StatefulWidget {
  const PredictPage({super.key});

  @override
  _PredictPageState createState() => _PredictPageState();
}

class _PredictPageState extends State<PredictPage> {
  late Future<List<Map<String, dynamic>>> predictedData;

  @override
  void initState() {
    super.initState();
    predictedData = fetchPredictedData();
  }

  Future<List<Map<String, dynamic>>> fetchPredictedData() async {
    final response = await http.get(
      Uri.parse(
          'https://mr14920914789139185.pythonanywhere.com/predict?from_date=2025-03-07%2000:00:00&to_date=2025-03-14%20%2000:00:00'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      List<Map<String, dynamic>> result = [];

      data.forEach((key, value) {
        double pm25 = value['yhat'];
        int aqi = calculatePm25Aqi(pm25);
        result.add({
          'date': DateTime.parse(value['ds']),
          'pm25': pm25,
          'aqi': aqi,
        });
      });

      return result;
    } else {
      throw Exception('Failed to load predicted data');
    }
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
        return ((bp['I_hi'] - bp['I_lo']) /
                    (bp['C_hi'] - bp['C_lo']) *
                    (concentration - bp['C_lo']) +
                bp['I_lo'])
            .round();
      }
    }
    return -1; // Invalid AQI if out of range
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Predicted AQI',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: predictedData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: Text(
                      item['date'].toString().split(' ')[0],
                      style: const TextStyle(fontSize: 24),
                    ),
                    trailing: Text(
                      '${item['aqi']}',
                      style: TextStyle(
                        fontSize: 32,
                        color:
                            getAqiColor(item['aqi']), // Dynamically set color
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}

Color getAqiColor(int aqi) {
  if (aqi <= 50) {
    return Colors.green; // Good
  } else if (aqi <= 100) {
    return Colors.yellow; // Moderate
  } else if (aqi <= 150) {
    return Colors.orange; // Unhealthy for Sensitive Groups
  } else if (aqi <= 200) {
    return Colors.red; // Unhealthy
  } else if (aqi <= 300) {
    return Colors.purple; // Very Unhealthy
  } else {
    return Colors.red.shade900; // Hazardous
  }
}
