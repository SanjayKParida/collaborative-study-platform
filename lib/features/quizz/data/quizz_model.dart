// lib/features/quizzes/data/quiz_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class QuizModel {
  final String id;
  final String title;
  final List<QuestionModel> questions;
  final String creatorId;
  final DateTime createdAt;

  QuizModel({
    required this.id,
    required this.title,
    required this.questions,
    required this.creatorId,
    required this.createdAt,
  });

  factory QuizModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return QuizModel(
      id: doc.id,
      title: data['title'] ?? '',
      questions: (data['questions'] as List<dynamic>?)
              ?.map((q) => QuestionModel.fromMap(q))
              .toList() ??
          [],
      creatorId: data['creatorId'] ?? '',
      createdAt: data['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(data['createdAt'] as int)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'questions': questions.map((q) => q.toMap()).toList(),
      'creatorId': creatorId,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }
}

class QuestionModel {
  final String question;
  final List<String> options;
  final int correctOptionIndex;

  QuestionModel({
    required this.question,
    required this.options,
    required this.correctOptionIndex,
  });

  factory QuestionModel.fromMap(Map<String, dynamic> map) {
    return QuestionModel(
      question: map['question'] ?? '',
      options: List<String>.from(map['options'] ?? []),
      correctOptionIndex: map['correctOptionIndex'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'options': options,
      'correctOptionIndex': correctOptionIndex,
    };
  }
}
