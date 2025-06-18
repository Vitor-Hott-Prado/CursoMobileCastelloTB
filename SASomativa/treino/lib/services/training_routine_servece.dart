// lib/services/training_routine_servece.dart
import 'package:sqflite/sqflite.dart';
import 'package:treino/models/training_rotine.dart';
import 'package:treino/services/database_helepr.dart';
 // <--- CORRIGIDO AQUI
// Seu helper de DB
import 'package:treino/services/exercise_service.dart'; // Para carregar exercícios

class TrainingRoutineService {
  final DatabaseHelper _dbHelper = DatabaseHelper(); // Usar seu DatabaseHelper
  final ExerciseService _exerciseService = ExerciseService();

  Future<int> insertRoutine(TrainingRoutine routine) async {
    final db = await _dbHelper.database;
    return await db.insert(
      DatabaseHelper.TABLE_ROUTINES,
      routine.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<TrainingRoutine>> getRoutines() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(DatabaseHelper.TABLE_ROUTINES);

    // Você pode optar por carregar os exercícios aqui ou na tela de detalhes
    // Para a lista principal, talvez só o nome da rotina seja suficiente por enquanto.
    List<TrainingRoutine> routines = List.generate(maps.length, (i) {
      return TrainingRoutine.fromMap(maps[i]);
    });

    // Se você quiser carregar os exercícios na lista principal também (para ExpansionTile)
    for (var routine in routines) {
      if (routine.id != null) {
        routine.exercises = await _exerciseService.getExercisesByRoutineId(routine.id!);
      }
    }
    return routines;
  }

  Future<int> updateRoutine(TrainingRoutine routine) async {
    final db = await _dbHelper.database;
    return await db.update(
      DatabaseHelper.TABLE_ROUTINES,
      routine.toMap(),
      where: '${DatabaseHelper.COLUMN_ROUTINE_ID} = ?',
      whereArgs: [routine.id],
    );
  }

  Future<int> deleteRoutine(int id) async {
    final db = await _dbHelper.database;
    // A deleção em cascata (ON DELETE CASCADE) no DB deve cuidar dos exercícios
    return await db.delete(
      DatabaseHelper.TABLE_ROUTINES,
      where: '${DatabaseHelper.COLUMN_ROUTINE_ID} = ?',
      whereArgs: [id],
    );
  }
}