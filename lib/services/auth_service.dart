import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'db_helper.dart';

/// AuthService menangani proses login, logout, dan pelacakan sesi pengguna.
/// PAke SQLite untuk verifikasi akun dan SharedPreferences untuk menyimpan sesi login.

class AuthService {
    /// Melakukan login dengan mencocokkan data dari database dan menyimpan username ke SharedPreferences jika berhasil.
  Future<bool> login(String username, String password) async {
    final db = await DBHelper().db;
    final res = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (res.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', username);
      return true;
    } else {
      return false;
    }
  }
  /// Menghapus sesi login pengguna dari SharedPreferences (logout).
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
  }
  /// Mengambil username yang sedang login dari SharedPreferences (cek sesi login aktif).
  Future<String?> getLoggedInUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }
}
