import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; 

class HealthScreen extends StatefulWidget {
  const HealthScreen({super.key});

  @override
  State<HealthScreen> createState() => _HealthScreenState();
}

class _HealthScreenState extends State<HealthScreen> {
  List<String> tips = [];

  List<Map<String, dynamic>> habits = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      tips = prefs.getStringList('health_tips') ?? [
        'Правило 20-20-20: Кожні 20 хв дивись на 20 м протягом 20 с.',
        'Пий воду кожну годину.',
      ];

      String? habitsString = prefs.getString('health_habits');
      if (habitsString != null) {
        List<dynamic> decoded = jsonDecode(habitsString);
        habits = decoded.map((item) => item as Map<String, dynamic>).toList();
      } else {
        habits = [
          {'title': 'Випити склянку води', 'done': false},
          {'title': 'Зробити розминку очей', 'done': false},
        ];
      }
    });
  }

  Future<void> _saveTips() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('health_tips', tips);
  }

  Future<void> _saveHabits() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('health_habits', jsonEncode(habits));
  }

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
                _saveTips(); 
                Navigator.pop(context);
              }
            },
            child: const Text('Додати'),
          ),
        ],
      ),
    );
  }

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
                _saveHabits(); 
                Navigator.pop(context);
              }
            },
            child: const Text('Додати'),
          ),
        ],
      ),
    );
  }

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Мої Поради:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                IconButton(onPressed: _addTip, icon: const Icon(Icons.add_circle, color: Colors.blue)),
              ],
            ),
            const SizedBox(height: 5),
            ...tips.asMap().entries.map((entry) {
            return Card(
                elevation: 0,
                color: const Color(0xFFD8E2DC).withOpacity(0.5),
                margin: const EdgeInsets.only(bottom: 10),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero, 
                ),
                child: ListTile(
                  leading: const Icon(Icons.eco, color: Color(0xFF2D6A4F)),
                  title: Text(entry.value, style: const TextStyle(fontSize: 14)),
                  trailing: IconButton(
                    icon: const Icon(Icons.close, size: 16),
                    onPressed: () => _deleteTip(entry.key),
                  ),
                ),
              );
            }),

            const Divider(height: 40),
            
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
                          _saveHabits(); 
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