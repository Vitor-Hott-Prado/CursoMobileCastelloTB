class TrainingRoutine {
  // O 'id' será gerado automaticamente pelo banco de dados.
  // Será útil para identificar e manipular rotinas específicas (atualizar, deletar).
  int? id;
  // Nome da rotina (ex: "Treino de Força A", "Cardio Matinal").
  String name;
  // Objetivo da rotina (ex: "Ganho de Massa", "Perda de Peso").
  String objective;

  // Construtor para criar uma nova instância de TrainingRoutine.
  // O 'id' é opcional pois ele só existirá após a rotina ser salva no banco.
  TrainingRoutine({
    this.id,
    required this.name,
    required this.objective,
  });

  // Método para converter um objeto TrainingRoutine em um Map.
  // Isso é necessário para salvar os dados no banco de dados SQLite.

  Map<String, dynamic> toMap() {
    return {
      'id': id, // O id pode ser nulo ao inserir, o banco cuida disso.
      'name': name,
      'objective': objective,
    };
  }

  // Método estático (factory constructor) para criar um objeto TrainingRoutine a partir de um Map.
  // Isso é usado quando você lê dados do banco de dados SQLite.
  factory TrainingRoutine.fromMap(Map<String, dynamic> map) {
    return TrainingRoutine(
      id: map['id'],
      name: map['name'],
      objective: map['objective'],
    );
  }

  // Sobrescreve o método toString para facilitar a depuração.
  @override
  String toString() {
    return 'TrainingRoutine(id: $id, name: $name, objective: $objective)';
  }
}