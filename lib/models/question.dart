/// Model data untuk soal kuis dari API, berisi pertanyaan, pilihan jawaban, dan jawaban benar.
class Question {
  int? id;
  String question;
  String optionA;
  String optionB;
  String optionC;
  String answer;

  Question({this.id, required this.question, required this.optionA, required this.optionB, required this.optionC, required this.answer});

  /// Mengonversi objek Question ke dalam bentuk Map untuk penyimpanan ke database SQLite.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'optionA': optionA,
      'optionB': optionB,
      'optionC': optionC,
      'answer': answer,
    };
  }
}
