class LivroModel {
  // atributos
  final String? id; // pode ser nulo inicialmente pq o banco gera
  final String titulo;
  final String autor;
  final bool disponivl;

  //construtor
  LivroModel({
    this.id,
    required this.titulo,
    required this.autor,
    required this.disponivl,
  });
  //método
  //toJson
  Map<String, dynamic> toJson() => {
    "id": id,
    "titulo": titulo,
    "autor": autor,
    "disponivl": disponivl,
  };
  //fromJson
  factory LivroModel.fromJson(Map<String,dynamic>json)=> LivroModel(
    id:json ["id"].toString(), 
    titulo: json ["titulo"].toString(), 
    autor: json ["autor"].toString(),
    disponivl:json["disponivl"] == true ? true : false); //operador ternario corrigir a booleana

}