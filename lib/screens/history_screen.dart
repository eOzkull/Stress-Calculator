import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/stress_result.dart';
import 'result_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<StressResult> _history = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString('stress_history');

    if (historyJson != null) {
      setState(() {
        _history = StressResult.decodeList(historyJson);
        _history = _history.reversed.toList(); // Newest first
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _clearHistory() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear History'),
        content: Text('Are you sure you want to delete all history?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('stress_history');
      setState(() => _history = []);
    }
  }

  Future<void> _deleteResult(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final updatedHistory = List<StressResult>.from(_history.reversed);
    updatedHistory.removeAt(index);

    await prefs.setString(
        'stress_history', StressResult.encodeList(updatedHistory));

    setState(() {
      _history = updatedHistory.reversed.toList();
    });
  }

  Future<void> _deleteOlderThan(int days) async {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    final updatedHistory =
        _history.where((r) => r.timestamp.isAfter(cutoff)).toList();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'stress_history', StressResult.encodeList(updatedHistory));

    setState(() {
      _history = updatedHistory;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Cleared records older than $days days')),
    );
  }

  Color _getStressColor(StressLevel level) {
    switch (level) {
      case StressLevel.relaxed:
        return Color(0xFF2A9D8F);
      case StressLevel.mild:
        return Color(0xFF7FB069);
      case StressLevel.moderate:
        return Color(0xFFE9C46A);
      case StressLevel.high:
        return Color(0xFFF4A261);
      case StressLevel.critical:
        return Color(0xFFE76F51);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
        actions: [
          if (_history.isNotEmpty) ...[
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert),
              onSelected: (value) {
                if (value == 'clear_all') _clearHistory();
                if (value == 'clear_7') _deleteOlderThan(7);
                if (value == 'clear_30') _deleteOlderThan(30);
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                    value: 'clear_7', child: Text('Delete older than 7 days')),
                PopupMenuItem(
                    value: 'clear_30',
                    child: Text('Delete older than 30 days')),
                PopupMenuDivider(),
                PopupMenuItem(
                  value: 'clear_all',
                  child: Text('Clear All', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ],
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _history.isEmpty
              ? _buildEmptyState(context)
              : _buildHistoryList(context),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'No History Yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.grey.shade600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your stress measurements will appear here',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade500,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: _history.length,
      itemBuilder: (context, index) {
        final result = _history[index];
        final color = _getStressColor(result.level);
        final dateFormat = DateFormat('MMM d, yyyy • h:mm a');

        return Dismissible(
          key: Key(result.timestamp.toIso8601String() + index.toString()),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 20),
            color: Colors.red,
            child: Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (direction) => _deleteResult(index),
          confirmDismiss: (direction) async {
            return await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Delete Record'),
                content:
                    Text('Are you sure you want to delete this measurement?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text('Delete', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            );
          },
          child: Card(
            margin: EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: EdgeInsets.all(16),
              leading: Container(
                width: 52, // Reduced slightly to fix potential overflow
                height: 52,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: FittedBox(
                  // Use FittedBox to ensure content fits without overflow
                  fit: BoxFit.scaleDown,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          result.emoji,
                          style: TextStyle(fontSize: 24),
                        ),
                        Text(
                          '${result.stressScore.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              title: Text(
                result.name ?? result.levelText,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (result.name != null)
                    Text(
                      result.levelText,
                      style: TextStyle(
                          fontSize: 12, color: color.withOpacity(0.8)),
                    ),
                  SizedBox(height: 4),
                  Text(
                    dateFormat.format(result.timestamp),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.favorite,
                          size: 14, color: Colors.grey.shade500),
                      SizedBox(width: 4),
                      Text(
                        '${result.systolicBP}/${result.diastolicBP}',
                        style: TextStyle(fontSize: 12),
                      ),
                      SizedBox(width: 12),
                      Icon(Icons.monitor_heart,
                          size: 14, color: Colors.grey.shade500),
                      SizedBox(width: 4),
                      Text(
                        '${result.pulseRate} BPM',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
              trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ResultScreen(result: result),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
