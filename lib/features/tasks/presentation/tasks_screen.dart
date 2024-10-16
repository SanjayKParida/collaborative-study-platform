import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../data/task_model.dart';
import '../domain/task_service.dart';
import 'add_task_form.dart';
import 'task_list_item.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});
  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final TaskService _taskService = TaskService();

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tasks',
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                AddTaskForm(onAddTask: _taskService.addTask),
                const Padding(
                  padding: EdgeInsets.all(15),
                  child: Row(
                    children: [
                      Text(
                        "What's on your Agenda?",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          StreamBuilder<List<TaskModel>>(
            stream: _taskService.getTasks(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (snapshot.hasError) {
                return SliverFillRemaining(
                  child: Center(child: Text('Error: ${snapshot.error}')),
                );
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/images/emptyNotes.svg",
                          width: w * 0.7,
                          height: h * 0.2,
                        ),
                        SizedBox(height: h * 0.05),
                        const Text(
                          "No Tasks yet!!",
                          style: TextStyle(fontSize: 18),
                        )
                      ],
                    ),
                  ),
                );
              }
              final tasks = snapshot.data!;
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return TaskListItem(
                      task: tasks[index],
                      onStatusChanged: _taskService.updateTaskStatus,
                      onDelete: _taskService.deleteTask,
                    );
                  },
                  childCount: tasks.length,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
