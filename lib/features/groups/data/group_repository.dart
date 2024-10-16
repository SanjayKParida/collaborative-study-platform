import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'group_model.dart';

class GroupRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<GroupModel>> getUserGroups() {
    String userId = _auth.currentUser?.uid ?? '';
    return _firestore
        .collection('groups')
        .where('memberIds', arrayContains: userId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => GroupModel.fromFirestore(doc)).toList());
  }

  Future<String> createGroup(GroupModel group) async {
    try {
      DocumentReference docRef =
          await _firestore.collection('groups').add(group.toFirestore());
      return docRef.id;
    } catch (e) {
      print('Error in createGroup: $e');
      rethrow;
    }
  }

  Future<void> addMemberToGroup(String groupId, String userId) async {
    await _firestore.collection('groups').doc(groupId).update({
      'memberIds': FieldValue.arrayUnion([userId])
    });
  }

  Future<void> updateGroup(GroupModel group) async {
    try {
      await _firestore
          .collection('groups')
          .doc(group.id)
          .update(group.toFirestore());
    } catch (e) {
      print('Error in updateGroup: $e');
      rethrow;
    }
  }

  Future<void> deleteGroup(String groupId) async {
    try {
      await _firestore.collection('groups').doc(groupId).delete();
    } catch (e) {
      print('Error in deleteGroup: $e');
      rethrow;
    }
  }

  Future<void> joinGroup(String groupId, String userId) async {
    try {
      await _firestore.collection('groups').doc(groupId).update({
        'memberIds': FieldValue.arrayUnion([userId])
      });
    } catch (e) {
      print('Error in joinGroup: $e');
      rethrow;
    }
  }

  Future<void> leaveGroup(String groupId, String userId) async {
    try {
      await _firestore.collection('groups').doc(groupId).update({
        'memberIds': FieldValue.arrayRemove([userId])
      });
    } catch (e) {
      print('Error in leaveGroup: $e');
      rethrow;
    }
  }
}
