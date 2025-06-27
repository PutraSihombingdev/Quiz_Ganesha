import 'package:flutter/material.dart';
import '../services/db_helper.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isLoading = false;

  void _register() async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      _showMessage("Username dan Password tidak boleh kosong");
      return;
    }

    if (password.length < 4) {
      _showMessage("Password minimal 4 karakter");
      return;
    }

    setState(() => _isLoading = true);

    final db = await DBHelper().db;
    final existing = await db.query('users', where: 'username = ?', whereArgs: [username]);

    if (existing.isNotEmpty) {
      _showMessage("Username sudah digunakan");
      setState(() => _isLoading = false);
      return;
    }

    await db.insert('users', {
      'username': username,
      'password': password,
      'score': 0,
      'timestamp': DateTime.now().toIso8601String(),
    });

    setState(() => _isLoading = false);
    _showMessage("Registrasi berhasil, silakan login");
    Navigator.pop(context);
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Colors.deepPurple;

    return Scaffold(
      backgroundColor: themeColor.shade50,
      appBar: AppBar(
        backgroundColor: themeColor,
        title: Text("Registrasi", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Center(
        child: Card(
          margin: EdgeInsets.all(24),
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: _isLoading
                ? CircularProgressIndicator()
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Buat Akun Baru",
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: themeColor)),
                      SizedBox(height: 20),
                      TextField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          labelText: "Username",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Password",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: themeColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Text("Daftar", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                        ),
                      )
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}