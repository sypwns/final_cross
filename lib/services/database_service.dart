import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/task_model.dart';
import '../models/note_model.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._internal();
  static Database? _database;
  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'smart_study_planner.db');
    return openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        deadline TEXT NOT NULL,
        priority TEXT NOT NULL,
        isCompleted INTEGER NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE notes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertTask(StudyTask task) async {
    final db = await database;
    return db.insert('tasks', task.toMap());
  }

  Future<List<StudyTask>> getTasks() async {
    final db = await database;
    final result = await db.query('tasks', orderBy: 'deadline ASC');
    return result.map(StudyTask.fromMap).toList();
  }

  Future<int> updateTask(StudyTask task) async {
    final db = await database;
    return db.update('tasks', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
  }

  Future<int> deleteTask(int id) async {
    final db = await database;
    return db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> insertNote(StudyNote note) async {
    final db = await database;
    return db.insert('notes', note.toMap());
  }

  Future<List<StudyNote>> getNotes() async {
    final db = await database;
    final result = await db.query('notes', orderBy: 'updatedAt DESC');
    return result.map(StudyNote.fromMap).toList();
  }

  Future<int> updateNote(StudyNote note) async {
    final db = await database;
    return db.update('notes', note.toMap(), where: 'id = ?', whereArgs: [note.id]);
  }

  Future<int> deleteNote(int id) async {
    final db = await database;
    return db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }
}
