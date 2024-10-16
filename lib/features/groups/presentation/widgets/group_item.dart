import 'package:flutter/material.dart';
import '../../data/group_model.dart';

class GroupItem extends StatelessWidget {
  final GroupModel group;
  final VoidCallback onLeave;

  const GroupItem({
    Key? key,
    required this.group,
    required this.onLeave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(group.name),
        subtitle: Text('${group.memberIds.length} members'),
        trailing: IconButton(
          icon: Icon(Icons.exit_to_app),
          onPressed: onLeave,
        ),
      ),
    );
  }
}
