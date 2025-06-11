class Exercise {
  // O 'id' será gerado automaticamente pelo banco de dados.
  int? id;
  // O 'routineId' é uma chave estrangeira que vincula este exercício a uma RotinaDeTreino específica.
  // Será o ID da rotina à qual este exercício pertence.
  int routineId;
  // Nome do exercício (ex: "Supino Reto", "Agachamento").
  String name;
  // Número de séries (ex: 3, 4).
  int series;
  // Número de repetições (ex: 8-12, 15).
  String repetitions; // Usamos String para permitir "8-12" ou "30s"
  // Carga utilizada (ex: "10kg", "Carga Corporal").
  String load;
  // Tipo de exercício (ex: "Força", "Cardio", "Alongamento").
  String type;

  // Construtor para criar uma nova instância de Exercise.
  // O 'id' é opcional.
  Exercise({
    this.id,
    required this.routineId,
    required this.name,
    required this.series,
    required this.repetitions,
    required this.load,
    required this.type,
  });

  // Método para converter um objeto Exercise em um Map.
  // Usado para salvar os dados no banco de dados SQLite.
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

  // Método estático (factory constructor) para criar um objeto Exercise a partir de um Map.
  // Usado quando você lê dados do banco de dados SQLite.
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

  // Sobrescreve o método toString para facilitar a depuração.
  @override
  String toString() {
    return 'Exercise(id: $id, routineId: $routineId, name: $name, series: $series, repetitions: $repetitions, load: $load, type: $type)';
  }
}