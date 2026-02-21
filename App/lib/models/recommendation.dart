enum RecommendationType {
  breathing,
  meditation,
  physical,
  sensory,
  cognitive,
  social,
}

class Recommendation {
  final String id;
  final String title;
  final String description;
  final RecommendationType type;
  final double stressReductionPercent;
  final int durationMinutes;
  final String difficulty;
  final String? videoUrl;
  final String? articleUrl;
  final List<String> steps;
  final String scienceBehind;

  Recommendation({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.stressReductionPercent,
    required this.durationMinutes,
    required this.difficulty,
    this.videoUrl,
    this.articleUrl,
    required this.steps,
    required this.scienceBehind,
  });

  String get typeLabel {
    switch (type) {
      case RecommendationType.breathing:
        return 'Breathing Exercise';
      case RecommendationType.meditation:
        return 'Meditation';
      case RecommendationType.physical:
        return 'Physical Activity';
      case RecommendationType.sensory:
        return 'Sensory Relief';
      case RecommendationType.cognitive:
        return 'Cognitive Technique';
      case RecommendationType.social:
        return 'Social Connection';
    }
  }

  String get iconAsset {
    switch (type) {
      case RecommendationType.breathing:
        return '🫁';
      case RecommendationType.meditation:
        return '🧘';
      case RecommendationType.physical:
        return '🏃';
      case RecommendationType.sensory:
        return '🎵';
      case RecommendationType.cognitive:
        return '🧠';
      case RecommendationType.social:
        return '👥';
    }
  }
}