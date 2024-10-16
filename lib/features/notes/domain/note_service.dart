import 'dart:io';
import '../data/note_model.dart';
import '../data/note_repository.dart';

class NoteService {
  final NoteRepository _repository = NoteRepository();

  Future<void> addNote(String title, String content, {File? imageFile}) async {
    final note = NoteModel(
      id: '', // Firestore will generate this
      title: title,
      content: content,
      createdAt: DateTime.now(),
    );
    await _repository.addNote(note, imageFile: imageFile);
  }

  Stream<List<NoteModel>> getNotes() => _repository.getNotes();

  Future<void> updateNote(NoteModel note, {File? imageFile}) async {
    await _repository.updateNote(note, imageFile: imageFile);
  }

  Future<void> deleteNote(String noteId) async {
    await _repository.deleteNote(noteId);
  }
}
