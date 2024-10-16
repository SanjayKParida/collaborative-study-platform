import 'package:firebase_auth/firebase_auth.dart';
import '../data/group_model.dart';
import '../data/group_repository.dart';

class GroupService {
  final GroupRepository _repository = GroupRepository();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<GroupModel>> getUserGroups() => _repository.getUserGroups();

  Future<String> createGroup(String name, String description) async {
    final group = GroupModel(
      id: '',
      name: name,
      description: description,
      creatorId: _auth.currentUser?.uid ?? '',
      memberIds: [_auth.currentUser?.uid ?? ''],
      createdAt: DateTime.now(),
    );
    return await _repository.createGroup(group);
  }

  Future<void> joinGroup(String groupId) async {
    String userId = _auth.currentUser?.uid ?? '';
    if (userId.isEmpty) {
      throw Exception('User not authenticated');
    }
    await _repository.addMemberToGroup(groupId, userId);
  }

  Future<void> updateGroup(GroupModel group) async {
    await _repository.updateGroup(group);
  }

  Future<void> deleteGroup(String groupId) async {
    await _repository.deleteGroup(groupId);
  }

  Future<void> leaveGroup(String groupId) async {
    String userId = _auth.currentUser?.uid ?? '';
    await _repository.leaveGroup(groupId, userId);
  }
}
