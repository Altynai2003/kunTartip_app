import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../features/tasks/presentation/pages/main_screen.dart';
import '../core/providers/user_provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final TextEditingController _nameController = TextEditingController();
  bool _showLogin = false;

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  void _checkLogin() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await Future.delayed(const Duration(seconds: 2));
    if (userProvider.isLoggedIn) {
      _navigateToMain();
    } else {
      setState(() {
        _showLogin = true;
      });
    }
  }

  void _navigateToMain() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainScreen()),
    );
  }

  void _handleLogin() async {
    final name = _nameController.text.trim();
    if (name.isNotEmpty) {
      await Provider.of<UserProvider>(context, listen: false).saveName(name);
      _navigateToMain();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Сураныч, атыңызды жазыңыз')),
      );
    }
  }

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
            colors: [Color(0xFF2E7D32), Color(0xFF1565C0)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // LOGO
                TweenAnimationBuilder(
                  duration: const Duration(seconds: 1),
                  tween: Tween<double>(begin: 0, end: 1),
                  builder: (context, double value, child) {
                    return Transform.scale(scale: value, child: child);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.wb_sunny_rounded,
                      size: 80,
                      color: Colors.orange,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // TITLE
                Text(
                  "КүнТартип",
                  style: GoogleFonts.rubik(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  "Тартиптүү күн — ийгиликтүү жашоо",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.rubik(
                    fontSize: 16,
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                  ),
                ),

                const SizedBox(height: 60),

                if (!_showLogin)
                  const CircularProgressIndicator(color: Colors.white)
                else
                  Column(
                    children: [
                      TextField(
                        controller: _nameController,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                        decoration: InputDecoration(
                          hintText: 'Атыңыз ким?',
                          hintStyle: const TextStyle(
                            color: Color.fromARGB(255, 3, 3, 3),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: const Icon(
                            Icons.person_outline,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF2E7D32),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 5,
                          ),
                          onPressed: _handleLogin,
                          child: Text(
                            "Кирүү",
                            style: GoogleFonts.rubik(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
