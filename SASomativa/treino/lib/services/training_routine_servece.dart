import 'package:sqflite/sqflite.dart';
import 'package:treino/models/training_rotine.dart'; // Modelo da rotina de treino
import 'package:treino/services/database_helepr.dart'; // <- Verifique se o nome está correto: "helepr" pode estar incorreto
import 'package:treino/services/exercise_service.dart'; // Serviço para lidar com exercícios relacionados à rotina

/// Serviço responsável por lidar com a persistência de rotinas de treino no banco de dados.
class TrainingRoutineService {
  // Instância do helper do banco de dados
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Serviço para manipular os exercícios relacionados a uma rotina
  final ExerciseService _exerciseService = ExerciseService();

  /// Insere uma nova rotina no banco de dados.
  Future<int> insertRoutine(TrainingRoutine routine) async {
    final db = await _dbHelper.database;

    return await db.insert(
      DatabaseHelper.TABLE_ROUTINES,
      routine.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace, // Substitui caso já exista com o mesmo ID
    );
  }

  /// Recupera todas as rotinas de treino do banco.
  /// Também pode opcionalmente carregar os exercícios associados a cada rotina.
  Future<List<TrainingRoutine>> getRoutines() async {
    final db = await _dbHelper.database;

    // Consulta todas as rotinas da tabela
    final List<Map<String, dynamic>> maps = await db.query(DatabaseHelper.TABLE_ROUTINES);

    // Converte os dados em objetos TrainingRoutine
    List<TrainingRoutine> routines = List.generate(maps.length, (i) {
      return TrainingRoutine.fromMap(maps[i]);
    });

    // Carrega os exercícios para cada rotina (útil se for usar ExpansionTile ou exibição completa)
    for (var routine in routines) {
      if (routine.id != null) {
        routine.exercises = await _exerciseService.getExercisesByRoutineId(routine.id!);
      }
    }

    return routines;
  }

  /// Atualiza uma rotina existente no banco de dados.
  Future<int> updateRoutine(TrainingRoutine routine) async {
    final db = await _dbHelper.database;

    return await db.update(
      DatabaseHelper.TABLE_ROUTINES,
      routine.toMap(),
      where: '${DatabaseHelper.COLUMN_ROUTINE_ID} = ?', // Atualiza com base no ID
      whereArgs: [routine.id],
    );
  }

  /// Deleta uma rotina com base no ID.
  /// A deleção em cascata já garante que os exercícios relacionados também serão excluídos automaticamente.
  Future<int> deleteRoutine(int id) async {
    final db = await _dbHelper.database;

    return await db.delete(
      DatabaseHelper.TABLE_ROUTINES,
      where: '${DatabaseHelper.COLUMN_ROUTINE_ID} = ?',
      whereArgs: [id],
    );
  }
}
