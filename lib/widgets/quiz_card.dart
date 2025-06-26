import 'package:flutter/material.dart';

class QuizCard extends StatelessWidget {
  final String question;
  final List<String> options;
  final Function(String) onSelected;

  QuizCard({required this.question, required this.options, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(question, style: TextStyle(fontSize: 18)),
            ...options.map((opt) => ElevatedButton(onPressed: () => onSelected(opt), child: Text(opt))).toList(),
          ],
        ),
      ),
    );
  }
}
