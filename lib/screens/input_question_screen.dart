import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  File? _selectedImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

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
        'imagePath': _selectedImage?.path,
      });

      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Soal berhasil disimpan')),
      );

      Navigator.pop(context);
    } catch (e) {
      setState(() => _isLoading = false);
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
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Color(0xFF6A11CB);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 48, left: 16, right: 16, bottom: 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6A11CB), Color(0xFF8E2DE2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Input Soal',
                      style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Text('Tambahkan pertanyaan ke kuis', style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        buildTextField('Soal', questionController),
                        buildTextField('Pilihan A', optionAController),
                        buildTextField('Pilihan B', optionBController),
                        buildTextField('Pilihan C', optionCController),
                        buildTextField('Jawaban Benar', answerController),
                        SizedBox(height: 12),
                        ElevatedButton.icon(
                          icon: Icon(Icons.image),
                          label: Text("Pilih Gambar"),
                          onPressed: _pickImage,
                        ),
                        if (_selectedImage != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Image.file(_selectedImage!, height: 150),
                          ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _saveQuestion,
                          child: Text("Simpan Soal"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: themeColor,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                          ),
                        )
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
