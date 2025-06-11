import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/exercise.dart';

class ExerciseDbHelper {
  static const String DB_NAME = "treino_app.db";
  static const String TABLE_NAME = "exercises";

  static const String CREATE_TABLE_SQL = '''
    CREATE TABLE IF NOT EXISTS $TABLE_NAME (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      routineId INTEGER NOT NULL,
      name TEXT NOT NULL,
      series INTEGER NOT NULL,
      repetitions TEXT NOT NULL,
      load TEXT NOT NULL,
      type TEXT NOT NULL
    )
  ''';

  Database? _database;

  // Retorna a instância ativa do banco de dados
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Inicializa o banco
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, DB_NAME);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(CREATE_TABLE_SQL);
        // Você pode criar a tabela de rotinas aqui também, se quiser manter tudo em um helper
      },
    );
  }

  // ===============================
  // CRUD para Exercícios
  // ===============================

  // CREATE
  Future<int> insertExercise(Exercise exercise) async {
    final db = await database;
    return await db.insert(TABLE_NAME, exercise.toMap());
  }

  // READ (listar todos os exercícios de uma rotina)
  Future<List<Exercise>> getExercisesByRoutineId(int routineId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      TABLE_NAME,
      where: "routineId = ?",
      whereArgs: [routineId],
    );

    return maps.map((e) => Exercise.fromMap(e)).toList();
  }

  // UPDATE
  Future<int> updateExercise(Exercise exercise) async {
    final db = await database;
    return await db.update(
      TABLE_NAME,
      exercise.toMap(),
      where: "id = ?",
      whereArgs: [exercise.id],
    );
  }

  // DELETE
  Future<int> deleteExercise(int id) async {
    final db = await database;
    return await db.delete(
      TABLE_NAME,
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
