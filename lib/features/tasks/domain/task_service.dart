import 'package:study_mesh/features/tasks/data/task_model.dart';
import 'package:study_mesh/features/tasks/data/task_repository.dart';

import '../../../services/notfication_service.dart';

class TaskService {
  final TaskRepository _repository = TaskRepository();
  final NotificationService _notificationService = NotificationService();

  Stream<List<TaskModel>> getTasks() => _repository.getTasks();

  Future<void> addTask(String title, DateTime? dueDate) async {
    final task = TaskModel(
      id: '',
      title: title,
      isCompleted: false,
      dueDate: dueDate,
      userId: '',
    );
    await _repository.addTask(task);
    if (dueDate != null) {
      await _notificationService.scheduleNotification(task);
    }
  }

  Future<void> updateTaskStatus(String taskId, bool isCompleted) async {
    await _repository.updateTaskStatus(taskId, isCompleted);
    if (isCompleted) {
      // Cancel notification if task is completed
      final task = await _repository.getTask(taskId);
      await _notificationService.cancelNotification(task);
    }
  }

  Future<void> deleteTask(String taskId) async {
    final task = await _repository.getTask(taskId);
    await _repository.deleteTask(taskId);
    await _notificationService.cancelNotification(task);
  }
}
