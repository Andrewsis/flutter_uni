import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Студентський Портал')),
      body: Center( // Center выравнивает всё по центру экрана
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Выравнивание по вертикали
            crossAxisAlignment: CrossAxisAlignment.stretch, // Растянуть кнопки по ширине
            children: [
              const Text(
                'Меню',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30), // Отступ
              
              // === ВОТ ВАШИ КНОПКИ ===
              
              // Кнопка 1: Задачи
              ElevatedButton.icon(
                icon: const Icon(Icons.list),
                label: const Text('Дедлайни (Tasks)'),
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(20)),
                onPressed: () {
                  // Переход по маршруту, который вы прописали в main.dart
                  Navigator.pushNamed(context, '/tasks');
                },
              ),
              
              const SizedBox(height: 15), // Отступ между кнопками
              
              // Кнопка 2: Профиль
              ElevatedButton.icon(
                icon: const Icon(Icons.person),
                label: const Text('Мій Профіль (Profile)'),
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(20)),
                onPressed: () {
                  Navigator.pushNamed(context, '/profile');
                },
              ),

              const SizedBox(height: 15),

              // Кнопка 3: Здоровье
              ElevatedButton.icon(
                icon: const Icon(Icons.favorite),
                label: const Text('Здоров\'я (Health)'),
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(20)),
                onPressed: () {
                  Navigator.pushNamed(context, '/health');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}