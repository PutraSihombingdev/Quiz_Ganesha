import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'services/auth_service.dart';

/// Fungsi utama aplikasi yang menjalankan widget root QuizPintarApp.
void main() {
  runApp(QuizPintarApp());
}

/// Widget utama aplikasi yang mendefinisikan tema dan halaman awal.
class QuizPintarApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz Ganesha',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: EntryPoint(), // Menentukan halaman awal berdasarkan status login
    );
  }
}

/// Widget Stateful yang memeriksa apakah pengguna sudah login atau belum.
class EntryPoint extends StatefulWidget {
  @override
  _EntryPointState createState() => _EntryPointState();
}

/// Menampilkan LoginScreen jika belum login, atau HomeScreen jika sudah login.
class _EntryPointState extends State<EntryPoint> {
  String? _username;
  bool _isChecking = true; // Indikator loading saat memeriksa login

  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // Mengecek login saat init
  }

  /// Mengecek status login dari SharedPreferences dan menyetel _username.
  void _checkLoginStatus() async {
    String? username = await AuthService().getLoggedInUser();
    setState(() {
      _username = username;
      _isChecking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()), // Loading saat pengecekan
      );
    }

    return _username == null ? LoginScreen() : HomeScreen(); // Mengarahkan berdasarkan status login
  }
}
