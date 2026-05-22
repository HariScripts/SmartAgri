import 'crop_model.dart';

class FarmModel {
  final String id;
  final String farmName;
  final String location;
  final String userId;
  final DateTime createdAt;
  final CropModel? activeCrop;
  final List<CropHistoryModel> cropHistory;

  FarmModel({
    required this.id,
    required this.farmName,
    required this.location,
    required this.userId,
    required this.createdAt,
    this.activeCrop,
    this.cropHistory = const [],
  });

  factory FarmModel.fromJson(Map<String, dynamic> json) {
    return FarmModel(
      id: json['id'] as String,
      farmName: json['farmName'] as String,
      location: json['location'] as String,
      userId: json['userId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      activeCrop: json['activeCrop'] != null ? CropModel.fromJson(json['activeCrop'] as Map<String, dynamic>) : null,
      cropHistory: (json['cropHistory'] as List<dynamic>?)?.map((e) => CropHistoryModel.fromJson(e as Map<String, dynamic>)).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'farmName': farmName,
      'location': location,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      'activeCrop': activeCrop?.toJson(),
      'cropHistory': cropHistory.map((e) => e.toJson()).toList(),
    };
  }

  FarmModel copyWith({
    String? farmName,
    String? location,
    CropModel? activeCrop,
    List<CropHistoryModel>? cropHistory,
  }) {
    return FarmModel(
      id: id,
      farmName: farmName ?? this.farmName,
      location: location ?? this.location,
      userId: userId,
      createdAt: createdAt,
      activeCrop: activeCrop ?? this.activeCrop,
      cropHistory: cropHistory ?? this.cropHistory,
    );
  }
}

class CropHistoryModel {
  final String cropName;
  final int year;
  final double yieldPercentage;
  final List<double> healthData;
  final List<String> mistakes;

  CropHistoryModel({
    required this.cropName,
    required this.year,
    required this.yieldPercentage,
    required this.healthData,
    required this.mistakes,
  });

  factory CropHistoryModel.fromJson(Map<String, dynamic> json) {
    return CropHistoryModel(
      cropName: json['cropName'] as String,
      year: json['year'] as int,
      yieldPercentage: (json['yieldPercentage'] as num).toDouble(),
      healthData: (json['healthData'] as List<dynamic>?)?.map((e) => (e as num).toDouble()).toList() ?? [],
      mistakes: (json['mistakes'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cropName': cropName,
      'year': year,
      'yieldPercentage': yieldPercentage,
      'healthData': healthData,
      'mistakes': mistakes,
    };
  }
}
