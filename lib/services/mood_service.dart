import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class MoodLog {
  final String emoji;
  final String label;
  final DateTime timestamp;

  MoodLog({
    required this.emoji,
    required this.label,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'emoji': emoji,
        'label': label,
        'timestamp': timestamp.toIso8601String(),
      };

  factory MoodLog.fromJson(Map<String, dynamic> json) => MoodLog(
        emoji: json['emoji'],
        label: json['label'],
        timestamp: DateTime.parse(json['timestamp']),
      );
}

class MoodService {
  static const String _storageKey = 'mood_history';

  static Future<void> logMood(String emoji, String label) async {
    final prefs = await SharedPreferences.getInstance();
    final logs = await getMoodHistory();

    // Add new log
    logs.add(MoodLog(
      emoji: emoji,
      label: label,
      timestamp: DateTime.now(),
    ));

    // Keep only last 30 days of logs
    if (logs.length > 30) {
      logs.removeAt(0);
    }

    final jsonString = jsonEncode(logs.map((e) => e.toJson()).toList());
    await prefs.setString(_storageKey, jsonString);
  }

  static Future<List<MoodLog>> getMoodHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);

    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((e) => MoodLog.fromJson(e)).toList();
  }

  static Future<MoodLog?> getLastMood() async {
    final logs = await getMoodHistory();
    if (logs.isEmpty) return null;
    return logs.last;
  }
}
