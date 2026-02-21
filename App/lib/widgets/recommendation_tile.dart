import 'package:flutter/material.dart';

class RecommendationTile extends StatelessWidget {
  final String text;

  const RecommendationTile({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.check_circle_outline),
      title: Text(text),
    );
  }
}