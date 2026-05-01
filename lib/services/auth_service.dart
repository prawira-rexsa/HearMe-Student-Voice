class AuthService {
  static String? role;

  static Future<bool> login(String npm, String password) async {
    await Future.delayed(const Duration(seconds: 1));

    // contoh dummy data
    if (npm == 'admin' && password == '123') {
      role = 'admin';
      return true;
    } 
    else if (npm == '12345678' && password == '123') {
      role = 'user';
      return true;
    }

    return false;
  }
}