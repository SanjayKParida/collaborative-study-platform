import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'note_model.dart';

class NoteRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> _uploadFile(File file) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = _storage.ref().child('notes/$userId/$fileName');

      // Upload the file to Firebase Storage
      final uploadTask = ref.putFile(file);
      final snapshot = await uploadTask.whenComplete(() {});

      // Get the download URL
      final downloadUrl = await snapshot.ref.getDownloadURL();
      print(
          'Image uploaded to Firebase Storage. URL: $downloadUrl'); // Debug log
      return downloadUrl;
    } catch (e) {
      print('Error uploading file to Firebase Storage: $e');
      return null;
    }
  }

  Future<void> addNote(NoteModel note, {File? imageFile}) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      String? imageUrl;
      if (imageFile != null) {
        imageUrl = await _uploadFile(imageFile);
      }

      final noteData = {
        ...note.toMap(),
        'userId': userId,
        'imageUrl': imageUrl,
      };

      await _firestore.collection('notes').add(noteData);
      print('Note added with imageUrl: $imageUrl'); // Debug log
    } catch (e) {
      print('Error in addNote: $e');
      rethrow;
    }
  }

  Stream<List<NoteModel>> getNotes() {
    try {
      final userId = _auth.currentUser?.uid;
      print('Current user ID: $userId'); // Debug log

      return _firestore
          .collection('notes')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
        print('Snapshot size: ${snapshot.size}'); // Debug log
        return snapshot.docs.map((doc) {
          print('Document ID: ${doc.id}'); // Debug log
          return NoteModel.fromFirestore(doc);
        }).toList();
      });
    } catch (e) {
      print('Error in getNotes: $e');
      return Stream.value([]);
    }
  }

  Future<void> updateNote(NoteModel note, {File? imageFile}) async {
    try {
      String? imageUrl = note.imageUrl;
      if (imageFile != null) {
        imageUrl = await _uploadFile(imageFile);
      }

      await _firestore.collection('notes').doc(note.id).update({
        ...note.toMap(),
        'imageUrl': imageUrl,
      });
      print('Note updated with imageUrl: $imageUrl'); // Debug log
    } catch (e) {
      print('Error in updateNote: $e');
      rethrow;
    }
  }

  Future<void> deleteNote(String noteId) async {
    try {
      final noteDoc = await _firestore.collection('notes').doc(noteId).get();
      final noteData = noteDoc.data();

      if (noteData != null && noteData['imageUrl'] != null) {
        await _storage.refFromURL(noteData['imageUrl']).delete();
      }

      await _firestore.collection('notes').doc(noteId).delete();
    } catch (e) {
      print('Error in deleteNote: $e');
      rethrow;
    }
  }
}
