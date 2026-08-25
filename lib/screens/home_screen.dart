import 'package:flutter/material.dart';

import '../models/quiz_models.dart';
import '../services/firebase_service.dart';
import '../widgets/banner_ad_widget.dart';
import 'topic_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = FirebaseService();

    return Scaffold(
      appBar: AppBar(title: const Text('Haryana GK Quiz')),
      bottomNavigationBar: const SafeArea(child: BannerAdWidget()),
      body: StreamBuilder<List<Subject>>(
        stream: service.subjects(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Firebase error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final subjects = snapshot.data!;
          if (subjects.isEmpty) {
            return const _EmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: subjects.length,
            itemBuilder: (context, index) {
              final subject = subjects[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text('${index + 1}'),
                  ),
                  title: Text(subject.name),
                  subtitle: Text(subject.nameHi),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TopicScreen(subject: subject),
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

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          'No subjects found.\nAdd subjects in Firebase Firestore.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
