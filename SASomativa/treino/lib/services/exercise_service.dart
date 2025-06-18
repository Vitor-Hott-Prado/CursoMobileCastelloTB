// lib/services/exercise_service.dart
import 'package:sqflite/sqflite.dart';
import 'package:treino/models/exercise.dart';
import 'package:treino/services/database_helepr.dart';
 // Seu helper de DB

class ExerciseService { // Renomeado de ExerciseDbHelper para ExerciseService para consistência
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> insertExercise(Exercise exercise) async {
    final db = await _dbHelper.database;
    return await db.insert(
      DatabaseHelper.TABLE_EXERCISES,
      exercise.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Exercise>> getExercisesByRoutineId(int routineId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseHelper.TABLE_EXERCISES,
      where: '${DatabaseHelper.COLUMN_EXERCISE_ROUTINE_ID} = ?',
      whereArgs: [routineId],
      orderBy: DatabaseHelper.COLUMN_EXERCISE_ID,
    );
    return List.generate(maps.length, (i) {
      return Exercise.fromMap(maps[i]);
    });
  }

  Future<int> updateExercise(Exercise exercise) async {
    final db = await _dbHelper.database;
    return await db.update(
      DatabaseHelper.TABLE_EXERCISES,
      exercise.toMap(),
      where: '${DatabaseHelper.COLUMN_EXERCISE_ID} = ?',
      whereArgs: [exercise.id],
    );
  }

  Future<int> deleteExercise(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      DatabaseHelper.TABLE_EXERCISES,
      where: '${DatabaseHelper.COLUMN_EXERCISE_ID} = ?',
      whereArgs: [id],
    );
  }

  // Novo método crucial para deletar exercícios de uma rotina específica
  Future<int> deleteExercisesByRoutineId(int routineId) async {
    final db = await _dbHelper.database;
    return await db.delete(
      DatabaseHelper.TABLE_EXERCISES,
      where: '${DatabaseHelper.COLUMN_EXERCISE_ROUTINE_ID} = ?',
      whereArgs: [routineId],
    );
  }
}