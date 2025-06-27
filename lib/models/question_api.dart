/// Model data untuk soal kuis dari API, berisi pertanyaan, pilihan jawaban, dan jawaban benar.
class QuestionAPI {
  final String question;
  final List<String> options;
  final String correctAnswer;

  QuestionAPI({required this.question, required this.options, required this.correctAnswer});
}
