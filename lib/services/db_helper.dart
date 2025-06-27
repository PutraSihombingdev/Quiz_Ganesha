import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


/// DBHelpe class utilitas untuk mengelola koneksi dan inisialisasi database SQLite.
class DBHelper {
  static Database? _db;

  /// Getter untuk mendapatkan instance database.
  /// Akan menginisialisasi database jika belum ada.
  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  /// Inisialisasi database dan return objek `Database`.
  /// Database dibuat di path default perangkat dengan nama 'quiz_pintar.db'.
  initDb() async {
    String path = join(await getDatabasesPath(), 'quiz_pintar.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
    );
  }
  /// Fungsi yang menyimpan tabel pengguna dan pertanyaan
  _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT,
        password TEXT,
        score INTEGER,
        timestamp TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE questions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        question TEXT,
        optionA TEXT,
        optionB TEXT,
        optionC TEXT,
        answer TEXT
      )
    ''');
  }
  /// Fungsi untuk menangani migrasi database jika terjadi perubahan versi.
  _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE users ADD COLUMN timestamp TEXT');
    }
  }
}
