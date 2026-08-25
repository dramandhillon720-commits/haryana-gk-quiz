import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/quiz_models.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Subject>> subjects() {
    return _db.collection('subjects').orderBy('order').snapshots().map(
          (snapshot) => snapshot.docs
              .map((d) => Subject.fromMap(d.id, d.data()))
              .toList(),
        );
  }

  Stream<List<Topic>> topics(String subjectId) {
    return _db
        .collection('topics')
        .where('subjectId', isEqualTo: subjectId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((d) => Topic.fromMap(d.id, d.data()))
              .toList(),
        );
  }

  Stream<List<QuizTest>> tests(String topicId) {
    return _db
        .collection('tests')
        .where('topicId', isEqualTo: topicId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((d) => QuizTest.fromMap(d.id, d.data()))
              .toList(),
        );
  }

  Stream<List<QuizQuestion>> questions(String testId) {
    return _db
        .collection('questions')
        .where('testId', isEqualTo: testId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((d) => QuizQuestion.fromMap(d.id, d.data()))
              .toList(),
        );
  }
}
