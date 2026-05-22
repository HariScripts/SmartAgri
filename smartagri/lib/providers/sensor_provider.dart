import 'package:flutter/material.dart';
import '../models/sensor_data_model.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SensorProvider extends ChangeNotifier {
  final Map<String, SensorDataModel> _farmReadings = {};
  String? _activeFarmId;
  String? _activeCropName;
  Timer? _pollingTimer;
  bool _isLoading = false;

  SensorDataModel? get lastReading => _activeFarmId != null ? _farmReadings[_activeFarmId] : null;
  bool get isLoading => _isLoading;

  void startAutoRefresh(String farmId, String cropName) {
    _activeFarmId = farmId;
    _activeCropName = cropName;
    _fetchData(); // Fetch immediately
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 15), (timer) {
      _fetchData();
    });
  }

  void stopAutoRefresh() {
    _pollingTimer?.cancel();
  }

  void updateSensorData(String farmId, SensorDataModel data) {
    _farmReadings[farmId] = data;
    notifyListeners();

    // Sync saved telemetry to Flask backend database
    final url = Uri.parse('https://purple-banks-show.loca.lt/api/sensor-data');
    http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Bypass-Tunnel-Reminder': 'true',
      },
      body: jsonEncode({
        'farm_id': farmId,
        'N': data.nitrogen,
        'P': data.phosphorus,
        'K': data.potassium,
        'temperature': data.temperature,
        'humidity': data.humidity,
        'moisture': data.soilMoisture,
        'soil_type': _activeCropName ?? 'loamy',
      }),
    ).then((response) {
      if (response.statusCode == 200) {
        debugPrint("Telemetry successfully synced and saved to Flask SQLite Database.");
      }
    }).catchError((e) {
      debugPrint("Telemetry local-only (Flask server offline).");
    });
  }

  Future<void> _fetchData() async {
    if (_activeFarmId == null) return;
    _isLoading = true;
    notifyListeners();

    try {
      // 1. Attempt to fetch real sensor data from Python Flask backend
      final url = Uri.parse('https://purple-banks-show.loca.lt/api/get-sensor-data?farm_id=$_activeFarmId&soil=${_activeCropName?.toLowerCase() ?? "loamy"}');
      final response = await http.get(
        url,
        headers: {
          'Bypass-Tunnel-Reminder': 'true',
        },
      ).timeout(const Duration(seconds: 2));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success'] == true && jsonResponse['data'] != null) {
          final d = jsonResponse['data'];
          _farmReadings[_activeFarmId!] = SensorDataModel(
            nitrogen: (d['N'] as num).toDouble(),
            phosphorus: (d['P'] as num).toDouble(),
            potassium: (d['K'] as num).toDouble(),
            temperature: (d['temperature'] as num).toDouble(),
            humidity: (d['humidity'] as num).toDouble(),
            soilMoisture: (d['moisture'] as num).toDouble(),
            timestamp: DateTime.parse(d['timestamp'] ?? DateTime.now().toIso8601String()),
            status: 'Normal',
          );
          _isLoading = false;
          notifyListeners();
          return;
        }
      }
    } catch (e) {
      debugPrint("Flask API sensor fetch offline, using mock telemetry fallback: $e");
    }
    
    // 2. Initialize with a mock sensor state if not already set!
    if (!_farmReadings.containsKey(_activeFarmId)) {
      // Use the hashCode of activeFarmId to deterministically choose a unique issue!
      final int seed = _activeFarmId!.hashCode;
      final int issueType = seed.abs() % 5;
      
      double nitrogen = 95.0;
      double phosphorus = 55.0;
      double potassium = 55.0;
      double temperature = 28.5;
      double humidity = 75.0;
      double soilMoisture = 75.0;
      String status = 'Normal';

      if (issueType == 0) {
        nitrogen = 45.0; // Low Nitrogen
        status = 'Low Nitrogen Alert';
      } else if (issueType == 1) {
        soilMoisture = 35.0; // Low Soil Moisture
        status = 'Low Soil Moisture Alert';
      } else if (issueType == 2) {
        phosphorus = 15.0; // Low Phosphorus
        status = 'Low Phosphorus Alert';
      } else if (issueType == 3) {
        potassium = 15.0; // Low Potassium
        status = 'Low Potassium Alert';
      } else {
        humidity = 35.0; // Low Humidity
        status = 'Low Humidity Alert';
      }

      _farmReadings[_activeFarmId!] = SensorDataModel(
        nitrogen: nitrogen,
        phosphorus: phosphorus,
        potassium: potassium,
        temperature: temperature,
        humidity: humidity,
        soilMoisture: soilMoisture,
        timestamp: DateTime.now(),
        status: status,
      );
    }

    _isLoading = false;
    notifyListeners();
  }

  void setOffline() {
    if (_activeFarmId != null) {
      _farmReadings.remove(_activeFarmId);
      notifyListeners();
    }
  }

  void setLive(String cropName) {
    if (_activeFarmId != null) {
      _activeCropName = cropName;
      _fetchData(); // Trigger direct live fetch from Flask backend!
    }
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }
}
