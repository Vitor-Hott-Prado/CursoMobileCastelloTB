import 'package:sqflite/sqflite.dart';
import 'package:treino/models/training_rotine.dart';
import 'package:treino/services/database_helepr.dart';

 // sua classe de acesso ao DB

class TrainingRoutineService {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;  // aqui o nome correto da classe
  final String _tableName = 'training_routines';

  Future<int> insertRoutine(TrainingRoutine routine) async {
    final db = await _dbHelper.database;
    return await db.insert(
      _tableName,
      routine.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<TrainingRoutine>> getRoutines() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(_tableName);
    return maps.map((map) => TrainingRoutine.fromMap(map)).toList();
  }

  Future<TrainingRoutine?> getRoutineById(int id) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return TrainingRoutine.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateRoutine(TrainingRoutine routine) async {
    final db = await _dbHelper.database;
    return await db.update(
      _tableName,
      routine.toMap(),
      where: 'id = ?',
      whereArgs: [routine.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> deleteRoutine(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
