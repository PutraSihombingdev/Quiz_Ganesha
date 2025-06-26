class User {
  int? id;
  String username;
  String password;
  int score;

  User({this.id, required this.username, required this.password, this.score = 0});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'score': score,
    };
  }
}
