import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconly/iconly.dart';
import '../data/group_model.dart';
import '../domain/group_service.dart';
import 'create_group_screen.dart';
import 'group_detail_screen.dart';
import 'widgets/group_item.dart';

class GroupListScreen extends StatelessWidget {
  final GroupService _groupService = GroupService();

  GroupListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Groups',
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ),
      body: StreamBuilder<List<GroupModel>>(
        stream: _groupService.getUserGroups(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildEmptyState(context, w, h);
          }

          final groups = snapshot.data!;
          return ListView.builder(
            itemCount: groups.length,
            itemBuilder: (context, index) {
              final group = groups[index];
              return GestureDetector(
                onTap: () => _navigateToGroupDetail(context, group),
                child: GroupItem(
                  group: group,
                  onLeave: () => _leaveGroup(context, group),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToCreateGroup(context),
        tooltip: 'Create New Group',
        child: const Icon(
          IconlyBold.plus,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, double w, double h) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/images/emptyGroups.svg",
            width: w * 0.7,
            height: h * 0.2,
          ),
          SizedBox(height: h * 0.05),
          const Text(
            "You're not in any groups yet!",
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: h * 0.02),
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              color: Colors.blue,
            ),
            child: const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                "Tap on the + icon to create one.",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToGroupDetail(BuildContext context, GroupModel group) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GroupDetailScreen(group: group)),
    );
  }

  void _leaveGroup(BuildContext context, GroupModel group) async {
    bool confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Leave Group'),
          content: Text('Are you sure you want to leave ${group.name}?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text('Leave'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (confirm) {
      try {
        await _groupService.leaveGroup(group.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You have left ${group.name}')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to leave group: $e')),
        );
      }
    }
  }

  void _navigateToCreateGroup(BuildContext context) async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => CreateGroupScreen()),
    );
    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Group created successfully')),
      );
    }
  }
}
