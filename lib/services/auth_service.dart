import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static String? role;
  static String? currentNpm;

  // ================= LOGIN =================
  static Future<bool> login(String npm, String password) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(npm)
          .get();

      if (doc.exists) {
        final data = doc.data()!;

        if (data['password'] == password) {
          role = data['role'];
          currentNpm = npm;

          // simpan ke local
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('role', role!);
          await prefs.setString('npm', npm);

          return true;
        }
      }
      return false;
    } catch (e) {
      print("Login error: $e");
      return false;
    }
  }

  // ================= REGISTER =================
  static Future<bool> register(String npm, String password) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(npm)
          .get();

      if (doc.exists) return false;

      await FirebaseFirestore.instance.collection('users').doc(npm).set({
        'npm': npm,
        'password': password,
        'role': 'user',
        'createdAt': FieldValue.serverTimestamp(),
      });

      return true;
    } catch (e) {
      print("Register error: $e");
      return false;
    }
  }

  // ================= LOAD SESSION =================
  static Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    role = prefs.getString('role');
    currentNpm = prefs.getString('npm');
  }

  // ================= LOGOUT =================
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    role = null;
    currentNpm = null;
  }
}