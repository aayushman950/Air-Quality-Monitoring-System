class AirQualityData {
  final String time;
  final String field;
  final double value;
  final String location;

  AirQualityData({
    required this.time,
    required this.field,
    required this.value,
    required this.location,
  });

  factory AirQualityData.fromJson(Map<String, dynamic> json) {
    return AirQualityData(
      time: json['time'],
      field: json['field'],
      value: (json['value'] as num).toDouble(),
      location: json['location'],
    );
  }
}
