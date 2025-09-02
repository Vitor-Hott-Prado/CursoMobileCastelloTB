

import 'package:biblioteca_app/models/livro_model.dart';
import 'package:biblioteca_app/services/api_service.dart';

class LivroController {
  //métod

  //GET -All
  Future<List<LivroModel>> fetchALL() async{
    final list = await ApiService.getList("livor?_sort=nome");
    return list.map<LivroModel>((item)=>LivroModel.fromJson(item)).toList();

  }

// GET One
 Future<LivroModel> fetchOne(String id) async{
  final livro = await ApiService.getOne("livros", id);
  return LivroModel.fromJson(livro);
 }
 
  //POST
  Future<LivroModel> creat(LivroModel l) async{
    final creatd = await ApiService.post("livros", l.toJson());
    return LivroModel.fromJson(creatd);
}

//PUT
 Future<LivroModel> update(LivroModel l) async{
  final updated = await ApiService.put("livros", l.id.toString(), l.toJson());
  return LivroModel.fromJson(updated);
 }
 
 //Delete
 Future<void> delete(String id) async{
  await ApiService.delete("livros", id);
 }


}