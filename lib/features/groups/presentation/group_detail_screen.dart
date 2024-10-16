import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/group_model.dart';
import '../domain/group_service.dart';

class GroupDetailScreen extends StatefulWidget {
  final GroupModel group;

  const GroupDetailScreen({Key? key, required this.group}) : super(key: key);

  @override
  _GroupDetailScreenState createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
  final GroupService _groupService = GroupService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late bool isCreator;
  late bool isMember;

  @override
  void initState() {
    super.initState();
    _updateMembershipStatus();
  }

  void _updateMembershipStatus() {
    final currentUserId = _auth.currentUser?.uid;
    isCreator = widget.group.creatorId == currentUserId;
    isMember = widget.group.memberIds.contains(currentUserId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.group.name),
        actions: [
          if (isCreator)
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: _editGroup,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Description',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 8),
            Text(widget.group.description),
            SizedBox(height: 24),
            Text(
              'Members',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: widget.group.memberIds.length,
                itemBuilder: (context, index) {
                  final memberId = widget.group.memberIds[index];
                  return ListTile(
                    title: Text('Member $memberId'),
                    trailing: isCreator && memberId != _auth.currentUser?.uid
                        ? IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () => _removeMember(memberId),
                          )
                        : null,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: isMember ? _leaveGroup : _joinGroup,
          child: Text(isMember ? 'Leave Group' : 'Join Group'),
          style: ElevatedButton.styleFrom(
            backgroundColor: isMember ? Colors.red : Colors.green,
            foregroundColor: Colors.white,
            minimumSize: Size(double.infinity, 50),
          ),
        ),
      ),
    );
  }

  void _editGroup() {
    // TODO: Implement edit group functionality
  }

  void _removeMember(String memberId) async {
    try {
      await _groupService.leaveGroup(widget.group.id);
      setState(() {
        widget.group.memberIds.remove(memberId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Member removed from the group')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove member: $e')),
      );
    }
  }

  void _leaveGroup() async {
    try {
      await _groupService.leaveGroup(widget.group.id);
      setState(() {
        widget.group.memberIds.remove(_auth.currentUser?.uid);
        _updateMembershipStatus();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You have left the group')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to leave group: $e')),
      );
    }
  }

  void _joinGroup() async {
    try {
      await _groupService.joinGroup(widget.group.id);
      setState(() {
        widget.group.memberIds.add(_auth.currentUser?.uid ?? '');
        _updateMembershipStatus();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You have joined the group')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to join group: $e')),
      );
    }
  }
}
