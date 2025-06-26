class Question {
  int? id;
  String question;
  String optionA;
  String optionB;
  String optionC;
  String answer;

  Question({this.id, required this.question, required this.optionA, required this.optionB, required this.optionC, required this.answer});

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
