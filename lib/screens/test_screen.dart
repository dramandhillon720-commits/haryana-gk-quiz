import 'package:flutter/material.dart';

import '../models/quiz_models.dart';
import '../services/firebase_service.dart';
import '../services/interstitial_ad_service.dart';
import 'quiz_screen.dart';

class TestScreen extends StatefulWidget {
  final Topic topic;

  const TestScreen({super.key, required this.topic});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final _service = FirebaseService();
  final _interstitial = InterstitialAdService();

  @override
  void initState() {
    super.initState();
    _interstitial.load();
  }

  @override
  void dispose() {
    _interstitial.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.topic.name)),
      body: StreamBuilder<List<QuizTest>>(
        stream: _service.tests(widget.topic.id),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final tests = snapshot.data!;
          if (tests.isEmpty) {
            return const Center(child: Text('No tests found.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: tests.length,
            itemBuilder: (context, index) {
              final test = tests[index];
              return Card(
                child: ListTile(
                  title: Text(test.title),
                  subtitle: Text(test.titleHi),
                  trailing: const Icon(Icons.play_arrow),
                  onTap: () {
                    _interstitial.show();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => QuizScreen(test: test),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
