import 'package:flutter/material.dart';
import 'package:treino/models/training_rotine.dart';
import 'package:treino/services/training_routine_servece.dart';


class TrainingRoutineController with ChangeNotifier {
  // Serviço responsável pela comunicação com o banco de dados
  final TrainingRoutineService _routineService = TrainingRoutineService();

  // Lista de rotinas disponíveis
  List<TrainingRoutine> _routines = [];
  List<TrainingRoutine> get routines => _routines;

  // Rotina atualmente selecionada
  TrainingRoutine? _selectedRoutine;
  TrainingRoutine? get selectedRoutine => _selectedRoutine;

  // Construtor: carrega as rotinas ao iniciar
  TrainingRoutineController() {
    loadRoutines();
  }

  // =============================
  // Métodos de controle de estado
  // =============================

  /// Carrega todas as rotinas do banco de dados
  Future<void> loadRoutines() async {
    _routines = await _routineService.getRoutines();
    notifyListeners(); // Notifica a UI
  }

  /// Define uma rotina como selecionada
  void selectRoutine(TrainingRoutine routine) {
    _selectedRoutine = routine;
    notifyListeners();
  }

  /// Limpa a rotina selecionada
  void clearSelectedRoutine() {
    _selectedRoutine = null;
    notifyListeners();
  }

  /// Adiciona uma nova rotina e recarrega a lista
  Future<void> addRoutine(TrainingRoutine routine) async {
    await _routineService.insertRoutine(routine);
    await loadRoutines();
  }

  /// Atualiza uma rotina existente e recarrega a lista
  Future<void> updateRoutine(TrainingRoutine routine) async {
    await _routineService.updateRoutine(routine);
    await loadRoutines();
  }

  /// Exclui uma rotina e recarrega a lista
  Future<void> deleteRoutine(int id) async {
    await _routineService.deleteRoutine(id);

    // Limpa a seleção se a rotina excluída for a selecionada
    if (_selectedRoutine?.id == id) {
      _selectedRoutine = null;
    }

    await loadRoutines();
  }
}
