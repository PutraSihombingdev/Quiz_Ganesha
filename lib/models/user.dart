/// Model data untuk pengguna aplikasi, mencakup ID, username, password, dan skor kuis.
class User {
  int? id;
  String username;
  String password;
  int score;

  User({this.id, required this.username, required this.password, this.score = 0});

  /// Mengonversi objek User ke dalam bentuk Map untuk penyimpanan ke database SQLite.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'score': score,
    };
  }
}
