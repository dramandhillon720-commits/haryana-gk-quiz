import 'package:flutter/material.dart';

import '../models/quiz_models.dart';
import '../services/firebase_service.dart';
import 'test_screen.dart';

class TopicScreen extends StatelessWidget {
  final Subject subject;

  const TopicScreen({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    final service = FirebaseService();

    return Scaffold(
      appBar: AppBar(title: Text(subject.name)),
      body: StreamBuilder<List<Topic>>(
        stream: service.topics(subject.id),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final topics = snapshot.data!;
          if (topics.isEmpty) {
            return const Center(child: Text('No topics found.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: topics.length,
            itemBuilder: (context, index) {
              final topic = topics[index];
              return Card(
                child: ListTile(
                  title: Text(topic.name),
                  subtitle: Text(topic.nameHi),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TestScreen(topic: topic),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
