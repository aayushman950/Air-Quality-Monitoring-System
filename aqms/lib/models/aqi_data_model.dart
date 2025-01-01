class AQIData {
  final String time;
  final double aqi;
  final double pm25;
  final double pm10;

  AQIData({required this.time, required this.aqi, required this.pm25, required this.pm10});

  factory AQIData.fromJson(Map<String, dynamic> json) {
    return AQIData(
      time: json['time'],
      aqi: json['AQI'],
      pm25: json['PM25'],
      pm10: json['PM10'],
    );
  }
}
