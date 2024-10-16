import 'package:flutter/material.dart';
import 'package:study_mesh/features/profile/domain/profile_service.dart';
import 'package:study_mesh/features/profile/data/profile_model.dart';
import 'package:study_mesh/features/authentication/presentation/login_screen.dart';
import 'package:study_mesh/features/profile/presentation/edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileService _profileService = ProfileService();

  Future<void> _signOut() async {
    try {
      await _profileService.signOut();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: $e')),
      );
    }
  }

  Future<void> _navigateToEditProfile(ProfileModel profile) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(profile: profile),
      ),
    );

    if (result != null && result is ProfileModel) {
      setState(() {}); // Refresh the profile screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: Theme.of(context).textTheme.displayLarge),
      ),
      body: FutureBuilder<ProfileModel?>(
        future: _profileService.getCurrentUserProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No profile data available'),
                  ElevatedButton(
                    onPressed: () => setState(() {}),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          ProfileModel profile = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: profile.photoUrl != null
                      ? NetworkImage(profile.photoUrl!)
                      : null,
                  child: profile.photoUrl == null
                      ? const Icon(Icons.person, size: 50)
                      : null,
                ),
                const SizedBox(height: 16),
                Text(profile.name,
                    style: Theme.of(context).textTheme.displayMedium),
                const SizedBox(height: 8),
                Text(profile.email,
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 24),
                ListTile(
                  leading: const Icon(Icons.school),
                  title: const Text('Education'),
                  subtitle: Text(profile.education ?? 'Not specified'),
                ),
                ListTile(
                  leading: const Icon(Icons.work),
                  title: const Text('Occupation'),
                  subtitle: Text(profile.occupation ?? 'Not specified'),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => _navigateToEditProfile(profile),
                  child: const Text('Edit Profile'),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: _signOut,
                  child: const Text('Sign Out'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
