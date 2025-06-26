import 'package:flutter/material.dart';
import '../services/db_helper.dart';

class InputQuestionScreen extends StatefulWidget {
  @override
  _InputQuestionScreenState createState() => _InputQuestionScreenState();
}

class _InputQuestionScreenState extends State<InputQuestionScreen> {
  final questionController = TextEditingController();
  final optionAController = TextEditingController();
  final optionBController = TextEditingController();
  final optionCController = TextEditingController();
  final answerController = TextEditingController();

  bool _isLoading = false;

  void _saveQuestion() async {
    if (questionController.text.isEmpty ||
        optionAController.text.isEmpty ||
        optionBController.text.isEmpty ||
        optionCController.text.isEmpty ||
        answerController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Semua field wajib diisi!')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final db = await DBHelper().db;

      await db.insert('questions', {
        'question': questionController.text.trim(),
        'optionA': optionAController.text.trim(),
        'optionB': optionBController.text.trim(),
        'optionC': optionCController.text.trim(),
        'answer': answerController.text.trim(),
      });

      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Soal berhasil disimpan')),
      );

      Navigator.pop(context);
    } catch (e) {
      setState(() => _isLoading = false);
      debugPrint('❌ Error menyimpan soal: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan soal: $e')),
      );
    }
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.deepPurple),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.deepPurple),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Soal',style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        backgroundColor: Colors.deepPurple,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Silakan isi form berikut:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  buildTextField('Soal', questionController),
                  buildTextField('Pilihan A', optionAController),
                  buildTextField('Pilihan B', optionBController),
                  buildTextField('Pilihan C', optionCController),
                  buildTextField('Jawaban Benar', answerController),
                  SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.save),
                      label: Text('Simpan Soal'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _saveQuestion,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
