import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'task_model.dart';

class TaskRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<TaskModel>> getTasks() {
    final user = _auth.currentUser;
    if (user == null) {
      return Stream.value([]);
    }
    try {
      return _firestore
          .collection('tasks')
          .where('userId', isEqualTo: user.uid)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => TaskModel.fromFirestore(doc))
              .toList());
    } catch (e) {
      print('Error in getTasks: $e');
      return Stream.value([]);
    }
  }

  Future<void> addTask(TaskModel task) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('No authenticated user');
    }
    try {
      await _firestore.collection('tasks').add({
        ...task.toMap(),
        'userId': user.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error in addTask: $e');
      rethrow;
    }
  }

  Future<void> updateTaskStatus(String taskId, bool isCompleted) async {
    try {
      await _firestore.collection('tasks').doc(taskId).update({
        'isCompleted': isCompleted,
      });
    } catch (e) {
      print('Error in updateTaskStatus: $e');
      rethrow;
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _firestore.collection('tasks').doc(taskId).delete();
    } catch (e) {
      print('Error in deleteTask: $e');
      rethrow;
    }
  }

  Future<TaskModel> getTask(String taskId) async {
    try {
      final doc = await _firestore.collection('tasks').doc(taskId).get();
      return TaskModel.fromFirestore(doc);
    } catch (e) {
      print('Error in getTask: $e');
      rethrow;
    }
  }
}
