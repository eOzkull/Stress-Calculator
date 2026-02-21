import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'calculator_screen.dart';
import 'history_screen.dart';
import 'stats_screen.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(context),
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
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    
                    // Header with Hamburger Menu
                    _buildHeader(context),
                    
                    const SizedBox(height: 40),
                    
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
                    ).animate()
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
                    ).animate()
                     .fadeIn(delay: 300.ms),
                    
                    const SizedBox(height: 48),
                    
                    // Feature Cards
                    Expanded(
                      child: Column(
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
                          ).animate()
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
                          ).animate()
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
                          ).animate()
                           .fadeIn(delay: 600.ms)
                           .slideX(begin: -0.2, end: 0),
                        ],
                      ),
                    ),
                    
                    // Info Section
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: (isDark ? Colors.white : AppTheme.primaryColor).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: (isDark ? Colors.white : AppTheme.primaryColor).withOpacity(0.2),
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
                                color: theme.colorScheme.onSurface.withOpacity(0.7),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ).animate()
                     .fadeIn(delay: 700.ms),
                     
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

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Hamburger Menu Button
        Container(
          decoration: BoxDecoration(
            color: (isDark ? Colors.white : AppTheme.primaryColor).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: Icon(
              Icons.menu_rounded,
              color: isDark ? Colors.white : Color(0xFF1E293B),
            ),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
        ).animate()
         .fadeIn(delay: 100.ms)
         .slideX(begin: -0.3, end: 0),
        
        // App Title (optional, can be hidden on smaller screens)
        Text(
          'Wellness',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Color(0xFF1E293B),
          ),
        ).animate()
         .fadeIn(delay: 150.ms),
        
        // Placeholder for symmetry
        SizedBox(width: 48),
      ],
    );
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
            color: (isDark ? Color(0xFF6366F1) : AppTheme.primaryColor).withOpacity(0.4),
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
    ).animate()
     .scale(duration: 600.ms, curve: Curves.easeOutBack)
     .fadeIn();
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
      ).animate(onPlay: (controller) => controller.repeat())
       .scale(duration: 10.seconds, begin: Offset(1, 1), end: Offset(1.2, 1.2)),
    );
  }

  Widget _buildDrawer(BuildContext context) {
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
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                        MaterialPageRoute(builder: (_) => const CalculatorScreen()),
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
                        MaterialPageRoute(builder: (_) => const HistoryScreen()),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  Divider(),
                  const SizedBox(height: 8),
                  
                  // About Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.favorite_rounded, color: AppTheme.primaryColor),
            ),
            const SizedBox(width: 12),
            Text('Stress Calculator'),
          ],
        ),
        content: Text(
          'A comprehensive stress level calculator that uses cardiovascular markers to estimate your stress levels.\n\n'
          'Version: 1.0.0\n\n'
          'Features:\n'
          '• Stress level calculation\n'
          '• Historical tracking\n'
          '• Statistics & trends\n'
          '• Personalized recommendations\n\n'
          'Note: This app provides estimates only. Please consult a healthcare professional for medical advice.',
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
