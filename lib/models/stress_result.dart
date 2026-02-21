import 'dart:convert';

enum StressLevel {
  relaxed,
  mild,
  moderate,
  high,
  critical,
}

class StressResult {
  final double stressScore;
  final StressLevel level;
  final String description;
  final DateTime timestamp;
  final int systolicBP;
  final int diastolicBP;
  final int pulseRate;
  final int? age;

  StressResult({
    required this.stressScore,
    required this.level,
    required this.description,
    required this.timestamp,
    required this.systolicBP,
    required this.diastolicBP,
    required this.pulseRate,
    this.age,
  });

  String get levelText {
    switch (level) {
      case StressLevel.relaxed:
        return 'Relaxed';
      case StressLevel.mild:
        return 'Mild Stress';
      case StressLevel.moderate:
        return 'Moderate Stress';
      case StressLevel.high:
        return 'High Stress';
      case StressLevel.critical:
        return 'Critical Stress';
    }
  }

  String get emoji {
    switch (level) {
      case StressLevel.relaxed:
        return '😌';
      case StressLevel.mild:
        return '🙂';
      case StressLevel.moderate:
        return '😰';
      case StressLevel.high:
        return '😫';
      case StressLevel.critical:
        return '🚨';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'stressScore': stressScore,
      'level': level.index,
      'description': description,
      'timestamp': timestamp.toIso8601String(),
      'systolicBP': systolicBP,
      'diastolicBP': diastolicBP,
      'pulseRate': pulseRate,
      'age': age,
    };
  }

  factory StressResult.fromJson(Map<String, dynamic> json) {
    return StressResult(
      stressScore: json['stressScore'],
      level: StressLevel.values[json['level']],
      description: json['description'],
      timestamp: DateTime.parse(json['timestamp']),
      systolicBP: json['systolicBP'],
      diastolicBP: json['diastolicBP'],
      pulseRate: json['pulseRate'],
      age: json['age'],
    );
  }

  static String encodeList(List<StressResult> results) {
    return jsonEncode(results.map((r) => r.toJson()).toList());
  }

  static List<StressResult> decodeList(String jsonString) {
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => StressResult.fromJson(json)).toList();
  }
}