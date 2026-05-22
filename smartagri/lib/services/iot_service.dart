import 'dart:async';
import 'dart:math';
import '../models/sensor_data_model.dart';
import '../models/notification_model.dart';
import '../providers/sensor_provider.dart';
import '../providers/notification_provider.dart';
import 'package:uuid/uuid.dart';

class IoTService {
  final SensorProvider sensorProvider;
  final NotificationProvider notificationProvider;
  
  IoTService({
    required this.sensorProvider,
    required this.notificationProvider,
  });

  // Mock thresholds from Python backend
  final Map<String, Map<String, List<double>>> _thresholds = {
    "Rice": {"N": [80, 120], "P": [40, 60], "K": [40, 60], "temp": [20, 35], "hum": [80, 90], "moist": [70, 80]},
    "Wheat": {"N": [100, 120], "P": [60, 80], "K": [40, 60], "temp": [15, 25], "hum": [50, 70], "moist": [50, 60]},
    "Sugarcane": {"N": [150, 200], "P": [60, 80], "K": [80, 100], "temp": [25, 35], "hum": [70, 85], "moist": [60, 75]},
  };

  SensorDataModel simulateRealIoTData(String cropName) {
    final thresholds = _thresholds[cropName] ?? _thresholds["Rice"]!;
    final random = Random();

    double simulateValue(List<double> range) {
      final mid = (range[0] + range[1]) / 2;
      double variation = (range[1] - range[0]) * 0.2;
      
      // 20% chance to go out of bounds
      if (random.nextDouble() < 0.2) {
        variation *= 2.5;
      }
      
      double value = mid - variation + (random.nextDouble() * variation * 2);
      return double.parse(value.toStringAsFixed(2));
    }

    return SensorDataModel(
      nitrogen: simulateValue(thresholds["N"]!),
      phosphorus: simulateValue(thresholds["P"]!),
      potassium: simulateValue(thresholds["K"]!),
      temperature: simulateValue(thresholds["temp"]!),
      humidity: simulateValue(thresholds["hum"]!),
      soilMoisture: simulateValue(thresholds["moist"]!),
      timestamp: DateTime.now(),
      status: 'Active',
    );
  }

  void checkThresholdsAndAlert(String farmId, String cropName, SensorDataModel data) {
    final thresholds = _thresholds[cropName] ?? _thresholds["Rice"]!;
    
    void checkAndAlert(String paramName, double value, List<double> range, String remedy) {
      if (value < range[0]) {
        _createAlert(farmId, 'Low $paramName detected (${value}). Minimum required is ${range[0]}. $remedy');
      } else if (value > range[1]) {
        _createAlert(farmId, 'High $paramName detected (${value}). Maximum allowed is ${range[1]}. Reduce application.');
      }
    }

    checkAndAlert('Nitrogen', data.nitrogen, thresholds["N"]!, 'Apply Urea immediately.');
    checkAndAlert('Phosphorus', data.phosphorus, thresholds["P"]!, 'Apply DAP.');
    checkAndAlert('Soil Moisture', data.soilMoisture, thresholds["moist"]!, 'Irrigate the field immediately.');
    checkAndAlert('Temperature', data.temperature, thresholds["temp"]!, 'Ensure adequate shading/watering.');
  }

  void _createAlert(String farmId, String message) {
    final alert = NotificationModel(
      id: const Uuid().v4(),
      message: message,
      type: 'alert',
      farmId: farmId,
      timestamp: DateTime.now(),
    );
    // Add alert to provider so it updates the UI and triggers system local notifications
    notificationProvider.addNotification(alert);
    print("ALERT GENERATED: $message");
  }
}
