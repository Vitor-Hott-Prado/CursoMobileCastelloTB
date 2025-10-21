class LocationPoints {
  final double latitude;
  final double longitude;
  final String dataHora;
  final String? id; // opcional, para identificar o ponto no Firestore
  final String tipo; // "usuario", "empresa", "falso" etc.

  LocationPoints({
    required this.latitude,
    required this.longitude,
    required this.dataHora,
    this.id,
    this.tipo = 'usuario', // padrão é usuário
  });

  // Converter para Map (útil para salvar no Firestore)
  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'dataHora': dataHora,
      'tipo': tipo,
      'id': id,
    };
  }

  // Criar a partir de Map (Firestore)
  factory LocationPoints.fromMap(Map<String, dynamic> map, {String? id}) {
    return LocationPoints(
      latitude: map['latitude'],
      longitude: map['longitude'],
      dataHora: map['dataHora'],
      tipo: map['tipo'] ?? 'usuario',
      id: id,
    );
  }
}
