// lib/models/training_rotine.dart
import 'package:treino/models/exercise.dart';

class TrainingRoutine {
  int? id;
  String name;
  String objective;
  // Mude de List<Exercise>? para List<Exercise> e inicialize com []
  List<Exercise> exercises; // <--- CORRIGIDO AQUI: Não mais anulável, inicializado no construtor

  TrainingRoutine({
    this.id,
    required this.name,
    required this.objective,
    this.exercises = const [], // <--- CORRIGIDO AQUI: Valor padrão para lista vazia
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'objective': objective,
    };
  }

  factory TrainingRoutine.fromMap(Map<String, dynamic> map) {
    return TrainingRoutine(
      id: map['id'],
      name: map['name'],
      objective: map['objective'],
      // Ao carregar do mapa, a lista de exercícios será preenchida
      // pelo serviço se houver, caso contrário, será a lista padrão vazia.
      exercises: [], // <--- CORRIGIDO AQUI: Inicializa como lista vazia ao criar do mapa
    );
  }

  @override
  String toString() {
    return 'TrainingRoutine{id: $id, name: $name, objective: $objective, exercises: $exercises}';
  }
}