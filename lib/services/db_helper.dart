import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// DBHelper adalah class utilitas untuk mengelola koneksi dan struktur database SQLite.
class DBHelper {
  static Database? _db;

  /// Getter untuk mendapatkan instance database. Inisialisasi jika belum ada.
  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  /// Inisialisasi database: membuat database baru atau membuka yang sudah ada.
  initDb() async {
    String path = join(await getDatabasesPath(), 'quiz_pintar.db');
    return await openDatabase(
      path,
      version: 3, // Versi dinaikkan untuk memastikan kolom baru terbuat
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// Membuat tabel saat database pertama kali dibuat.
  Future<void> _onCreate(Database db, int version) async {
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
        answer TEXT,
        imagePath TEXT
      )
    ''');
  }

  /// Menangani perubahan versi database dan menambahkan kolom baru jika dibutuhkan.
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE users ADD COLUMN timestamp TEXT');
    }
    if (oldVersion < 3) {
      await db.execute('ALTER TABLE questions ADD COLUMN imagePath TEXT');
    }
  }
}
