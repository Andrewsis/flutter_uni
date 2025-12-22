import 'dart:io'; // Потрібно для роботи з файлами (File)
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart'; // Для вибору фото
import 'package:path_provider/path_provider.dart'; // Щоб знайти куди зберегти
import 'package:path/path.dart' as path; // Для роботи з іменами файлів

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String fullName = 'Завантаження...';
  String group = '';
  String email = '';
  String? imagePath; // Тут буде шлях до нашого фото

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      fullName = prefs.getString('name') ?? 'Петренко Петро';
      group = prefs.getString('group') ?? 'КН-301';
      email = prefs.getString('email') ?? 'student@univ.edu';
      imagePath = prefs.getString('profile_image'); // Завантажуємо шлях до фото
    });
  }

  Future<void> _saveProfile(String n, String g, String e) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', n);
    await prefs.setString('group', g);
    await prefs.setString('email', e);
  }

  // --- ЛОГІКА ВИБОРУ ФОТО ---
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    // Відкриваємо галерею
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      // 1. Отримуємо папку, де програма може зберігати файли
      final directory = await getApplicationDocumentsDirectory();
      
      // 2. Створюємо нове ім'я файлу (наприклад, my_avatar.jpg)
      final String fileName = path.basename(image.path);
      final String localPath = path.join(directory.path, fileName);

      // 3. Копіюємо обране фото в нашу папку (щоб воно не зникло)
      final File localImage = await File(image.path).copy(localPath);

      // 4. Зберігаємо шлях у SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_image', localPath);

      setState(() {
        imagePath = localPath;
      });
    }
  }

  void _editProfile() {
    TextEditingController nameCtrl = TextEditingController(text: fullName);
    TextEditingController groupCtrl = TextEditingController(text: group);
    TextEditingController emailCtrl = TextEditingController(text: email);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Редагування профілю'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'ПІБ')),
            TextField(controller: groupCtrl, decoration: const InputDecoration(labelText: 'Група')),
            TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Email')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Скасувати')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                fullName = nameCtrl.text;
                group = groupCtrl.text;
                email = emailCtrl.text;
              });
              _saveProfile(fullName, group, email);
              Navigator.pop(context);
            },
            child: const Text('Зберегти'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Визначаємо, яке фото показувати
    ImageProvider avatarImage;
    if (imagePath != null && File(imagePath!).existsSync()) {
      avatarImage = FileImage(File(imagePath!)); // Фото з файлу
    } else {
      avatarImage = const AssetImage('assets/student_photo.jpg'); // Дефолтне фото
      // Якщо у вас немає файлу assets/student_photo.jpg, розкоментуйте рядок нижче:
      // avatarImage = const NetworkImage('https://cdn-icons-png.flaticon.com/512/3135/3135715.png');
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Профіль'),
        actions: [IconButton(onPressed: _editProfile, icon: const Icon(Icons.edit))],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // --- АВАТАР З КНОПКОЮ КАМЕРИ ---
            Stack(
              children: [
                CircleAvatar(
                  radius: 70,
                  backgroundImage: avatarImage,
                  backgroundColor: Colors.grey[200],
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _pickImage, // Натискання викликає вибір фото
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.blueAccent,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            Text(fullName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            
            Card(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    _buildInfoRow('Група', group),
                    const Divider(),
                    _buildInfoRow('Email', email),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}