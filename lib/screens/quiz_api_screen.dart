import 'package:flutter/material.dart';
import '../models/question_api.dart';
import '../services/quiz_api_service.dart';

class QuizAPIScreen extends StatefulWidget {
  @override
  _QuizAPIScreenState createState() => _QuizAPIScreenState();
}

class _QuizAPIScreenState extends State<QuizAPIScreen> with SingleTickerProviderStateMixin {
  List<QuestionAPI> _questions = [];
  int _currentIndex = 0;
  int _score = 0;
  bool _isLoading = true;
  bool _quizCompleted = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  String? _selectedAnswer;
  bool _showFeedback = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _loadQuestions();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _loadQuestions() async {
    try {
      final questions = await QuizAPIService().fetchQuestions();
      setState(() {
        _questions = questions;
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _checkAnswer(String selected) async {
    setState(() {
      _selectedAnswer = selected;
      _showFeedback = true;
    });

    await _animationController.forward();

    Future.delayed(Duration(milliseconds: 800), () {
      if (_questions[_currentIndex].correctAnswer == selected) {
        _score++;
      }

      if (_currentIndex + 1 < _questions.length) {
        setState(() {
          _currentIndex++;
          _selectedAnswer = null;
          _showFeedback = false;
          _animationController.reset();
        });
      } else {
        setState(() {
          _quizCompleted = true;
        });
      }
    });
  }

  Color _getOptionColor(String option) {
    if (!_showFeedback) return Colors.deepPurple;
    if (option == _questions[_currentIndex].correctAnswer) {
      return Colors.green;
    } else if (option == _selectedAnswer && option != _questions[_currentIndex].correctAnswer) {
      return Colors.red;
    }
    return Colors.deepPurple;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
              ),
              SizedBox(height: 20),
              Text(
                'Memuat soal...'
              ),
            ],
          ),
        ),
      );
    }

    if (_quizCompleted) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF6A11CB),
                Color(0xFF2575FC),
              ],
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
                      backgroundColor: Colors.white, // pengganti primary
                      foregroundColor: Colors.deepPurple, // pengganti onPrimary
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
              // Progress bar
              Container(
                height: 12,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  gradient: LinearGradient(
                    colors: [Colors.deepPurple, Colors.purpleAccent],
                  ),
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
              SizedBox(height: 30),
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    question.question,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              if (_showFeedback) ...[
                SizedBox(height: 20),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _selectedAnswer == question.correctAnswer ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _selectedAnswer == question.correctAnswer ? Colors.green : Colors.red,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _selectedAnswer == question.correctAnswer ? Icons.check_circle : Icons.cancel,
                          color: _selectedAnswer == question.correctAnswer ? Colors.green : Colors.red,
                        ),
                        SizedBox(width: 10),
                        Text(
                          _selectedAnswer == question.correctAnswer ? 'Benar!' : 'Jawaban: ${question.correctAnswer}',
                          style: TextStyle(fontSize: 18, color: _selectedAnswer == question.correctAnswer ? Colors.green : Colors.red),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              SizedBox(height: 30),
              Expanded(
                child: ListView.builder(
                  itemCount: question.options.length,
                  itemBuilder: (context, index) {
                    final option = question.options[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 15),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: _getOptionColor(option),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ListTile(
                          title: Center(
                            child: Text(
                              option,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),
                            ),
                          ),
                          onTap: _showFeedback ? null : () => _checkAnswer(option),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}