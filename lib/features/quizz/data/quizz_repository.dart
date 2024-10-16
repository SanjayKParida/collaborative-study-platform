import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'quizz_model.dart';

class QuizRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<QuizModel>> getQuizzes() {
    return _firestore
        .collection('quizzes')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => QuizModel.fromFirestore(doc)).toList());
  }

  Future<String> addQuiz(QuizModel quiz) async {
    try {
      DocumentReference docRef =
          await _firestore.collection('quizzes').add(quiz.toFirestore());
      return docRef.id;
    } catch (e) {
      print('Error in addQuiz: $e');
      rethrow;
    }
  }

  Future<void> deleteQuiz(String quizId) async {
    if (quizId.isEmpty) {
      throw ArgumentError('Quiz ID cannot be empty');
    }
    try {
      await _firestore.collection('quizzes').doc(quizId).delete();
    } catch (e) {
      print('Error in deleteQuiz: $e');
      rethrow;
    }
  }
}
