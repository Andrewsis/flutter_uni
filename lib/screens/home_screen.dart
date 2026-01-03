import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
                decoration: const BoxDecoration(
                  color: Color(0xFF2D6A4F),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(80),
                  ),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Вітаємо,',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    Text(
                      'Студентський Портал',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 35),

              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ГОЛОВНЕ МЕНЮ',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF2D6A4F),
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.5, 
                      children: [
                        _buildMenuCard(
                          context,
                          'Дедлайни',
                          Icons.assignment_outlined,
                          '/tasks',
                        ),
                        _buildMenuCard(
                          context,
                          'Профіль',
                          Icons.account_box_outlined,
                          '/profile',
                        ),
                        _buildMenuCard(
                          context,
                          'Здоров\'я',
                          Icons.spa_outlined,
                          '/health',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, String title, IconData icon, String route) {
    return Material(
      color: Colors.white,
      
      borderRadius: BorderRadius.circular(4),
      elevation: 2,
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, route),
        
        splashColor: const Color(0xFFD8E2DC),
        hoverColor: const Color(0xFFF1F8F5),
        borderRadius: BorderRadius.circular(4),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: const Color(0xFF2D6A4F), width: 4),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 28, color: const Color(0xFF2D6A4F)),
              const SizedBox(height: 8),
              Text(
                title.toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Color(0xFF1B4332),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}