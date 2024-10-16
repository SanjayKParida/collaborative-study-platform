import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconly/iconly.dart';
import '../data/quizz_model.dart';
import '../domain/quizz_service.dart';
import 'create_quizz_screen.dart';
import 'quizz_item.dart';

class QuizListScreen extends StatelessWidget {
  final QuizService _quizService = QuizService();

  QuizListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quizzes',
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ),
      body: StreamBuilder<List<QuizModel>>(
        stream: _quizService.getQuizzes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/images/emptyQuizzes.svg",
                    width: w * 0.7,
                    height: h * 0.2,
                  ),
                  SizedBox(height: h * 0.05),
                  const Text(
                    "No Quizzes yet!",
                    style: TextStyle(fontSize: 18),
                  )
                ],
              ),
            );
          }

          final quizzes = snapshot.data!;
          return ListView.builder(
            itemCount: quizzes.length,
            itemBuilder: (context, index) {
              final quiz = quizzes[index];
              return QuizItem(
                quiz: quiz,
                onDelete: () async {
                  try {
                    await _quizService.deleteQuiz(quiz.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Quiz "${quiz.title}" deleted successfully')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to delete quiz: $e')),
                    );
                  }
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateQuizScreen()),
          );
        },
        child: const Icon(
          IconlyBold.plus,
          color: Colors.white,
        ),
      ),
    );
  }
}
