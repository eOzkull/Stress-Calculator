import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/stress_result.dart';
import '../models/recommendation.dart';
import '../services/recommendation_engine.dart';
import '../services/stress_calculator_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResultScreen extends StatefulWidget {
  final StressResult result;

  const ResultScreen({super.key, required this.result});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late List<Recommendation> _recommendations;
  StressResult? _previousResult;

  @override
  void initState() {
    super.initState();
    _recommendations = RecommendationEngine.getRecommendations(widget.result);
    _loadHistory();
    _saveResult();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString('stress_history');
    if (historyJson != null) {
      final history = StressResult.decodeList(historyJson);
      if (history.isNotEmpty) {
        setState(() {
          _previousResult = history.last;
        });
      }
    }
  }

  Future<void> _saveResult() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString('stress_history');
    List<StressResult> history = [];
    if (historyJson != null) {
      history = StressResult.decodeList(historyJson);
    }
    history.add(widget.result);
    // Keep only last 50 records
    if (history.length > 50) {
      history = history.sublist(history.length - 50);
    }
    await prefs.setString('stress_history', StressResult.encodeList(history));
  }

  Color _getStressColor() {
    switch (widget.result.level) {
      case StressLevel.relaxed:
        return const Color(0xFF2A9D8F);
      case StressLevel.mild:
        return const Color(0xFF7FB069);
      case StressLevel.moderate:
        return const Color(0xFFE9C46A);
      case StressLevel.high:
        return const Color(0xFFF4A261);
      case StressLevel.critical:
        return const Color(0xFFE76F51);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final stressColor = _getStressColor();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      stressColor,
                      stressColor.withOpacity(0.8),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.result.emoji,
                        style: const TextStyle(fontSize: 60),
                      )
                          .animate()
                          .scale(duration: 500.ms, curve: Curves.easeOutBack),
                      const SizedBox(height: 8),
                      if (widget.result.name != null)
                        Text(
                          widget.result.name!,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ).animate().fadeIn(delay: 100.ms),
                      Text(
                        widget.result.levelText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ).animate().fadeIn(delay: 200.ms),
                    ],
                  ),
                ),
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () =>
                  Navigator.of(context).popUntil((route) => route.isFirst),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Score Card
                  _buildScoreCard(context, stressColor),
                  const SizedBox(height: 24),

                  // Vitals Summary
                  _buildVitalsCard(context),
                  const SizedBox(height: 24),

                  // Description
                  Text(
                    'Analysis',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.result.description,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      height: 1.6,
                      color: theme.colorScheme.onSurface.withOpacity(0.8),
                    ),
                  ),

                  if (_previousResult != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.trending_down,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              StressCalculatorService.getTrendAnalysis(
                                widget.result,
                                _previousResult,
                              ),
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 32),

                  // Recommendations
                  Text(
                    'Recommended Actions',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Based on your stress level, here are personalized techniques to help you feel better:',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Recommendation List
                  ..._recommendations.asMap().entries.map((entry) {
                    return _buildRecommendationCard(
                      context,
                      entry.value,
                      entry.key,
                    );
                  }),

                  const SizedBox(height: 32),

                  // Disclaimer
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.medical_services_outlined,
                          size: 20,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'This is an estimation based on cardiovascular markers. Consult a healthcare provider for medical advice.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreCard(BuildContext context, Color color) {
    return Card(
      elevation: 4,
      shadowColor: color.withOpacity(0.4),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              'Stress Score',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6),
                  ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  widget.result.stressScore.toStringAsFixed(0),
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontSize: 56,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                ),
                Text(
                  '/100',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.4),
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: widget.result.stressScore / 100,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 10,
              ),
            ),
          ],
        ),
      ),
    ).animate().scale(duration: 400.ms, curve: Curves.easeOut);
  }

  Widget _buildVitalsCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // First row: BP and Pulse
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: _buildVitalItem(
                    context,
                    icon: Icons.favorite,
                    label: 'Blood Pressure',
                    value:
                        '${widget.result.systolicBP}/${widget.result.diastolicBP}',
                    unit: 'mmHg',
                  ),
                ),
                Container(
                  height: 50,
                  width: 1,
                  color: Theme.of(context).dividerColor,
                ),
                Expanded(
                  child: _buildVitalItem(
                    context,
                    icon: Icons.monitor_heart,
                    label: 'Pulse Rate',
                    value: '${widget.result.pulseRate}',
                    unit: 'BPM',
                  ),
                ),
              ],
            ),
            // Second row: Age (if available)
            if (widget.result.age != null) ...[
              const SizedBox(height: 12),
              Container(
                height: 1,
                width: double.infinity,
                color: Theme.of(context).dividerColor,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: _buildVitalItem(
                      context,
                      icon: Icons.cake,
                      label: 'Age',
                      value: '${widget.result.age}',
                      unit: 'years',
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildVitalItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required String unit,
  }) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          unit,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 11,
              ),
        ),
      ],
    );
  }

  Widget _buildRecommendationCard(
    BuildContext context,
    Recommendation rec,
    int index,
  ) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: _getTypeColor(rec.type).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              rec.iconAsset,
              style: const TextStyle(fontSize: 24),
            ),
          ),
        ),
        title: Text(
          rec.title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              rec.typeLabel,
              style: theme.textTheme.bodySmall?.copyWith(
                color: _getTypeColor(rec.type),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildTag(
                  context,
                  '-${rec.stressReductionPercent.toStringAsFixed(0)}% stress',
                  Colors.green,
                ),
                _buildTag(
                  context,
                  '${rec.durationMinutes} min',
                  Colors.blue,
                ),
                _buildTag(
                  context,
                  rec.difficulty,
                  Colors.orange,
                ),
              ],
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                const SizedBox(height: 8),
                Text(
                  rec.description,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                Text(
                  'How to do it:',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...rec.steps.asMap().entries.map((step) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${step.key + 1}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            step.value,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.science,
                        size: 16,
                        color: Colors.blue.shade700,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          rec.scienceBehind,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.blue.shade700,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: (100 * index).ms).slideY(begin: 0.2, end: 0);
  }

  Widget _buildTag(BuildContext context, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Color _getTypeColor(RecommendationType type) {
    switch (type) {
      case RecommendationType.breathing:
        return Colors.blue;
      case RecommendationType.meditation:
        return Colors.purple;
      case RecommendationType.physical:
        return Colors.orange;
      case RecommendationType.sensory:
        return Colors.teal;
      case RecommendationType.cognitive:
        return Colors.indigo;
      case RecommendationType.social:
        return Colors.pink;
    }
  }
}
