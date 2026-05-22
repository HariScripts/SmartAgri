class CropModel {
  final String cropName;
  final String season;
  final String soilType;
  final double matchPercentage;
  final double healthPercentage;
  final int daysToHarvest;
  final double minTemp;
  final double maxTemp;
  final String waterNeed;
  final String fertilizerDetails;
  final double diseaseRisk;
  final DateTime selectedAt;

  CropModel({
    required this.cropName,
    required this.season,
    required this.soilType,
    required this.matchPercentage,
    required this.healthPercentage,
    required this.daysToHarvest,
    required this.minTemp,
    required this.maxTemp,
    required this.waterNeed,
    required this.fertilizerDetails,
    required this.diseaseRisk,
    required this.selectedAt,
  });

  factory CropModel.fromJson(Map<String, dynamic> json) {
    return CropModel(
      cropName: json['cropName'] as String,
      season: json['season'] as String,
      soilType: json['soilType'] as String,
      matchPercentage: (json['matchPercentage'] as num).toDouble(),
      healthPercentage: (json['healthPercentage'] as num).toDouble(),
      daysToHarvest: json['daysToHarvest'] as int,
      minTemp: (json['minTemp'] as num).toDouble(),
      maxTemp: (json['maxTemp'] as num).toDouble(),
      waterNeed: json['waterNeed'] as String,
      fertilizerDetails: json['fertilizerDetails'] as String,
      diseaseRisk: (json['diseaseRisk'] as num).toDouble(),
      selectedAt: DateTime.parse(json['selectedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cropName': cropName,
      'season': season,
      'soilType': soilType,
      'matchPercentage': matchPercentage,
      'healthPercentage': healthPercentage,
      'daysToHarvest': daysToHarvest,
      'minTemp': minTemp,
      'maxTemp': maxTemp,
      'waterNeed': waterNeed,
      'fertilizerDetails': fertilizerDetails,
      'diseaseRisk': diseaseRisk,
      'selectedAt': selectedAt.toIso8601String(),
    };
  }
}
