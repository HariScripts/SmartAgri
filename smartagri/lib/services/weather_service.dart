import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherService {
  // Fallback coordinates for common Indian states where the Geocoding API may fail to resolve
  static const Map<String, Map<String, dynamic>> _stateFallbacks = {
    'karnataka': { 'lat': 12.9716, 'lon': 77.5946, 'name': 'Bengaluru, Karnataka, India' },
    'punjab': { 'lat': 30.9010, 'lon': 75.8573, 'name': 'Ludhiana, Punjab, India' },
    'maharashtra': { 'lat': 19.0760, 'lon': 72.8777, 'name': 'Mumbai, Maharashtra, India' },
    'delhi': { 'lat': 28.6139, 'lon': 77.2090, 'name': 'New Delhi, Delhi, India' },
    'tamilnadu': { 'lat': 13.0827, 'lon': 80.2707, 'name': 'Chennai, Tamil Nadu, India' },
    'telangana': { 'lat': 17.3850, 'lon': 78.4867, 'name': 'Hyderabad, Telangana, India' },
    'andhra': { 'lat': 16.5062, 'lon': 80.6480, 'name': 'Vijayawada, Andhra Pradesh, India' },
    'rajasthan': { 'lat': 26.9124, 'lon': 75.7873, 'name': 'Jaipur, Rajasthan, India' },
    'gujarat': { 'lat': 23.0225, 'lon': 72.5714, 'name': 'Ahmedabad, Gujarat, India' },
    'uttarpradesh': { 'lat': 26.8467, 'lon': 80.9462, 'name': 'Lucknow, Uttar Pradesh, India' },
    'haryana': { 'lat': 30.7333, 'lon': 76.7794, 'name': 'Chandigarh, Haryana, India' },
    'bihar': { 'lat': 25.5941, 'lon': 85.1376, 'name': 'Patna, Bihar, India' },
    'westbengal': { 'lat': 22.5726, 'lon': 88.3639, 'name': 'Kolkata, West Bengal, India' },
    'kerala': { 'lat': 8.5241, 'lon': 76.9366, 'name': 'Trivandrum, Kerala, India' },
    'madhyapradesh': { 'lat': 23.2599, 'lon': 77.4126, 'name': 'Bhopal, Madhya Pradesh, India' }
  };

  static Future<WeatherModel> fetchWeatherForecast(String location) async {
    double lat = 15.3173;
    double lon = 75.7139;
    String displayName = location;

    // Normalizing location query string to check state fallback
    final normalized = location.toLowerCase().replaceAll(RegExp(r'[^a-z]'), '');
    Map<String, dynamic>? matchedFallback;

    // Check if the query is a pure state (e.g., "maharashtra", "maharashtraindia")
    bool isPureState = false;
    for (final key in _stateFallbacks.keys) {
      if (normalized == key || normalized == '${key}india') {
        matchedFallback = _stateFallbacks[key];
        isPureState = true;
        break;
      }
    }

    if (isPureState && matchedFallback != null) {
      lat = matchedFallback['lat'] as double;
      lon = matchedFallback['lon'] as double;
      displayName = matchedFallback['name'] as String;
    } else {
      bool geocodingSuccess = false;
      
      // Construct robust list of search candidates
      final List<String> searchCandidates = [];
      if (location.contains(',')) {
        final firstSegment = location.split(',')[0].trim();
        if (firstSegment.isNotEmpty) {
          searchCandidates.add(firstSegment);
        }
      }
      searchCandidates.add(location.trim());
      final words = location.trim().split(RegExp(r'\s+'));
      if (words.length > 1 && words[0].isNotEmpty) {
        searchCandidates.add(words[0]);
      }
      final uniqueCandidates = searchCandidates.toSet().toList();

      for (final candidate in uniqueCandidates) {
        try {
          final geoUrl = Uri.parse(
            'https://geocoding-api.open-meteo.com/v1/search?name=${Uri.encodeComponent(candidate)}&count=1&language=en&format=json'
          );
          final geoRes = await http.get(geoUrl).timeout(const Duration(seconds: 5));
          
          if (geoRes.statusCode == 200) {
            final geoData = jsonDecode(geoRes.body) as Map<String, dynamic>;
            final results = geoData['results'] as List<dynamic>?;
            
            if (results != null && results.isNotEmpty) {
              final first = results[0] as Map<String, dynamic>;
              lat = (first['latitude'] as num).toDouble();
              lon = (first['longitude'] as num).toDouble();
              
              final name = first['name'] as String? ?? '';
              final admin1 = first['admin1'] as String? ?? '';
              final country = first['country'] as String? ?? '';
              
              displayName = '$name${admin1.isNotEmpty ? ", $admin1" : ""}, $country';
              geocodingSuccess = true;
              break; // Success, exit candidate loop
            }
          }
        } catch (e) {
          print("Geocoding failed for candidate '$candidate': $e");
        }
      }

      // If geocoding failed or returned no results, search fallbacks by containment
      if (!geocodingSuccess) {
        for (final key in _stateFallbacks.keys) {
          if (normalized.contains(key)) {
            matchedFallback = _stateFallbacks[key];
            break;
          }
        }
        if (matchedFallback != null) {
          lat = matchedFallback['lat'] as double;
          lon = matchedFallback['lon'] as double;
          displayName = matchedFallback['name'] as String;
        }
      }
    }

    final weatherUrl = Uri.parse(
      'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&daily=precipitation_probability_max,precipitation_sum,temperature_2m_max&timezone=auto&current_weather=true'
    );
    
    final weatherRes = await http.get(weatherUrl).timeout(const Duration(seconds: 5));
    if (weatherRes.statusCode != 200) {
      throw Exception('Failed to fetch weather forecast');
    }

    final weatherData = jsonDecode(weatherRes.body) as Map<String, dynamic>;
    return WeatherModel.fromJson(
      weatherJson: weatherData,
      displayName: displayName,
    );
  }
}
