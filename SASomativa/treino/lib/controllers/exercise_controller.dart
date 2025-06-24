import 'package:flutter/material.dart';
import 'package:treino/services/exercise_service.dart';
import '../models/training_rotine.dart';
import '../models/exercise.dart';
// Certifique-se de que os caminhos dos imports estão corretos

/// Controlador responsável por gerenciar os exercícios relacionados a uma rotina de treino.
class ExerciseController with ChangeNotifier {
  // Instância do serviço que lida com a lógica de banco de dados ou API para exercícios.
  final ExerciseService _exerciseService = ExerciseService();

  // Lista privada de exercícios.
  List<Exercise> _exercises = [];

  // Getter público para acessar a lista de exercícios.
  List<Exercise> get exercises => _exercises;

  // Armazena a rotina de treino atualmente selecionada.
  TrainingRoutine? _currentRoutine;

  /// Define a rotina atual e carrega os exercícios associados a ela.
  void setCurrentRoutine(TrainingRoutine routine) {
    _currentRoutine = routine;
    loadExercises(); // Carrega os exercícios dessa rotina
  }

  /// Carrega os exercícios da rotina atual a partir do serviço.
  Future<void> loadExercises() async {
    if (_currentRoutine == null) return;

    // Busca os exercícios da rotina atual pelo ID
    _exercises = await _exerciseService.getExercisesByRoutineId(_currentRoutine!.id!);
    notifyListeners(); // Notifica os ouvintes que os dados foram atualizados
  }

  /// Adiciona um novo exercício à rotina atual.
  Future<void> addExercise(Exercise exercise) async {
    if (_currentRoutine == null) return;

    // Associa o exercício à rotina atual
    exercise.routineId = _currentRoutine!.id!;
    await _exerciseService.insertExercise(exercise);
    await loadExercises(); // Recarrega a lista após adicionar
  }

  /// Atualiza um exercício existente.
  Future<void> updateExercise(Exercise exercise) async {
    await _exerciseService.updateExercise(exercise);
    await loadExercises(); // Recarrega a lista após atualizar
  }

  /// Remove um exercício com base no ID.
  Future<void> deleteExercise(int id) async {
    await _exerciseService.deleteExercise(id);
    await loadExercises(); // Recarrega a lista após excluir
  }

  /// Limpa os dados internos, como a rotina atual e a lista de exercícios.
  void clear() {
    _currentRoutine = null;
    _exercises = [];
    notifyListeners(); // Notifica os ouvintes para atualizar a UI
  }
}
