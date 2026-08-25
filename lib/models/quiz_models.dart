
class Subject {
  final String id;
  final String name;
  final String nameHi;
  final String? icon;

  const Subject({
    required this.id,
    required this.name,
    required this.nameHi,
    this.icon,
  });

  factory Subject.fromMap(String id, Map<String, dynamic> data) {
    return Subject(
      id: id,
      name: (data['name'] ?? id).toString(),
      nameHi: (data['nameHi'] ?? data['name'] ?? id).toString(),
      icon: data['icon']?.toString(),
    );
  }
}

class Topic {
  final String id;
  final String subjectId;
  final String name;
  final String nameHi;

  const Topic({
    required this.id,
    required this.subjectId,
    required this.name,
    required this.nameHi,
  });

  factory Topic.fromMap(String id, Map<String, dynamic> data) {
    return Topic(
      id: id,
      subjectId: (data['subjectId'] ?? '').toString(),
      name: (data['name'] ?? id).toString(),
      nameHi: (data['nameHi'] ?? data['name'] ?? id).toString(),
    );
  }
}

class QuizTest {
  final String id;
  final String topicId;
  final String title;
  final String titleHi;
  final int durationSeconds;

  const QuizTest({
    required this.id,
    required this.topicId,
    required this.title,
    required this.titleHi,
    required this.durationSeconds,
  });

  factory QuizTest.fromMap(String id, Map<String, dynamic> data) {
    return QuizTest(
      id: id,
      topicId: (data['topicId'] ?? '').toString(),
      title: (data['title'] ?? id).toString(),
      titleHi: (data['titleHi'] ?? data['title'] ?? id).toString(),
      durationSeconds: (data['durationSeconds'] ?? 0) as int,
    );
  }
}

class QuizQuestion {
  final String id;
  final String question;
  final String questionHi;
  final List<String> options;
  final List<String> optionsHi;
  final int correctIndex;
  final String explanation;
  final String explanationHi;

  const QuizQuestion({
    required this.id,
    required this.question,
    required this.questionHi,
    required this.options,
    required this.optionsHi,
    required this.correctIndex,
    required this.explanation,
    required this.explanationHi,
  });

  factory QuizQuestion.fromMap(
    String id,
    Map<String, dynamic> data,
  ) {
    return QuizQuestion(
      id: id,
      question: (data['question'] ?? '').toString(),
      questionHi:
          (data['questionHi'] ?? data['question'] ?? '').toString(),
      options: List<String>.from(data['options'] ?? const []),
      optionsHi:
          List<String>.from(data['optionsHi'] ?? data['options'] ?? const []),
      correctIndex: (data['correctIndex'] ?? 0) as int,
      explanation: (data['explanation'] ?? '').toString(),
      explanationHi:
          (data['explanationHi'] ?? data['explanation'] ?? '').toString(),
    );
  }
}
