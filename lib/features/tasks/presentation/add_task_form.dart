// lib/features/tasks/presentation/widgets/add_task_form.dart

import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class AddTaskForm extends StatefulWidget {
  final Function(String, DateTime?) onAddTask;

  AddTaskForm({required this.onAddTask});

  @override
  _AddTaskFormState createState() => _AddTaskFormState();
}

class _AddTaskFormState extends State<AddTaskForm> {
  final TextEditingController _taskController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitTask() {
    if (_taskController.text.isNotEmpty) {
      widget.onAddTask(_taskController.text, _selectedDate);
      _taskController.clear();
      setState(() {
        _selectedDate = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _taskController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Enter a new task',
                hintStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(IconlyBold.calendar),
            onPressed: () => _selectDate(context),
          ),
          IconButton(
            icon: const Icon(IconlyBold.plus),
            onPressed: _submitTask,
          ),
        ],
      ),
    );
  }
}
