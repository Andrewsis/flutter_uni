import 'package:flutter/material.dart';
// Импортируем наши экраны
import 'screens/home_screen.dart';
import 'screens/tasks_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/health_screen.dart';

void main() {
  runApp(const StudentPortalApp());
}

class StudentPortalApp extends StatelessWidget {
  const StudentPortalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Убирает надпись DEBUG
      title: 'Student Portal',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      // ГЛАВНОЕ: Мы говорим, что при запуске нужно открыть '/'
      initialRoute: '/',
      // И объясняем, что '/' — это HomeScreen
      routes: {
        '/': (context) => const HomeScreen(),
        '/tasks': (context) => const TasksScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/health': (context) => const HealthScreen(),
      },
    );
  }
}