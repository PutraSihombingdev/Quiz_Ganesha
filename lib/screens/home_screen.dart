import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiz_ganesha/screens/quiz_api_screen.dart';
import 'quiz_screen.dart';
import 'leaderboad_screen.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'input_question_screen.dart';
import 'list_question_screen.dart';
import 'scan_qr_code_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final features = [
      _FeatureData('Mulai Quiz', Icons.quiz, [Color(0xFFFF416C), Color(0xFFFF4B2B)], () => Navigator.push(context, MaterialPageRoute(builder: (context) => QuizScreen()))),
      _FeatureData('Quiz English', Icons.language, [Color(0xFF0575E6), Color(0xFF021B79)], () => Navigator.push(context, MaterialPageRoute(builder: (context) => QuizAPIScreen()))),
      _FeatureData('Scan QR Code', Icons.qr_code_scanner, [Color(0xFF0F2027), Color(0xFF2C5364)], () => Navigator.push(context, MaterialPageRoute(builder: (context) => ScanQrCodeScreen()))),
      _FeatureData('Riwayat Skor', Icons.history, [Color(0xFFF7971E), Color(0xFFFFD200)], () => Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryScreen()))),
      _FeatureData('Input Soal', Icons.edit_note, [Color(0xFF8E2DE2), Color(0xFF4A00E0)], () => Navigator.push(context, MaterialPageRoute(builder: (context) => InputQuestionScreen()))),
      _FeatureData('List Soal', Icons.list_alt, [Color(0xFFDA22FF), Color(0xFF9733EE)], () => Navigator.push(context, MaterialPageRoute(builder: (context) => ListQuestionScreen()))),
    ];

    return Scaffold(
      backgroundColor: Color(0xFFF0F2F5),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Quiz Ganesha',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 8,
                      color: Colors.black26,
                    ),
                  ],
                ),
              ),
              centerTitle: true,
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.logout, color: Colors.white),
                onPressed: () async {
                  await AuthService().logout();
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                tooltip: 'Logout',
              ),
            ],
          ),
          SliverPadding(
            padding: EdgeInsets.all(16),
            sliver: SliverGrid.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1,
              ),
              itemCount: features.length,
              itemBuilder: (context, index) {
                return ScaleTransition(
                  scale: _animation,
                  child: _FeatureCard(feature: features[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureData {
  final String title;
  final IconData icon;
  final List<Color> gradientColors;
  final VoidCallback onTap;

  _FeatureData(this.title, this.icon, this.gradientColors, this.onTap);
}

class _FeatureCard extends StatelessWidget {
  final _FeatureData feature;

  const _FeatureCard({required this.feature});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: feature.onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: feature.gradientColors,
            ),
            boxShadow: [
              BoxShadow(
                color: feature.gradientColors[1].withOpacity(0.3),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.15),
                  radius: 28,
                  child: Icon(feature.icon, color: Colors.white, size: 28),
                ),
                const SizedBox(height: 16),
                Text(
                  feature.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
