import 'dart:io'; 
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart'; 
import 'package:path_provider/path_provider.dart'; 
import 'package:path/path.dart' as path; 

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String fullName = 'Завантаження...';
  String group = '';
  String email = '';
  String? imagePath; 

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
      imagePath = prefs.getString('profile_image'); 
    });
  }

  Future<void> _saveProfile(String n, String g, String e) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', n);
    await prefs.setString('group', g);
    await prefs.setString('email', e);
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final directory = await getApplicationDocumentsDirectory();
      
      final String fileName = path.basename(image.path);
      final String localPath = path.join(directory.path, fileName);

      final File localImage = await File(image.path).copy(localPath);

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
    ImageProvider avatarImage;
    if (imagePath != null && File(imagePath!).existsSync()) {
      avatarImage = FileImage(File(imagePath!)); 
    } else {
      avatarImage = const AssetImage('assets/student_photo.jpg'); 
    }

  return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Профіль студента'),
        actions: [IconButton(onPressed: _editProfile, icon: const Icon(Icons.settings))],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF2D6A4F), width: 2),
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      radius: 65,
                      backgroundImage: avatarImage,
                    ),
                  ),
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: FloatingActionButton.small(
                      onPressed: _pickImage,
                      backgroundColor: const Color(0xFF52B788),
                      child: const Icon(Icons.edit, size: 18),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            Text(fullName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFF1B4332))),
            const Text('Студент університету', style: TextStyle(color: Colors.grey, letterSpacing: 1.1)),
            const SizedBox(height: 30),
            
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF7FDF9),
                border: Border.all(color: const Color(0xFFB7E4C7)),
              ),
              child: Column(
                children: [
                  _buildInfoRow('ГРУПА', group),
                  const Divider(height: 1, color: Color(0xFFB7E4C7)),
                  _buildInfoRow('EMAIL', email),
                ],
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