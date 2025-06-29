  import 'dart:io';
  import 'package:flutter/material.dart';
  import 'package:image_picker/image_picker.dart';
  import 'package:shared_preferences/shared_preferences.dart';
  import '../services/db_helper.dart';

  class QuizScreen extends StatefulWidget {
    @override
    _QuizScreenState createState() => _QuizScreenState();
  }

  class _QuizScreenState extends State<QuizScreen> {
    List<Map<String, dynamic>> _questions = [];
    int _currentIndex = 0;
    int _score = 0;
    bool _quizCompleted = false;
    File? _image;

    @override
    void initState() {
      super.initState();
      _loadQuestions();
    }

    void _loadQuestions() async {
      final db = await DBHelper().db;
      final data = await db.query('questions');
      setState(() {
        _questions = data;
      });
    }

    void _saveScore() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? username = prefs.getString('username');
      final db = await DBHelper().db;
      await db.update('users', {'score': _score}, where: 'username = ?', whereArgs: [username]);
    }

    void _checkAnswer(String selected) {
      if (_questions[_currentIndex]['answer'] == selected) {
        _score++;
      }

      if (_currentIndex + 1 < _questions.length) {
        setState(() {
          _currentIndex++;
          _image = null; // reset image per soal
        });
      } else {
        setState(() {
          _quizCompleted = true;
        });
        _saveScore();
      }
    }

    Future<void> _pickImage() async {
      final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (picked != null) {
        setState(() {
          _image = File(picked.path);
        });
      }
    }

    @override
    Widget build(BuildContext context) {
      if (_questions.isEmpty) {
        return Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

      if (_quizCompleted) {
        return Scaffold(
          body: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.celebration, size: 80, color: Colors.white),
                  SizedBox(height: 30),
                  Text('Quiz Selesai!', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                  SizedBox(height: 20),
                  Text('Skor Anda:', style: TextStyle(fontSize: 24, color: Colors.white.withOpacity(0.8))),
                  SizedBox(height: 10),
                  Text('$_score dari ${_questions.length}', style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white)),
                  SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Kembali ke Beranda', style: TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.deepPurple,
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      final question = _questions[_currentIndex];
      final progress = (_currentIndex + 1) / _questions.length;

      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 12,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    gradient: LinearGradient(colors: [Colors.deepPurple, Colors.purpleAccent]),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: progress,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Soal ${_currentIndex + 1}/${_questions.length}', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                    Text('Skor: $_score', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                  ],
                ),
                SizedBox(height: 20),

  if (question['imagePath'] != null && question['imagePath'].toString().isNotEmpty)
    Container(
      height: 180,
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: FileImage(File(question['imagePath'])),
          fit: BoxFit.cover,
        ),
      ),
    ),


                SizedBox(height: 20),

                Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      question['question'],
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                _buildOption(question['optionA']),
                _buildOption(question['optionB']),
                _buildOption(question['optionC']),
                Spacer(),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text('Skor sementara: $_score', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                )
              ],
            ),
          ),
        ),
      );
    }

    Widget _buildOption(String text) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: ElevatedButton(
          onPressed: () => _checkAnswer(text),
          child: Text(text),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 48),
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      );
    }
  }
