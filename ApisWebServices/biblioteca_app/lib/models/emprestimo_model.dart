
class EmprestimoModel {
  final String? id;
  final String idUsuarioId;
  final String livroId;
  final String dataEmprestimo;
  final String dataDevolucao;
  final String devolvido;


  //construtor
  
  EmprestimoModel({
    this.id,
    required this.idUsuarioId,
    required this.livroId,
    required this.dataEmprestimo,
    required this.dataDevolucao,
    required this.devolvido,
  });
  //método
  //toJson
  Map<String,dynamic> toJson() => {
    "id": id,
    "idUsuarioId": idUsuarioId,
    "livroId": livroId,
    "dataEmprestimo": dataEmprestimo,
    "dataDevolucao": dataDevolucao,
    "devolvido": devolvido,
  };
  //fromJson
  factory EmprestimoModel.fromJson(Map<String,dynamic> json) => EmprestimoModel(
    id: json["id"].toString(),
    idUsuarioId: json["idUsuarioId"].toString(),
    livroId: json["livroId"].toString(),
    dataEmprestimo: json["dataEmprestimo"].toString(),
    dataDevolucao: json["dataDevolucao"].toString(), devolvido: '',
  );
}