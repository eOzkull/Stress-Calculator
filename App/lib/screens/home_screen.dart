import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'calculator_screen.dart';
import 'history_screen.dart';
import 'stats_screen.dart';
import '../theme/app_theme.dart';
import '../services/mood_service.dart';
import '../services/theme_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  MoodLog? _lastMood;

  @override
  void initState() {
    super.initState();
    _loadMood();
  }

  Future<void> _loadMood() async {
    final mood = await MoodService.getLastMood();
    setState(() => _lastMood = mood);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: _buildMenuButton(context, isDark),
        ),
        actions: [
          IconButton(
            icon: Icon(
                isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
            onPressed: () => ThemeService().toggleTheme(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? AppTheme.backgroundGradientDark
              : AppTheme.backgroundGradientLight,
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Animated Background Elements
              _buildAnimatedBackground(context),

              // Main Content
              SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),

                    // Welcome Message
                    _buildGreeting(context),

                    const SizedBox(height: 32),

                    // Mood Check-in
                    _buildMoodCheckIn(context),

                    const SizedBox(height: 32),

                    // App Logo/Icon
                    Center(
                      child: _buildLogo(context),
                    ),

                    const SizedBox(height: 32),

                    // Title
                    Center(
                      child: Text(
                        'Stress Calculator',
                        style: theme.textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Color(0xFF1E293B),
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 200.ms)
                        .slideY(begin: 0.2, end: 0),

                    const SizedBox(height: 8),

                    Center(
                      child: Text(
                        'Measure • Understand • Improve',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ).animate().fadeIn(delay: 300.ms),

                    const SizedBox(height: 48),

                    // Feature Cards
                    Column(
                      children: [
                        _buildFeatureCard(
                          context,
                          icon: Icons.calculate_rounded,
                          title: 'Calculate Stress',
                          subtitle: 'Enter BP & Pulse for instant analysis',
                          color: AppTheme.primaryColor,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CalculatorScreen(),
                            ),
                          ),
                        )
                            .animate()
                            .fadeIn(delay: 400.ms)
                            .slideX(begin: -0.2, end: 0),
                        const SizedBox(height: 16),
                        _buildFeatureCard(
                          context,
                          icon: Icons.bar_chart_rounded,
                          title: 'View Statistics',
                          subtitle: 'Charts, trends & detailed insights',
                          color: AppTheme.secondaryColor,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const StatsScreen(),
                            ),
                          ),
                        )
                            .animate()
                            .fadeIn(delay: 500.ms)
                            .slideX(begin: 0.2, end: 0),
                        const SizedBox(height: 16),
                        _buildFeatureCard(
                          context,
                          icon: Icons.history_rounded,
                          title: 'View History',
                          subtitle: 'Track your stress levels over time',
                          color: AppTheme.accentColor,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const HistoryScreen(),
                            ),
                          ),
                        )
                            .animate()
                            .fadeIn(delay: 600.ms)
                            .slideX(begin: -0.2, end: 0),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Tip of the Day
                    _buildTipCard(context),

                    const SizedBox(height: 48),

                    // Info Section
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: (isDark ? Colors.white : AppTheme.primaryColor)
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: (isDark ? Colors.white : AppTheme.primaryColor)
                              .withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: AppTheme.primaryColor,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'This app uses cardiovascular markers to estimate stress levels. For medical concerns, please consult a healthcare professional.',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.7),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 700.ms),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: (isDark ? Colors.white : AppTheme.primaryColor).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: Icon(
          Icons.menu_rounded,
          color: isDark ? Colors.white : const Color(0xFF1E293B),
        ),
        onPressed: () {
          _scaffoldKey.currentState?.openDrawer();
        },
      ),
    );
  }

  Widget _buildGreeting(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting = 'Good Morning';
    } else if (hour < 17) {
      greeting = 'Good Afternoon';
    } else {
      greeting = 'Good Evening';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          'Wellness Companion',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF1E293B),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.1, end: 0);
  }

  Widget _buildTipCard(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
              : [Colors.white, const Color(0xFFF8FAFC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color:
              (isDark ? Colors.white : AppTheme.primaryColor).withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.lightbulb_rounded,
                    color: AppTheme.accentColor, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                'Tip of the Day',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Taking just 5 minutes for deep breathing can lower your cortisol levels and improve focus.',
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.5,
              color: theme.colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 800.ms).scale(begin: const Offset(0.95, 0.95));
  }

  Widget _buildLogo(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [Color(0xFF6366F1), Color(0xFF8B5CF6)]
              : [AppTheme.primaryColor, AppTheme.secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Color(0xFF6366F1) : AppTheme.primaryColor)
                .withOpacity(0.4),
            blurRadius: 30,
            offset: Offset(0, 15),
          ),
        ],
      ),
      child: Icon(
        Icons.favorite_rounded,
        size: 55,
        color: Colors.white,
      ),
    ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack).fadeIn();
  }

  Widget _buildAnimatedBackground(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Positioned(
      top: -100,
      right: -100,
      child: Container(
        width: 300,
        height: 300,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              (isDark ? Colors.white : AppTheme.primaryColor).withOpacity(0.1),
              (isDark ? Colors.white : AppTheme.primaryColor).withOpacity(0),
            ],
          ),
        ),
      ).animate(onPlay: (controller) => controller.repeat()).scale(
          duration: 10.seconds, begin: Offset(1, 1), end: Offset(1.2, 1.2)),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Drawer(
      backgroundColor:
          isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight,
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
                      : [AppTheme.primaryColor, AppTheme.secondaryColor],
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

            // Menu Items
            Expanded(
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                children: [
                  _buildDrawerItem(
                    context,
                    icon: Icons.home_rounded,
                    title: 'Home',
                    subtitle: 'Main Dashboard',
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.calculate_rounded,
                    title: 'New Measurement',
                    subtitle: 'Calculate stress level',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const CalculatorScreen()),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.bar_chart_rounded,
                    title: 'Statistics',
                    subtitle: 'Charts & Trends',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const StatsScreen()),
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
                        MaterialPageRoute(
                            builder: (_) => const HistoryScreen()),
                      );
                    },
                  ),

                  const SizedBox(height: 16),
                  Divider(),
                  const SizedBox(height: 8),

                  // About Section
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      'About',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ),
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.info_outline_rounded,
                    title: 'About App',
                    subtitle: 'Version 1.0.0',
                    onTap: () {
                      Navigator.pop(context);
                      _showAboutDialog(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/images/app_logo.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isDark
                              ? [const Color(0xFF6366F1), const Color(0xFF8B5CF6)]
                              : [AppTheme.primaryColor, AppTheme.secondaryColor],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Icon(Icons.favorite_rounded, color: Colors.white, size: 28),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Stress Calculator'),
                  Text(
                    'Version 1.0.0',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'A comprehensive stress level calculator that uses cardiovascular markers to estimate your stress levels.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Developed by eOzka',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Key Features',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '• Real-time stress level calculation\n'
                '• Historical data tracking\n'
                '• Interactive statistics & trends\n'
                '• Personalized recommendations\n'
                '• Beautiful dark/light themes\n'
                '• Mood tracking integration',
                style: theme.textTheme.bodySmall?.copyWith(
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () async {
                  Navigator.pop(context);
                  try {
                    await ThemeService.openUrl('https://github.com/eOzkull/Stress-Calculator');
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Could not open GitHub link: $e')),
                    );
                  }
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.code_rounded, size: 18, color: Colors.grey[700]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'View Source on GitHub',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Icon(Icons.open_in_new, size: 16, color: Colors.grey[600]),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.warning_amber_rounded, color: Colors.red[400], size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Note: This app provides estimates only. Please consult a healthcare professional for medical advice.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.red[400],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  '© 2026 Stress Calculator. All rights reserved.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodCheckIn(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color:
            (isDark ? Colors.white : AppTheme.primaryColor).withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color:
              (isDark ? Colors.white : AppTheme.primaryColor).withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'How are you feeling?',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (_lastMood != null)
                Text(
                  'Last: ${_lastMood!.emoji}',
                  style: theme.textTheme.bodySmall,
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _moodButton(context, '😊', 'Good'),
              _moodButton(context, '😐', 'Okay'),
              _moodButton(context, '😔', 'Low'),
              _moodButton(context, '😫', 'Stressed'),
              _moodButton(context, '😴', 'Tired'),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _moodButton(BuildContext context, String emoji, String label) {
    return InkWell(
      onTap: () async {
        await MoodService.logMood(emoji, label);
        _loadMood();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logged: $label $emoji'),
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
            width: 200,
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 10)),
          ],
        ),
      ),
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

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: isDark ? Color(0xFF1E293B) : Colors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      color.withOpacity(0.15),
                      color.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: color,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
