import 'package:flutter/material.dart';
import '../data/quizz_model.dart';
import 'quizz_detail.screen.dart';

class QuizItem extends StatelessWidget {
  final QuizModel quiz;
  final VoidCallback onDelete;

  const QuizItem({
    Key? key,
    required this.quiz,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(quiz.title),
        subtitle: Text('${quiz.questions.length} questions'),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: onDelete,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => QuizDetailScreen(quiz: quiz)),
          );
        },
      ),
    );
  }
}
