import 'package:biblioteca_app/models/emprestimo_model.dart';
import 'package:biblioteca_app/services/api_service.dart';

class EmprestiomoCntroller {
  //método

  //GET -All
  Future<List<EmprestimoModel>> fetchALL() async {
    final list = await ApiService.getList("emprestimos?_sort=dataEmprestimo");
    return list
        .map<EmprestimoModel>((item) => EmprestimoModel.fromJson(item))
        .toList();
  }

  // GET One
  Future<EmprestimoModel> fetchOne(String id) async {
    final emprestimo = await ApiService.getOne("emprestimos", id);
    return EmprestimoModel.fromJson(emprestimo);
  }
  //POST
  Future<EmprestimoModel> creat(EmprestimoModel e) async {
    final creatd = await ApiService.post("emprestimos", e.toJson());
    return EmprestimoModel.fromJson(creatd);
  }
  //PUT
  Future<EmprestimoModel> update(EmprestimoModel e) async {
    final updated = await ApiService.put("emprestimos", e.toJson());
    return EmprestimoModel.fromJson(updated);
  }
  //Delete
  Future<void> delete(String id) async {
    await ApiService.delete("emprestimos", id);
  }
}