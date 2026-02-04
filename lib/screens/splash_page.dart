import 'package:flutter/material.dart';
import '../features/tasks/presentation/pages/main_screen.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF4CAF50), Color(0xFF2196F3)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ИКОНКА
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.wb_sunny_rounded,
                size: 64,
                color: Colors.orange,
              ),
            ),

            const SizedBox(height: 30),

            // АТЫ
            const Text(
              "КүнТартип",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 10),

            // СЛОГАН
            const Text(
              "Тартиптүү күн — ийгиликтүү жашоо",
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),

            const SizedBox(height: 40),

            // УЛАНТУУ БАСМЫЧЫ
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF4CAF50),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const MainScreen()),
                );
              },
              child: const Text("Баштоо", style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
