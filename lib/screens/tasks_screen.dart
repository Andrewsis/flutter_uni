import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; 

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
    _loadTasks(); 
  }

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasksString = prefs.getString('tasks_key'); // Читаємо рядок

    if (tasksString != null) {
      final List<dynamic> decodedList = jsonDecode(tasksString);
      setState(() {
        tasks = decodedList.map((item) => item as Map<String, dynamic>).toList();
      });
    } else {
      setState(() {
        tasks = [
          {'title': 'Приклад завдання', 'deadline': 'Завтра', 'desc': 'Це демо-завдання'}
        ];
      });
    }
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(tasks); 
    await prefs.setString('tasks_key', encodedData); 
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
                  _saveTasks(); 
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
    _saveTasks(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F2),
      appBar: AppBar(title: const Text('Завдання та Дедлайни')),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2D6A4F),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onPressed: _addNewTask,
        child: const Icon(Icons.add),
      ),
      body: tasks.isEmpty
          ? const Center(child: Text("Завдань немає. Відпочивайте!"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero, 
                    side: BorderSide(color: Color(0xFFD8E2DC), width: 1),
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(left: BorderSide(color: Color(0xFF40916C), width: 6)),
                    ),
                    child: ListTile(
                      title: Text(task['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${task['desc']}\nДедлайн: ${task['deadline']}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.check_circle_outline, color: Colors.teal),
                        onPressed: () => _deleteTask(index),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}