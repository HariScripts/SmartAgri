import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';

class WeatherProvider extends ChangeNotifier {
  WeatherModel? _weatherData;
  bool _isLoading = false;
  String? _error;

  WeatherModel? get weatherData => _weatherData;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchWeather(String location) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await WeatherService.fetchWeatherForecast(location);
      _weatherData = data;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Could not load weather forecast. Please check your internet connection.';
      _isLoading = false;
      _weatherData = null;
      notifyListeners();
    }
  }

  void reset() {
    _weatherData = null;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}
