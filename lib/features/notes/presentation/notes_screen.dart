import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconly/iconly.dart';
import '../data/note_model.dart';
import '../domain/note_service.dart';
import 'note_creation_screen.dart';
import 'note_detail_screen.dart';
import 'widgets/note_list_item.dart';

class NotesScreen extends StatelessWidget {
  final NoteService _noteService = NoteService();

  NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notes',
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ),
      body: StreamBuilder<List<NoteModel>>(
        stream: _noteService.getNotes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            print('Error in StreamBuilder: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/images/emptySpace.svg",
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
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final note = snapshot.data![index]; // Debug log
              return NoteListItem(
                note: note,
                onDelete: () => _noteService.deleteNote(note.id),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NoteDetailScreen(note: note),
                    ),
                  );
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
            MaterialPageRoute(builder: (context) => NoteCreationScreen()),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(
          IconlyBold.plus,
          color: Colors.white,
        ),
      ),
    );
  }
}
