import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:study_mesh/config/theme.dart';
import 'package:study_mesh/features/authentication/presentation/login_screen.dart';
import 'package:study_mesh/firebase_options.dart';
import 'package:study_mesh/services/auth_service.dart';
import 'package:study_mesh/shared/widgets/bottom_navigation.dart';
import 'package:study_mesh/shared/widgets/loading_screen.dart';

import 'services/notfication_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
  final notificationService = NotificationService();
  await notificationService.initialize();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Collaborative Study Platform',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: StreamBuilder<User?>(
        stream: AuthService().authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User? user = snapshot.data;
            if (user == null) {
              return MaterialApp(
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: ThemeMode.system,
                home: const LoginScreen(),
              );
            }
            return MaterialApp(
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: ThemeMode.system,
              home: const BottomNavigation(),
            );
          }
          return const LoadingScreen(message: "Initializing StudyMesh");
        },
      ),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const BottomNavigation(),
      },
    );
  }
}
