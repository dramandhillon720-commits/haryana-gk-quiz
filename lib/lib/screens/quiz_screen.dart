import 'package:flutter/material.dart';

import '../models/quiz_models.dart';
import '../services/firebase_service.dart';

class QuizScreen extends StatefulWidget {
  final QuizTest test;

  const QuizScreen({super.key, required this.test});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final _service = FirebaseService();

  int _current = 0;
  int _score = 0;
  bool _answered = false;
  int? _selected;

  void _answer(int index, QuizQuestion question) {
    if (_answered) return;
    setState(() {
      _answered = true;
      _selected = index;
      if (index == question.correctIndex) _score++;
    });
  }

  void _next(List<QuizQuestion> questions) {
    if (_current + 1 >= questions.length) {
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: const Text('Result'),
          content: Text('Your score: $_score / ${questions.length}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Done'),
            ),
          ],
        ),
      );
      return;
    }

    setState(() {
      _current++;
      _answered = false;
      _selected = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.test.title)),
      body: StreamBuilder<List<QuizQuestion>>(
        stream: _service.questions(widget.test.id),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final questions = snapshot.data!;
          if (questions.isEmpty) {
            return const Center(child: Text('No questions found.'));
          }

          final q = questions[_current];
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Question ${_current + 1} / ${questions.length}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 20),
                Text(
                  q.question,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 20),
                ...List.generate(q.options.length, (index) {
                  final selected = _selected == index;
                  final correct = q.correctIndex == index;
                  return Card(
                    child: ListTile(
                      title: Text(q.options[index]),
                      trailing: _answered && correct
                          ? const Icon(Icons.check)
                          : _answered && selected
                              ? const Icon(Icons.close)
                              : null,
                      onTap: () => _answer(index, q),
                    ),
                  );
                }),
                const Spacer(),
                if (_answered)
                  FilledButton(
                    onPressed: () => _next(questions),
                    child: Text(
                      _current + 1 == questions.length ? 'Finish' : 'Next',
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
