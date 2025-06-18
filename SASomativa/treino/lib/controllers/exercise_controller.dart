import 'package:flutter/material.dart';
import 'package:treino/services/exercise_service.dart';
import '../models/training_rotine.dart';
import '../models/exercise.dart';
// certifique-se do caminho correto

class ExerciseController with ChangeNotifier {
  final ExerciseService _exerciseService = ExerciseService();

  List<Exercise> _exercises = [];
  List<Exercise> get exercises => _exercises;

  TrainingRoutine? _currentRoutine;

  void setCurrentRoutine(TrainingRoutine routine) {
    _currentRoutine = routine;
    loadExercises();
  }

  Future<void> loadExercises() async {
    if (_currentRoutine == null) return;

    _exercises = await _exerciseService.getExercisesByRoutineId(_currentRoutine!.id!);
    notifyListeners();
  }

  Future<void> addExercise(Exercise exercise) async {
    if (_currentRoutine == null) return;

    exercise.routineId = _currentRoutine!.id!;
    await _exerciseService.insertExercise(exercise);
    await loadExercises();
  }

  Future<void> updateExercise(Exercise exercise) async {
    await _exerciseService.updateExercise(exercise);
    await loadExercises();
  }

  Future<void> deleteExercise(int id) async {
    await _exerciseService.deleteExercise(id);
    await loadExercises();
  }

  void clear() {
    _currentRoutine = null;
    _exercises = [];
    notifyListeners();
  }
}
