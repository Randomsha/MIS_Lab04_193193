import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'exam_schedule.db'),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE exams (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            location TEXT,
            date_time TEXT
          )
        ''');
      },
      version: 1,
    );
  }

  Future<void> insertExam(Map<String, dynamic> exam) async {
    final db = await database;
    await db.insert('exams', exam);
  }

  Future<List<Map<String, dynamic>>> getExams() async {
    final db = await database;
    return await db.query('exams');
  }

  // New method to get events for a specific day
  Future<List<Map<String, dynamic>>> getEventsForDay(String date) async {
    final db = await database;
    return await db.query(
      'exams',
      where: 'date_time LIKE ?',
      whereArgs: [
        '$date%'
      ], // This will match the date part (e.g., '2024-12-28')
    );
  }
}
