class SensorDataModel {
  final double nitrogen;
  final double phosphorus;
  final double potassium;
  final double temperature;
  final double humidity;
  final double soilMoisture;
  final DateTime timestamp;
  final String status;

  SensorDataModel({
    required this.nitrogen,
    required this.phosphorus,
    required this.potassium,
    required this.temperature,
    required this.humidity,
    required this.soilMoisture,
    required this.timestamp,
    required this.status,
  });

  factory SensorDataModel.fromJson(Map<String, dynamic> json) {
    return SensorDataModel(
      nitrogen: (json['nitrogen'] as num).toDouble(),
      phosphorus: (json['phosphorus'] as num).toDouble(),
      potassium: (json['potassium'] as num).toDouble(),
      temperature: (json['temperature'] as num).toDouble(),
      humidity: (json['humidity'] as num).toDouble(),
      soilMoisture: (json['soilMoisture'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nitrogen': nitrogen,
      'phosphorus': phosphorus,
      'potassium': potassium,
      'temperature': temperature,
      'humidity': humidity,
      'soilMoisture': soilMoisture,
      'timestamp': timestamp.toIso8601String(),
      'status': status,
    };
  }
}
