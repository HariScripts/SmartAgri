class DiseaseResultModel {
  final String cropName;
  final String diseaseName;
  final double confidence;
  final double cureProbability;
  final String description;
  final List<String> affectedParts;
  final String severity;
  final List<String> remedies;
  final List<String> preventionMethods;
  final List<String> treatmentSteps;
  final bool isHealthy;

  DiseaseResultModel({
    required this.cropName,
    required this.diseaseName,
    required this.confidence,
    required this.cureProbability,
    required this.description,
    required this.affectedParts,
    required this.severity,
    required this.remedies,
    required this.preventionMethods,
    required this.treatmentSteps,
    required this.isHealthy,
  });

  factory DiseaseResultModel.fromJson(Map<String, dynamic> json) {
    return DiseaseResultModel(
      cropName: json['crop_name'] as String? ?? 'Unknown Crop',
      diseaseName: json['disease_name'] as String? ?? 'Unknown Disease',
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
      cureProbability: (json['cure_probability'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] as String? ?? '',
      affectedParts: (json['affected_parts'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      severity: json['severity'] as String? ?? 'Unknown',
      remedies: (json['remedies'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      preventionMethods: (json['prevention_methods'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      treatmentSteps: (json['treatment_steps'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      isHealthy: json['is_healthy'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'crop_name': cropName,
      'disease_name': diseaseName,
      'confidence': confidence,
      'cure_probability': cureProbability,
      'description': description,
      'affected_parts': affectedParts,
      'severity': severity,
      'remedies': remedies,
      'prevention_methods': preventionMethods,
      'treatment_steps': treatmentSteps,
      'is_healthy': isHealthy,
    };
  }
}
