import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // Потрібно для перетворення в JSON

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  List<Map<String, dynamic>> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks(); // Завантажуємо дані при старті
  }

  // 1. ЗАВАНТАЖЕННЯ ДАНИХ
  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasksString = prefs.getString('tasks_key'); // Читаємо рядок

    if (tasksString != null) {
      // Якщо дані є, перетворюємо текст назад у список
      final List<dynamic> decodedList = jsonDecode(tasksString);
      setState(() {
        tasks = decodedList.map((item) => item as Map<String, dynamic>).toList();
      });
    } else {
      // Якщо даних немає (перший запуск), додаємо стартовий приклад
      setState(() {
        tasks = [
          {'title': 'Приклад завдання', 'deadline': 'Завтра', 'desc': 'Це демо-завдання'}
        ];
      });
    }
  }

  // 2. ЗБЕРЕЖЕННЯ ДАНИХ
  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(tasks); // Перетворюємо список у текст
    await prefs.setString('tasks_key', encodedData); // Зберігаємо
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  void _addNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Новий дедлайн'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: _titleController, decoration: const InputDecoration(labelText: 'Предмет')),
              TextField(controller: _dateController, decoration: const InputDecoration(labelText: 'Дата')),
              TextField(controller: _descController, decoration: const InputDecoration(labelText: 'Опис')),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Скасувати')),
            ElevatedButton(
              onPressed: () {
                if (_titleController.text.isNotEmpty) {
                  setState(() {
                    tasks.add({
                      'title': _titleController.text,
                      'deadline': _dateController.text,
                      'desc': _descController.text,
                    });
                  });
                  _saveTasks(); // <--- ЗБЕРІГАЄМО ПІСЛЯ ДОДАВАННЯ
                  _titleController.clear();
                  _dateController.clear();
                  _descController.clear();
                  Navigator.pop(context);
                }
              },
              child: const Text('Додати'),
            ),
          ],
        );
      },
    );
  }

  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
    _saveTasks(); // <--- ЗБЕРІГАЄМО ПІСЛЯ ВИДАЛЕННЯ
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Завдання та Дедлайни')),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewTask,
        child: const Icon(Icons.add),
      ),
      body: tasks.isEmpty
          ? const Center(child: Text("Немає завдань."))
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Dismissible(
                  key: UniqueKey(), // Унікальний ключ для видалення
                  onDismissed: (direction) => _deleteTask(index),
                  background: Container(color: Colors.red, child: const Icon(Icons.delete, color: Colors.white)),
                  child: Card(
                    child: ListTile(
                      leading: CircleAvatar(child: const Icon(Icons.assignment)),
                      title: Text(task['title']),
                      subtitle: Text('${task['desc']}\nДедлайн: ${task['deadline']}'),
                      isThreeLine: true,
                    ),
                  ),
                );
              },
            ),
    );
  }
}