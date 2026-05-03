import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final npmController = TextEditingController();
  final passwordController = TextEditingController();
  
  bool isLoading = false;
  bool isPasswordHidden = true; // UX: Tambah fitur sembunyikan password

  void handleRegister() async {
    String npm = npmController.text.trim();
    String password = passwordController.text.trim();

    if (npm.isEmpty || password.isEmpty) {
      _showCustomSnackBar("Semua kolom wajib diisi", Colors.orange);
      return;
    }

    // UX: Validasi minimal panjang password (contoh)
    if (password.length < 3) {
       _showCustomSnackBar("Password minimal 3 karakter", Colors.orange);
       return;
    }

    setState(() => isLoading = true);
    bool success = await AuthService.register(npm, password);
    setState(() => isLoading = false);

    if (success) {
      _showCustomSnackBar("Registrasi Berhasil! Silakan Login", Colors.green);
      // UX: Beri sedikit delay agar snackbar terbaca sebelum pindah halaman
      Future.delayed(const Duration(seconds: 1), () {
        if(mounted) Navigator.pop(context); // Kembali ke halaman login
      });
    } else {
      _showCustomSnackBar("NPM sudah terdaftar atau terjadi kesalahan server", Colors.redAccent);
    }
  }

  // UX: Gunakan gaya SnackBar yang sama dengan LoginPage
  void _showCustomSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // UX: Hilangkan AppBar bawaan agar gradient penuh
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            // Gunakan warna gradient yang sama dengan LoginPage
            colors: [Color(0xFF667EEA), Color(0xFF764BA2)], 
          ),
        ),
        child: SafeArea(
          child: Stack( // Gunakan Stack untuk tombol back manual
            children: [
              // Tombol Back manual di pojok kiri atas
              Positioned(
                top: 10,
                left: 10,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      // LOGO & JUDUL (Sama dengan LoginPage)
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
                        "Daftar akun untuk menyampaikan keluhan",
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      const SizedBox(height: 40),

                      // CARD REGISTER (Gaya sama dengan LoginPage)
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
                              "Pendaftaran",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 20),
                            
                            // NPM FIELD (Gunakan Helper Widget agar konsisten)
                            _buildTextField(
                              controller: npmController,
                              label: "NPM",
                              // Ganti ikon agar beda dikit dengan login (opsional)
                              icon: Icons.badge_outlined, 
                              type: TextInputType.number,
                            ),
                            const SizedBox(height: 18),
                            
                            // PASSWORD FIELD
                            _buildTextField(
                              controller: passwordController,
                              label: "Password Baru",
                              icon: Icons.lock_outline,
                              isPassword: true,
                            ),
                            const SizedBox(height: 30),

                            // REGISTER BUTTON
                            isLoading
                                ? const Center(child: CircularProgressIndicator())
                                : SizedBox(
                                    width: double.infinity,
                                    height: 55,
                                    child: ElevatedButton(
                                      onPressed: handleRegister,
                                      style: ElevatedButton.styleFrom(
                                        // Gunakan warna ungu primer yang sama
                                        backgroundColor: const Color(0xFF764BA2), 
                                        foregroundColor: Colors.white,
                                        elevation: 5,
                                        shadowColor: Colors.purple.withOpacity(0.4),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                      ),
                                      child: const Text(
                                        "DAFTAR SEKARANG",
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
                      // Footer (Opsional, disamakan)
                      const Text(
                        "© 2026 HearMe Team",
                        style: TextStyle(color: Colors.white60, fontSize: 12),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget Helper (Sama persis dengan LoginPage untuk konsistensi visual)
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