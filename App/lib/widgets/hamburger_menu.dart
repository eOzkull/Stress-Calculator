import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../models/stress_result.dart';
import '../screens/stats_screen.dart';
import '../screens/history_screen.dart';

class HamburgerMenu extends StatefulWidget {
  final Widget? child;
  
  const HamburgerMenu({super.key, this.child});

  @override
  State<HamburgerMenu> createState() => HamburgerMenuState();
}

class HamburgerMenuState extends State<HamburgerMenu> {
  List<StressResult> _history = [];
  bool _isLoading = true;
  
  // Stats
  double _avgStress = 0;
  int _totalMeasurements = 0;
  double _minStress = 0;
  double _maxStress = 0;
  StressLevel? _mostCommonLevel;

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
        _history = history;
        _totalMeasurements = history.length;
        
        if (history.isNotEmpty) {
          // Calculate average stress
          _avgStress = history.map((r) => r.stressScore).reduce((a, b) => a + b) / history.length;
          
          // Find min and max
          _minStress = history.map((r) => r.stressScore).reduce((a, b) => a < b ? a : b);
          _maxStress = history.map((r) => r.stressScore).reduce((a, b) => a > b ? a : b);
          
          // Find most common level
          final levelCounts = <StressLevel, int>{};
          for (var result in history) {
            levelCounts[result.level] = (levelCounts[result.level] ?? 0) + 1;
          }
          _mostCommonLevel = levelCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
        }
        
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  void open() {
    Scaffold.of(context).openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child ?? const SizedBox.shrink();
  }

  Widget buildDrawer(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Drawer(
      backgroundColor: isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight,
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark 
                      ? [Color(0xFF1E1B4B), Color(0xFF312E81)]
                      : [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      Icons.favorite_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Stress Calculator',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Track & Improve Your Wellbeing',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            
            // Stats Overview
            if (!_isLoading && _history.isNotEmpty)
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [Color(0xFF334155), Color(0xFF1E293B)]
                        : [Colors.white, Color(0xFFF8FAFC)],
                  ),
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
                    Row(
                      children: [
                        Icon(
                          Icons.analytics_rounded,
                          color: AppTheme.primaryColor,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Quick Stats',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(
                          context,
                          '$_totalMeasurements',
                          'Total',
                          Icons.format_list_numbered,
                        ),
                        _buildStatItem(
                          context,
                          '${_avgStress.toStringAsFixed(0)}',
                          'Average',
                          Icons.show_chart,
                        ),
                        _buildStatItem(
                          context,
                          '${_minStress.toStringAsFixed(0)}-${_maxStress.toStringAsFixed(0)}',
                          'Range',
                          Icons.stacked_line_chart,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            
            // Menu Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  _buildDrawerItem(
                    context,
                    icon: Icons.bar_chart_rounded,
                    title: 'View Statistics',
                    subtitle: 'Charts & Trends',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => StatsScreen()),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.history_rounded,
                    title: 'History',
                    subtitle: 'All Measurements',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => HistoryScreen()),
                      );
                    },
                  ),
                  
                  // Recent Measurements Preview
                  if (_history.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'Recent Measurements',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ..._history.reversed.take(3).map((result) => _buildRecentItem(context, result)),
                  ],
                ],
              ),
            ),
            
            // Footer
            Container(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Version 1.0.0',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String value, String label, IconData icon) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppTheme.primaryColor, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 0,
      color: isDark ? Color(0xFF1E293B) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppTheme.primaryColor, size: 22),
        ),
        title: Text(
          title,
          style: theme.textTheme.titleMedium,
        ),
        subtitle: Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: theme.colorScheme.onSurface.withOpacity(0.4),
        ),
      ),
    );
  }

  Widget _buildRecentItem(BuildContext context, StressResult result) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final color = _getStressColor(result.level);
    final dateFormat = DateFormat('MMM d, h:mm a');
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      elevation: 0,
      color: isDark ? Color(0xFF1E293B) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              result.emoji,
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
        title: Text(
          result.levelText,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          dateFormat.format(result.timestamp),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        trailing: Text(
          '${result.stressScore.toStringAsFixed(0)}',
          style: theme.textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
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
}

// Helper class to access theme colors
class AppTheme {
  static const Color primaryColor = Color(0xFF6366F1);
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color lowStressColor = Color(0xFF10B981);
  static const Color moderateStressColor = Color(0xFFF59E0B);
  static const Color highStressColor = Color(0xFFF97316);
  static const Color criticalStressColor = Color(0xFFEF4444);
}
