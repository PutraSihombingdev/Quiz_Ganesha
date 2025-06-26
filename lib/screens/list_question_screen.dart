import 'package:flutter/material.dart';
import '../services/db_helper.dart';
import 'edit_question_screen.dart';

class ListQuestionScreen extends StatefulWidget {
  @override
  _ListQuestionScreenState createState() => _ListQuestionScreenState();
}

class _ListQuestionScreenState extends State<ListQuestionScreen> {
  List<Map<String, dynamic>> _questions = [];

  void _loadQuestions() async {
    final db = await DBHelper().db;
    final data = await db.query('questions');
    setState(() {
      _questions = data;
    });
  }

  void _deleteQuestion(int id) async {
    final db = await DBHelper().db;
    await db.delete('questions', where: 'id = ?', whereArgs: [id]);
    _loadQuestions();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Soal berhasil dihapus')),
    );
  }

  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Hapus Soal'),
        content: Text('Apakah Anda yakin ingin menghapus soal ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteQuestion(id);
            },
            child: Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Daftar Soal',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: _questions.isEmpty
          ? Center(child: Text('Belum ada soal.'))
          : ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: _questions.length,
              itemBuilder: (context, index) {
                final q = _questions[index];
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                  margin: EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(
                      q['question'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('Jawaban Benar: ${q['answer']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.orange),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditQuestionScreen(
                                  questionData: q,
                                  onUpdate: _loadQuestions,
                                ),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _confirmDelete(q['id']),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
