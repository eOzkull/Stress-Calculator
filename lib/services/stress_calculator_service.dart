import '../models/stress_result.dart';

class StressCalculatorService {
  /// Calculates stress level based on BP and Pulse Rate
  /// Uses a modified version of the Stress Index formula combining:
  /// - Blood Pressure Index (BPI)
  /// - Pulse Pressure
  /// - Heart Rate Reserve
  /// - Age factor adjustment
  static StressResult calculateStress({
    required int systolicBP,
    required int diastolicBP,
    required int pulseRate,
    int? age,
  }) {
    // Validate inputs
    if (systolicBP < 70 || systolicBP > 250) {
      throw ArgumentError('Systolic BP must be between 70 and 250');
    }
    if (diastolicBP < 40 || diastolicBP > 150) {
      throw ArgumentError('Diastolic BP must be between 40 and 150');
    }
    if (pulseRate < 40 || pulseRate > 200) {
      throw ArgumentError('Pulse rate must be between 40 and 200');
    }

    // Calculate Mean Arterial Pressure (MAP)
    final map = diastolicBP + ((systolicBP - diastolicBP) / 3);

    // Calculate Pulse Pressure (PP)
    final pulsePressure = systolicBP - diastolicBP;

    // Calculate Rate Pressure Product (RPP) - indicator of cardiac workload
    final rpp = systolicBP * pulseRate;

    // Normalization factors (based on healthy adult averages)
    const normalMAP = 93.0;
    const normalPulsePressure = 40.0;
    const normalRPP = 9600.0; // 120 * 80

    // Calculate deviations from normal (as ratios)
    final mapDeviation = (map / normalMAP).clamp(0.5, 2.0);
    final ppDeviation = (pulsePressure / normalPulsePressure).clamp(0.5, 2.0);
    final rppDeviation = (rpp / normalRPP).clamp(0.5, 3.0);

    // Heart rate zone analysis
    double hrFactor;
    if (pulseRate < 60) {
      hrFactor = 0.8; // Bradycardia (possibly athletic, but can indicate stress)
    } else if (pulseRate < 70) {
      hrFactor = 0.9;
    } else if (pulseRate < 80) {
      hrFactor = 1.0; // Normal
    } else if (pulseRate < 100) {
      hrFactor = 1.2; // Elevated
    } else {
      hrFactor = 1.5; // High
    }

    // Age adjustment (if provided)
    double ageFactor = 1.0;
    if (age != null) {
      if (age < 30) ageFactor = 1.1; // Younger people have more variable responses
      else if (age > 60) ageFactor = 0.9; // Older people may have blunted responses
    }

    // Calculate composite stress score (0-100 scale)
    // Formula: Weighted combination of cardiovascular indicators
    double stressScore = (
      (mapDeviation * 25) +           // MAP weight: 25%
      (ppDeviation * 20) +            // Pulse Pressure weight: 20%
      (rppDeviation * 35) +           // RPP weight: 35% (most indicative)
      (hrFactor * 20)                 // HR factor weight: 20%
    ) * ageFactor;

    // Normalize to 0-100 scale and clamp
    stressScore = ((stressScore - 80) * 1.25).clamp(0.0, 100.0);

    // Determine stress level and description
    final (level, description) = _categorizeStress(stressScore, pulseRate);

    return StressResult(
      stressScore: double.parse(stressScore.toStringAsFixed(1)),
      level: level,
      description: description,
      timestamp: DateTime.now(),
      systolicBP: systolicBP,
      diastolicBP: diastolicBP,
      pulseRate: pulseRate,
      age: age,
    );
  }

  static (StressLevel, String) _categorizeStress(double score, int pulse) {
    if (score <= 20) {
      return (
        StressLevel.relaxed,
        'Your cardiovascular markers indicate a relaxed state. Your body is in a good recovery mode.'
      );
    } else if (score <= 40) {
      return (
        StressLevel.mild,
        'Slight elevation detected. This is normal daily stress that can be managed with simple breathing exercises.'
      );
    } else if (score <= 60) {
      return (
        StressLevel.moderate,
        'Moderate stress levels detected. Your body is working harder than optimal. Consider taking a break.'
      );
    } else if (score <= 80) {
      return (
        StressLevel.high,
        'High stress indicators present. Your cardiovascular system is under significant load. Immediate relaxation recommended.'
      );
    } else {
      return (
        StressLevel.critical,
        'Critical stress levels! Your readings suggest acute stress response. Please practice immediate calming techniques and consider medical consultation if persistent.'
      );
    }
  }

  /// Get trend analysis comparing current result with previous
  static String getTrendAnalysis(StressResult current, StressResult? previous) {
    if (previous == null) return 'First measurement recorded. Keep tracking to see trends.';
    
    final difference = current.stressScore - previous.stressScore;
    final timeDiff = current.timestamp.difference(previous.timestamp);
    
    if (difference.abs() < 5) {
      return 'Your stress levels are stable compared to your last check ${timeDiff.inHours} hours ago.';
    } else if (difference < 0) {
      return 'Great! Your stress level decreased by ${difference.abs().toStringAsFixed(1)} points since last check.';
    } else {
      return 'Your stress level increased by ${difference.toStringAsFixed(1)} points. Consider taking a moment to relax.';
    }
  }
}