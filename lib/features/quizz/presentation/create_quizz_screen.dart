import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import '../data/quizz_model.dart';
import '../domain/quizz_service.dart';

class CreateQuizScreen extends StatefulWidget {
  const CreateQuizScreen({super.key});

  @override
  _CreateQuizScreenState createState() => _CreateQuizScreenState();
}

class _CreateQuizScreenState extends State<CreateQuizScreen> {
  final QuizService _quizService = QuizService();
  final TextEditingController _titleController = TextEditingController();
  final List<QuestionModel> _questions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Quiz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Quiz Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Text('Questions:', style: Theme.of(context).textTheme.displayLarge),
            Expanded(
              child: ListView.builder(
                itemCount: _questions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_questions[index].question),
                    trailing: IconButton(
                      icon: const Icon(IconlyBold.delete),
                      onPressed: () {
                        setState(() {
                          _questions.removeAt(index);
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _addQuestion,
              child: const Text('Add Question'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveQuiz,
              child: const Text('Save Quiz'),
            ),
          ],
        ),
      ),
    );
  }

  void _addQuestion() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String question = '';
        List<String> options = ['', '', '', ''];
        int correctOptionIndex = 0;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add Question'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      onChanged: (value) => question = value,
                      decoration: const InputDecoration(labelText: 'Question'),
                    ),
                    ...List.generate(4, (index) {
                      return TextField(
                        onChanged: (value) => options[index] = value,
                        decoration:
                            InputDecoration(labelText: 'Option ${index + 1}'),
                      );
                    }),
                    DropdownButton<int>(
                      value: correctOptionIndex,
                      items: List.generate(4, (index) {
                        return DropdownMenuItem<int>(
                          value: index,
                          child: Text('Option ${index + 1}'),
                        );
                      }),
                      onChanged: (value) {
                        setState(() {
                          correctOptionIndex = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    if (question.isNotEmpty &&
                        options.every((option) => option.isNotEmpty)) {
                      this.setState(() {
                        _questions.add(QuestionModel(
                          question: question,
                          options: options,
                          correctOptionIndex: correctOptionIndex,
                        ));
                      });
                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Please fill in all fields')),
                      );
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _saveQuiz() async {
    if (_titleController.text.isNotEmpty && _questions.isNotEmpty) {
      await _quizService.addQuiz(_titleController.text, _questions);
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please add a title and at least one question')),
      );
    }
  }
}
