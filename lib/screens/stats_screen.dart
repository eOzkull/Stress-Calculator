import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../models/stress_result.dart';
import '../theme/app_theme.dart';
import 'result_screen.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  List<StressResult> _history = [];
  bool _isLoading = true;

  // Stats
  double _avgStress = 0;
  int _totalMeasurements = 0;
  double _minStress = 0;
  double _maxStress = 0;
  StressLevel? _mostCommonLevel;

  // Distribution
  Map<StressLevel, int> _levelDistribution = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString('stress_history');

    if (historyJson != null && historyJson.isNotEmpty) {
      final history = StressResult.decodeList(historyJson);
      setState(() {
        _history = history.reversed.toList(); // Newest first
        _totalMeasurements = history.length;

        if (history.isNotEmpty) {
          // Calculate average stress
          _avgStress =
              history.map((r) => r.stressScore).reduce((a, b) => a + b) /
                  history.length;

          // Find min and max
          _minStress =
              history.map((r) => r.stressScore).reduce((a, b) => a < b ? a : b);
          _maxStress =
              history.map((r) => r.stressScore).reduce((a, b) => a > b ? a : b);

          // Find most common level
          final levelCounts = <StressLevel, int>{};
          for (var result in history) {
            levelCounts[result.level] = (levelCounts[result.level] ?? 0) + 1;
          }
          _levelDistribution = levelCounts;
          _mostCommonLevel = levelCounts.entries
              .reduce((a, b) => a.value > b.value ? a : b)
              .key;
        }

        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _history.isEmpty
              ? _buildEmptyState(context)
              : CustomScrollView(
                  slivers: [
                    // App Bar
                    SliverAppBar(
                      expandedHeight: 120,
                      pinned: true,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: isDark
                                  ? [Color(0xFF1E1B4B), Color(0xFF312E81)]
                                  : [
                                      AppTheme.primaryColor,
                                      AppTheme.secondaryColor
                                    ],
                            ),
                          ),
                        ),
                        title: Text(
                          'Statistics',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        centerTitle: true,
                      ),
                      leading: IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),

                    // Content
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Summary Cards
                            _buildSummarySection(context),
                            const SizedBox(height: 24),

                            // Stress Trend Chart
                            Text(
                              'Stress Trend',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Your stress levels over time',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.6),
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildTrendChart(context),
                            const SizedBox(height: 32),

                            // Distribution Chart
                            Text(
                              'Stress Level Distribution',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Breakdown by stress category',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.6),
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildDistributionChart(context),
                            const SizedBox(height: 32),

                            // Recent Measurements
                            Text(
                              'Recent Measurements',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ..._history.take(10).map(
                                (result) => _buildHistoryItem(context, result)),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Statistics'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bar_chart_rounded,
              size: 80,
              color: theme.colorScheme.primary.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No Data Yet',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start measuring your stress levels\nto see your statistics here',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummarySection(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                context,
                icon: Icons.format_list_numbered,
                value: '$_totalMeasurements',
                label: 'Total Measurements',
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                context,
                icon: Icons.show_chart,
                value: '${_avgStress.toStringAsFixed(0)}',
                label: 'Average Score',
                color: _getStressColorForScore(_avgStress),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                context,
                icon: Icons.arrow_downward,
                value: '${_minStress.toStringAsFixed(0)}',
                label: 'Lowest Score',
                color: AppTheme.lowStressColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                context,
                icon: Icons.arrow_upward,
                value: '${_maxStress.toStringAsFixed(0)}',
                label: 'Highest Score',
                color: AppTheme.criticalStressColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    BuildContext context, {
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendChart(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (_history.length < 2) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: isDark ? Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            'Need at least 2 measurements for trend chart',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ),
      );
    }

    // Take last 20 data points for the chart
    final chartData = _history.take(20).toList().reversed.toList();

    return Container(
      height: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 25,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: isDark ? Color(0xFF334155) : Color(0xFFE2E8F0),
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              axisNameWidget: Text(
                'Stress Score',
                style: TextStyle(
                  color: isDark ? Color(0xFF94A3B8) : Color(0xFF64748B),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              axisNameSize: 24,
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                interval: 25,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: TextStyle(
                      color: isDark ? Color(0xFF94A3B8) : Color(0xFF64748B),
                      fontSize: 12,
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              axisNameWidget: Text(
                'Recent Measurements',
                style: TextStyle(
                  color: isDark ? Color(0xFF94A3B8) : Color(0xFF64748B),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              axisNameSize: 24,
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: (chartData.length - 1).toDouble(),
          minY: 0,
          maxY: 100,
          lineBarsData: [
            LineChartBarData(
              spots: chartData.asMap().entries.map((entry) {
                return FlSpot(entry.key.toDouble(), entry.value.stressScore);
              }).toList(),
              isCurved: true,
              curveSmoothness: 0.3,
              color: AppTheme.primaryColor,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: _getStressColorForScore(spot.y),
                    strokeWidth: 2,
                    strokeColor: Colors.white,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppTheme.primaryColor.withOpacity(0.3),
                    AppTheme.primaryColor.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  return LineTooltipItem(
                    'Score: ${spot.y.toStringAsFixed(0)}',
                    TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDistributionChart(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (_levelDistribution.isEmpty) {
      return SizedBox.shrink();
    }

    // Sort by stress level order
    final sortedEntries = StressLevel.values
        .where((level) => _levelDistribution.containsKey(level))
        .map((level) => MapEntry(level, _levelDistribution[level]!))
        .toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Chart - Responsive sizing
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 300;
              final content = [
                Expanded(
                  flex: isNarrow ? 0 : 3,
                  child: SizedBox(
                    height: 180,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 30,
                        sections: sortedEntries.map((entry) {
                          final percentage =
                              (entry.value / _totalMeasurements * 100);
                          return PieChartSectionData(
                            color: _getStressColor(entry.key),
                            value: entry.value.toDouble(),
                            title: percentage >= 10
                                ? '${percentage.toStringAsFixed(0)}%'
                                : '',
                            radius: 45,
                            titleStyle: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                if (!isNarrow) const SizedBox(width: 12),
                // Legend
                Expanded(
                  flex: isNarrow ? 0 : 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: sortedEntries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: _getStressColor(entry.key),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                '${_getLevelName(entry.key)} (${entry.value})',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontSize: 11,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ];

              if (isNarrow) {
                return Column(children: content);
              } else {
                return Row(children: content);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(BuildContext context, StressResult result) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final color = _getStressColor(result.level);
    final dateFormat = DateFormat('MMM d, yyyy • h:mm a');

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      color: isDark ? Color(0xFF1E293B) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              result.emoji,
              style: TextStyle(fontSize: 22),
            ),
          ),
        ),
        title: Text(
          result.name ?? result.levelText,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (result.name != null)
              Text(
                result.levelText,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: color.withOpacity(0.8),
                ),
              ),
            Text(
              dateFormat.format(result.timestamp),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.favorite, size: 12, color: Colors.grey),
                SizedBox(width: 4),
                Text(
                  '${result.systolicBP}/${result.diastolicBP}',
                  style: TextStyle(fontSize: 11),
                ),
                SizedBox(width: 12),
                Icon(Icons.monitor_heart, size: 12, color: Colors.grey),
                SizedBox(width: 4),
                Text(
                  '${result.pulseRate} BPM',
                  style: TextStyle(fontSize: 11),
                ),
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${result.stressScore.toStringAsFixed(0)}',
              style: theme.textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Score',
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 10,
                color: theme.colorScheme.onSurface.withOpacity(0.4),
              ),
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ResultScreen(result: result),
            ),
          );
        },
      ),
    );
  }

  Color _getStressColor(StressLevel level) {
    switch (level) {
      case StressLevel.relaxed:
        return AppTheme.lowStressColor;
      case StressLevel.mild:
        return Color(0xFF84CC16);
      case StressLevel.moderate:
        return AppTheme.moderateStressColor;
      case StressLevel.high:
        return AppTheme.highStressColor;
      case StressLevel.critical:
        return AppTheme.criticalStressColor;
    }
  }

  Color _getStressColorForScore(double score) {
    if (score <= 20) return AppTheme.lowStressColor;
    if (score <= 40) return Color(0xFF84CC16);
    if (score <= 60) return AppTheme.moderateStressColor;
    if (score <= 80) return AppTheme.highStressColor;
    return AppTheme.criticalStressColor;
  }

  String _getLevelName(StressLevel level) {
    switch (level) {
      case StressLevel.relaxed:
        return 'Relaxed';
      case StressLevel.mild:
        return 'Mild';
      case StressLevel.moderate:
        return 'Moderate';
      case StressLevel.high:
        return 'High';
      case StressLevel.critical:
        return 'Critical';
    }
  }
}
