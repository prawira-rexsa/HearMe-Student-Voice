import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  // Simpan role di sini agar bisa diakses oleh Navigator di LoginPage
  static String? role;

  static Future<bool> login(String npm, String password) async {
    try {
      // 1. Hubungkan ke koleksi 'users' di Firestore
      // Cari dokumen yang field 'npm'-nya cocok dengan input
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('users')
          .where('npm', isEqualTo: npm)
          .limit(1)
          .get();

      // 2. Cek apakah user ditemukan
      if (result.docs.isNotEmpty) {
        var userData = result.docs.first.data() as Map<String, dynamic>;

        // 3. Validasi password (plain text untuk tahap awal)
        if (userData['password'] == password) {
          // Simpan role dari database ke variabel static
          role = userData['role']; 
          return true;
        }
      }
      
      // Jika user tidak ditemukan atau password salah
      return false;
      
    } catch (e) {
      // Print error ke console untuk debugging
      print("Error saat login: $e");
      return false;
    }
  }

  static Future<bool> register(String npm, String password) async {
  try {
    // Cek dulu apakah NPM sudah terdaftar
    final existingUser = await FirebaseFirestore.instance
        .collection('users')
        .where('npm', isEqualTo: npm)
        .get();

    if (existingUser.docs.isNotEmpty) {
      return false; // NPM sudah ada
    }

    // Simpan user baru ke Firestore
    await FirebaseFirestore.instance.collection('users').add({
      'npm': npm,
      'password': password,
      'role': 'user', // Default sebagai user biasa
      'createdAt': FieldValue.serverTimestamp(),
    });

    return true;
  } catch (e) {
    print("Error Register: $e");
    return false;
  }
}

}