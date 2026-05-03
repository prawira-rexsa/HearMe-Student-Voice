import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase
import 'firebase_options.dart'; // File hasil konfigurasi tadi
import 'screens/login_page.dart';
import 'screens/home_page.dart';
import 'screens/admin_page.dart';
import 'screens/register_page.dart';

void main() async {
  // 1. Pastikan binding Flutter sudah siap
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Inisialisasi Firebase dengan opsi otomatis
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HearMe - Keluhan Mahasiswa',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.deepPurple,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/admin': (context) => const AdminPage(),
        '/register': (context) => const RegisterPage(),
      },
    );
  }
}