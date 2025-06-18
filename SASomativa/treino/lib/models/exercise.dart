// lib/models/exercise.dart
class Exercise {
  int? id;
  int routineId; // Chave estrangeira
  String name;
  int series;
  String repetitions;
  String load;
  String type;

  Exercise({
    this.id,
    required this.routineId, // Precisa ser passado
    required this.name,
    required this.series,
    required this.repetitions,
    required this.load,
    required this.type,
  });

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

  @override
  String toString() {
    return 'Exercise{id: $id, routineId: $routineId, name: $name, series: $series, repetitions: $repetitions, load: $load, type: $type}';
  }
}