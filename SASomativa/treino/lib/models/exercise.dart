// lib/models/exercise.dart

/// Modelo que representa um exercício de treino.
class Exercise {
  int? id; // ID único do exercício (pode ser nulo ao criar um novo)
  int routineId; // Chave estrangeira que vincula o exercício a uma rotina
  String name; // Nome do exercício
  int series; // Número de séries
  String repetitions; // Número de repetições (como "10", "até a falha", etc.)
  String load; // Carga utilizada (ex: "10kg", "corpo livre")
  String type; // Tipo do exercício (ex: "cardio", "musculação")

  /// Construtor da classe Exercise
  Exercise({
    this.id, // O ID pode ser omitido ao criar um novo exercício
    required this.routineId, // ID da rotina à qual o exercício pertence
    required this.name,
    required this.series,
    required this.repetitions,
    required this.load,
    required this.type,
  });

  /// Converte a instância em um Map, usado para salvar no banco de dados
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'routineId': routineId,
      'name': name,
      'series': series,
      'repetitions': repetitions,
      'load': load,
      'type': type,
    };
  }

  /// Cria uma instância de Exercise a partir de um Map (usado ao recuperar do banco de dados)
  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'],
      routineId: map['routineId'],
      name: map['name'],
      series: map['series'],
      repetitions: map['repetitions'],
      load: map['load'],
      type: map['type'],
    );
  }

  /// Representação textual do objeto (útil para debug e logs)
  @override
  String toString() {
    return 'Exercise{id: $id, routineId: $routineId, name: $name, series: $series, repetitions: $repetitions, load: $load, type: $type}';
  }
}
