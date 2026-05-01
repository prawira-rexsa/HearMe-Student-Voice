import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final npmController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;
  bool isPasswordHidden = true;

  void handleLogin() async {
    String npm = npmController.text.trim();
    String password = passwordController.text.trim();

    if (npm.isEmpty || password.isEmpty) {
      _showCustomSnackBar("NPM & Password wajib diisi", Colors.orange);
      return;
    }

    setState(() => isLoading = true);
    bool success = await AuthService.login(npm, password);
    setState(() => isLoading = false);

    if (success) {
      String route = (AuthService.role == 'admin') ? '/admin' : '/home';
      Navigator.pushReplacementNamed(context, route);
    } else {
      _showCustomSnackBar("NPM atau Password salah", Colors.redAccent);
    }
  }

  void _showCustomSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menggunakan Stack agar background bisa fullscreen
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF667EEA), Color(0xFF764BA2)], // Modern Purple-Blue
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  // ICON / LOGO Placeholder
                  const Icon(Icons.forum_rounded, size: 80, color: Colors.white),
                  const SizedBox(height: 16),
                  const Text(
                    "HearMe",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const Text(
                    "Sampaikan keluhanmu dengan mudah",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 40),

                  // CARD LOGIN
                  Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Masuk",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 20),
                        
                        // NPM FIELD
                        _buildTextField(
                          controller: npmController,
                          label: "NPM",
                          icon: Icons.person_outline,
                          type: TextInputType.number,
                        ),
                        const SizedBox(height: 18),
                        
                        // PASSWORD FIELD
                        _buildTextField(
                          controller: passwordController,
                          label: "Password",
                          icon: Icons.lock_outline,
                          isPassword: true,
                        ),
                        const SizedBox(height: 30),

                        // LOGIN BUTTON
                        isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : SizedBox(
                                width: double.infinity,
                                height: 55,
                                child: ElevatedButton(
                                  onPressed: handleLogin,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF764BA2),
                                    foregroundColor: Colors.white,
                                    elevation: 5,
                                    shadowColor: Colors.purple.withOpacity(0.4),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  child: const Text(
                                    "LOGIN",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "© 2026 HearMe Team",
                    style: TextStyle(color: Colors.white60, fontSize: 12),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget Helper untuk merapikan kode TextField
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    TextInputType type = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? isPasswordHidden : false,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF764BA2)),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  isPasswordHidden ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () => setState(() => isPasswordHidden = !isPasswordHidden),
              )
            : null,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFF764BA2), width: 2),
        ),
      ),
    );
  }
}