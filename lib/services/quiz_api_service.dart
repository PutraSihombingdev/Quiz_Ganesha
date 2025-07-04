import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/question_api.dart';
/// QuizAPIService mengambil soal quiz dari Open Trivia DB API dan mengubahnya menjadi model QuestionAPI.
class QuizAPIService {
   /// Mengambil 10 soal pilihan ganda dari API, menyusun opsi secara acak, dan mengembalikannya sebagai list QuestionAPI.
  Future<List<QuestionAPI>> fetchQuestions() async {
    final response = await http.get(Uri.parse('https://opentdb.com/api.php?amount=10&type=multiple'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List results = data['results'];

      return results.map((q) {
        List<String> options = List<String>.from(q['incorrect_answers']);
        options.add(q['correct_answer']);
        options.shuffle();

        return QuestionAPI(
          question: q['question'],
          options: options,
          correctAnswer: q['correct_answer'],
        );
      }).toList();
    } else {
      throw Exception('Gagal memuat soal dari API');
    }
  }
}
