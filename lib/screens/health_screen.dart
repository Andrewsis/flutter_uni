import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // Потрібно для збереження складних списків (JSON)

class HealthScreen extends StatefulWidget {
  const HealthScreen({super.key});

  @override
  State<HealthScreen> createState() => _HealthScreenState();
}

class _HealthScreenState extends State<HealthScreen> {
  // 1. Список порад (просто текст)
  List<String> tips = [];

  // 2. Список звичок (назва + статус виконано/ні)
  List<Map<String, dynamic>> habits = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // --- ЗАВАНТАЖЕННЯ ДАНИХ ---
  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // Завантажуємо поради
      tips = prefs.getStringList('health_tips') ?? [
        'Правило 20-20-20: Кожні 20 хв дивись на 20 м протягом 20 с.',
        'Пий воду кожну годину.',
      ];

      // Завантажуємо звички (декодуємо з JSON)
      String? habitsString = prefs.getString('health_habits');
      if (habitsString != null) {
        List<dynamic> decoded = jsonDecode(habitsString);
        habits = decoded.map((item) => item as Map<String, dynamic>).toList();
      } else {
        // Дефолтні звички для старту
        habits = [
          {'title': 'Випити склянку води', 'done': false},
          {'title': 'Зробити розминку очей', 'done': false},
        ];
      }
    });
  }

  // --- ЗБЕРЕЖЕННЯ ДАНИХ ---
  Future<void> _saveTips() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('health_tips', tips);
  }

  Future<void> _saveHabits() async {
    final prefs = await SharedPreferences.getInstance();
    // Перетворюємо список об'єктів у текст JSON
    await prefs.setString('health_habits', jsonEncode(habits));
  }

  // --- ДОДАВАННЯ ПОРАДИ ---
  void _addTip() {
    TextEditingController tipCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Нова порада'),
        content: TextField(
          controller: tipCtrl,
          decoration: const InputDecoration(labelText: 'Текст поради'),
          maxLines: 2,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Скасувати')),
          ElevatedButton(
            onPressed: () {
              if (tipCtrl.text.isNotEmpty) {
                setState(() {
                  tips.add(tipCtrl.text);
                });
                _saveTips(); // Зберігаємо
                Navigator.pop(context);
              }
            },
            child: const Text('Додати'),
          ),
        ],
      ),
    );
  }

  // --- ДОДАВАННЯ ЗВИЧКИ ---
  void _addHabit() {
    TextEditingController habitCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Нова звичка'),
        content: TextField(controller: habitCtrl, decoration: const InputDecoration(labelText: 'Що треба робити?')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Скасувати')),
          ElevatedButton(
            onPressed: () {
              if (habitCtrl.text.isNotEmpty) {
                setState(() {
                  habits.add({'title': habitCtrl.text, 'done': false});
                });
                _saveHabits(); // Зберігаємо
                Navigator.pop(context);
              }
            },
            child: const Text('Додати'),
          ),
        ],
      ),
    );
  }

  // Видалення елементів (свайпом або кнопкою)
  void _deleteTip(int index) {
    setState(() {
      tips.removeAt(index);
    });
    _saveTips();
  }

  void _deleteHabit(int index) {
    setState(() {
      habits.removeAt(index);
    });
    _saveHabits();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Здоров\'я та Фокус')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- СЕКЦІЯ ПОРАД ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Мої Поради:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                IconButton(onPressed: _addTip, icon: const Icon(Icons.add_circle, color: Colors.blue)),
              ],
            ),
            const SizedBox(height: 5),
            ...tips.asMap().entries.map((entry) {
              int idx = entry.key;
              String text = entry.value;
              return Card(
                color: Colors.blue[50],
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: const Icon(Icons.lightbulb, color: Colors.orange),
                  title: Text(text),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, size: 20, color: Colors.grey),
                    onPressed: () => _deleteTip(idx),
                  ),
                ),
              );
            }),

            const Divider(height: 40, thickness: 2),

            // --- СЕКЦІЯ ТРЕКЕРА ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Трекер звичок:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                IconButton(onPressed: _addHabit, icon: const Icon(Icons.add_task, color: Colors.green)),
              ],
            ),
            const SizedBox(height: 5),
            habits.isEmpty 
              ? const Text("Додай свою першу звичку!", style: TextStyle(color: Colors.grey))
              : Column(
                  children: habits.asMap().entries.map((entry) {
                    int idx = entry.key;
                    var habit = entry.value;
                    return Dismissible(
                      key: UniqueKey(),
                      onDismissed: (dir) => _deleteHabit(idx),
                      background: Container(color: Colors.red),
                      child: CheckboxListTile(
                        title: Text(habit['title']),
                        value: habit['done'],
                        activeColor: Colors.green,
                        onChanged: (bool? val) {
                          setState(() {
                            habit['done'] = val;
                          });
                          _saveHabits(); // Зберігаємо стан галочки
                        },
                      ),
                    );
                  }).toList(),
                ),
          ],
        ),
      ),
    );
  }
}