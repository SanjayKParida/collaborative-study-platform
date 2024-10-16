import 'package:firebase_auth/firebase_auth.dart';

import '../data/quizz_model.dart';
import '../data/quizz_repository.dart';

class QuizService {
  final QuizRepository _repository = QuizRepository();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<QuizModel>> getQuizzes() => _repository.getQuizzes();

  Future<void> addQuiz(String title, List<QuestionModel> questions) async {
    final quiz = QuizModel(
      id: '',
      title: title,
      questions: questions,
      creatorId: _auth.currentUser?.uid ?? '',
      createdAt: DateTime.now(),
    );
    await _repository.addQuiz(quiz);
  }

  Future<void> deleteQuiz(String quizId) async {
    if (quizId.isEmpty) {
      throw ArgumentError('Quiz ID cannot be empty');
    }
    await _repository.deleteQuiz(quizId);
  }
}
