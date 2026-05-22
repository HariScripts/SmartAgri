class WeatherModel {
  final double currentTemp;
  final double windSpeed;
  final String outlook; // 'wet', 'dry', 'normal'
  final double maxRainProbability;
  final double totalRainSum;
  final String displayName;
  final List<double> dailyTemps;
  final List<double> dailyRainProbs;

  WeatherModel({
    required this.currentTemp,
    required this.windSpeed,
    required this.outlook,
    required this.maxRainProbability,
    required this.totalRainSum,
    required this.displayName,
    required this.dailyTemps,
    required this.dailyRainProbs,
  });

  factory WeatherModel.fromJson({
    required Map<String, dynamic> weatherJson,
    required String displayName,
  }) {
    final current = weatherJson['current_weather'] as Map<String, dynamic>? ?? {};
    final daily = weatherJson['daily'] as Map<String, dynamic>? ?? {};

    final currentTemp = (current['temperature'] as num?)?.toDouble() ?? 0.0;
    final windSpeed = (current['windspeed'] as num?)?.toDouble() ?? 0.0;

    final rainProbabilitiesList = daily['precipitation_probability_max'] as List<dynamic>? ?? [];
    final rainProbabilities = rainProbabilitiesList.map((e) => (e as num?)?.toDouble() ?? 0.0).toList();

    final rainSumsList = daily['precipitation_sum'] as List<dynamic>? ?? [];
    final rainSums = rainSumsList.map((e) => (e as num?)?.toDouble() ?? 0.0).toList();

    final dailyTempsList = daily['temperature_2m_max'] as List<dynamic>? ?? [];
    final dailyTemps = dailyTempsList.map((e) => (e as num?)?.toDouble() ?? 0.0).toList();

    double maxRainProbability = 0.0;
    if (rainProbabilities.isNotEmpty) {
      maxRainProbability = rainProbabilities.reduce((a, b) => a > b ? a : b);
    }

    double totalRainSum = 0.0;
    if (rainSums.isNotEmpty) {
      totalRainSum = rainSums.reduce((a, b) => a + b);
    }

    String outlook = 'normal';
    if (maxRainProbability >= 60.0 || totalRainSum >= 20.0) {
      outlook = 'wet';
    } else if (maxRainProbability < 20.0 && totalRainSum < 5.0) {
      outlook = 'dry';
    }

    return WeatherModel(
      currentTemp: currentTemp,
      windSpeed: windSpeed,
      outlook: outlook,
      maxRainProbability: maxRainProbability,
      totalRainSum: totalRainSum,
      displayName: displayName,
      dailyTemps: dailyTemps,
      dailyRainProbs: rainProbabilities,
    );
  }
}
