import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  File? _selectedImage;
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    questionController = TextEditingController(text: widget.questionData['question']);
    optionAController = TextEditingController(text: widget.questionData['optionA']);
    optionBController = TextEditingController(text: widget.questionData['optionB']);
    optionCController = TextEditingController(text: widget.questionData['optionC']);
    answerController = TextEditingController(text: widget.questionData['answer']);
    _imagePath = widget.questionData['imagePath'];
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
        _imagePath = picked.path;
      });
    }
  }

  void _updateQuestion() async {
    if (questionController.text.trim().isEmpty ||
        optionAController.text.trim().isEmpty ||
        optionBController.text.trim().isEmpty ||
        optionCController.text.trim().isEmpty ||
        answerController.text.trim().isEmpty) {
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
        'imagePath': _imagePath, // Simpan path baru
      },
      where: 'id = ?',
      whereArgs: [widget.questionData['id']],
    );

    widget.onUpdate();
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Soal berhasil diperbarui')),
    );

    Navigator.pop(context);
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.deepPurple),
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.deepPurple, width: 2),
            borderRadius: BorderRadius.circular(14),
          ),
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
                      'Edit Soal',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Perbarui pertanyaan yang sudah ada',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Form
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator(color: themeColor))
                : SingleChildScrollView(
                    padding: EdgeInsets.all(20),
                    child: Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Edit Data Soal:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: themeColor,
                              ),
                            ),
                            SizedBox(height: 20),
                            TextField(
                              controller: questionController,
                              maxLines: 5,
                              decoration: InputDecoration(
                                labelText: 'Isi Soal',
                                alignLabelWithHint: true,
                                filled: true,
                                fillColor: Colors.grey[100],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: themeColor, width: 2),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            buildTextField('Pilihan A', optionAController),
                            buildTextField('Pilihan B', optionBController),
                            buildTextField('Pilihan C', optionCController),
                            buildTextField('Jawaban Benar', answerController),

                            SizedBox(height: 20),
                            ElevatedButton.icon(
                              label: Text(
                                  "Ganti Gambar",
                                  style: TextStyle(color: Colors.white),
                                ),
                              onPressed: _pickImage,
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                            ),
                            if (_imagePath != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: Image.file(File(_imagePath!), height: 150),
                              ),
                            SizedBox(height: 28),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                icon: Icon(Icons.save),
                                label: Text(
                                  'Simpan Perubahan',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: themeColor,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                onPressed: _updateQuestion,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
