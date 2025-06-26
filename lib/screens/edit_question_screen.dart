import 'package:flutter/material.dart';
import '../services/db_helper.dart';

class EditQuestionScreen extends StatefulWidget {
  final Map<String, dynamic> questionData;
  final VoidCallback onUpdate;

  EditQuestionScreen({required this.questionData, required this.onUpdate});

  @override
  _EditQuestionScreenState createState() => _EditQuestionScreenState();
}

class _EditQuestionScreenState extends State<EditQuestionScreen> {
  late TextEditingController questionController;
  late TextEditingController optionAController;
  late TextEditingController optionBController;
  late TextEditingController optionCController;
  late TextEditingController answerController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    questionController = TextEditingController(text: widget.questionData['question']);
    optionAController = TextEditingController(text: widget.questionData['optionA']);
    optionBController = TextEditingController(text: widget.questionData['optionB']);
    optionCController = TextEditingController(text: widget.questionData['optionC']);
    answerController = TextEditingController(text: widget.questionData['answer']);
  }

  void _updateQuestion() async {
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

    final db = await DBHelper().db;
    await db.update(
      'questions',
      {
        'question': questionController.text.trim(),
        'optionA': optionAController.text.trim(),
        'optionB': optionBController.text.trim(),
        'optionC': optionCController.text.trim(),
        'answer': answerController.text.trim(),
      },
      where: 'id = ?',
      whereArgs: [widget.questionData['id']],
    );

    widget.onUpdate();
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Soal berhasil diupdate')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Soal', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildTextField('Soal', questionController),
                      SizedBox(height: 16),
                      _buildTextField('Pilihan A', optionAController),
                      SizedBox(height: 16),
                      _buildTextField('Pilihan B', optionBController),
                      SizedBox(height: 16),
                      _buildTextField('Pilihan C', optionCController),
                      SizedBox(height: 16),
                      _buildTextField('Jawaban Benar', answerController),
                      SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _updateQuestion,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            padding: EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(
                            'Update Soal',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontWeight: FontWeight.w600),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );
  }
}
