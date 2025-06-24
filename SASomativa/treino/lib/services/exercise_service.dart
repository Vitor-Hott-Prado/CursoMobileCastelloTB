import 'package:sqflite/sqflite.dart';
import 'package:treino/models/exercise.dart';
import 'package:treino/services/database_helepr.dart'; // Certifique-se de que o nome do arquivo está correto (possível erro de digitação: "helepr" deveria ser "helper")

/// Serviço responsável por realizar operações CRUD com exercícios no banco de dados SQLite.
class ExerciseService {
  // Instância do DatabaseHelper para acessar o banco de dados
  final DatabaseHelper _dbHelper = DatabaseHelper();

  /// Insere um novo exercício no banco de dados.
  /// Se já existir um exercício com o mesmo ID, ele será substituído (ConflictAlgorithm.replace).
  Future<int> insertExercise(Exercise exercise) async {
    final db = await _dbHelper.database;
    return await db.insert(
      DatabaseHelper.TABLE_EXERCISES,
      exercise.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Retorna uma lista de exercícios vinculados a uma rotina específica, com base no ID da rotina.
  Future<List<Exercise>> getExercisesByRoutineId(int routineId) async {
    final db = await _dbHelper.database;

    // Consulta todos os exercícios que pertencem à rotina especificada
    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseHelper.TABLE_EXERCISES,
      where: '${DatabaseHelper.COLUMN_EXERCISE_ROUTINE_ID} = ?',
      whereArgs: [routineId],
      orderBy: DatabaseHelper.COLUMN_EXERCISE_ID, // Ordena por ID
    );

    // Converte os dados do banco para uma lista de objetos Exercise
    return List.generate(maps.length, (i) {
      return Exercise.fromMap(maps[i]);
    });
  }

  /// Atualiza um exercício existente no banco de dados com base no seu ID.
  Future<int> updateExercise(Exercise exercise) async {
    final db = await _dbHelper.database;
    return await db.update(
      DatabaseHelper.TABLE_EXERCISES,
      exercise.toMap(),
      where: '${DatabaseHelper.COLUMN_EXERCISE_ID} = ?',
      whereArgs: [exercise.id],
    );
  }

  /// Deleta um exercício específico com base no seu ID.
  Future<int> deleteExercise(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      DatabaseHelper.TABLE_EXERCISES,
      where: '${DatabaseHelper.COLUMN_EXERCISE_ID} = ?',
      whereArgs: [id],
    );
  }

  /// Deleta todos os exercícios associados a uma rotina específica.
  /// Útil quando uma rotina é removida ou precisa ser reiniciada.
  Future<int> deleteExercisesByRoutineId(int routineId) async {
    final db = await _dbHelper.database;
    return await db.delete(
      DatabaseHelper.TABLE_EXERCISES,
      where: '${DatabaseHelper.COLUMN_EXERCISE_ROUTINE_ID} = ?',
      whereArgs: [routineId],
    );
  }
}
