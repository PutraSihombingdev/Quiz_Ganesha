import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiz_ganesha/screens/quiz_api_screen.dart';
import 'quiz_screen.dart';
import 'riwayat_skor_screen.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'input_question_screen.dart';
import 'list_question_screen.dart';
import 'scan_qr_code_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Color _primaryColor = Color(0xFF6A11CB);
  final Color _secondaryColor = Color(0xFF8E2DE2); // Gradasi ungu

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [_primaryColor, _secondaryColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Quiz Ganesha',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.logout, color: Colors.white),
                      onPressed: () async {
                        await AuthService().logout();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => LoginScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Pilih quiz yang ingin kamu kerjakan',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              SizedBox(height: 20),

              // Main Content
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Quiz Buttons
                      _buildMainButton(
                        context,
                        icon: Icons.quiz,
                        label: 'Kuis Bahasa Indonesia',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => QuizScreen()),
                        ),
                        color: Colors.deepPurple,
                      ),
                      SizedBox(height: 12),
                      _buildMainButton(
                        context,
                        icon: Icons.language,
                        label: 'Quiz Bahasa Inggris',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => QuizAPIScreen()),
                        ),
                        color: Colors.purpleAccent,
                      ),
                      SizedBox(height: 24),

                      // Grid Menu
                      Expanded(
                        child: GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1,
                          children: [
                            _buildGridButton(
                              icon: Icons.qr_code_scanner,
                              label: 'Scan QR Code',
                              color: Colors.redAccent,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => ScanQrCodeScreen()),
                              ),
                            ),
                            _buildGridButton(
                              icon: Icons.history,
                              label: 'Riwayat Skor',
                              color: Colors.teal,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => HistoryScreen()),
                              ),
                            ),
                            _buildGridButton(
                              icon: Icons.edit_note,
                              label: 'Input Soal',
                              color: Colors.orangeAccent,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => InputQuestionScreen()),
                              ),
                            ),
                            _buildGridButton(
                              icon: Icons.list_alt,
                              label: 'List Soal',
                              color: Colors.indigo,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => ListQuestionScreen()),
                              ),
                            ),
                          ],
                        ),
                      ),
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

  Widget _buildMainButton(BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.4)),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.white),
              ),
              SizedBox(width: 16),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              SizedBox(height: 12),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}