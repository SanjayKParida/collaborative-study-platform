import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:study_mesh/features/tasks/data/task_model.dart';

class TaskListItem extends StatelessWidget {
  final TaskModel task;
  final Function(String, bool) onStatusChanged;
  final Function(String) onDelete;

  TaskListItem({
    required this.task,
    required this.onStatusChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(task.id),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        onDelete(task.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task deleted')),
        );
      },
      child: CheckboxListTile(
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: task.dueDate != null
            ? Text('Due: ${DateFormat('MMM d, y').format(task.dueDate!)}')
            : null,
        value: task.isCompleted,
        onChanged: (bool? value) {
          onStatusChanged(task.id, value!);
        },
      ),
    );
  }
}
