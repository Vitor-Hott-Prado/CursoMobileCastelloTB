import 'package:biblioteca_app/models/usuario_model.dart';
import 'package:biblioteca_app/services/api_service.dart';

class UsuarioContoller{
  //métod

  //GET -All
  Future<List<UsuarioModel>> fetchALL() async{
    final list = await ApiService.getList("usuarios?_sort =nome"); // ordenado pelo nome de A-> Z 
    //retorna a Lista de Usurio Convertida para Modelo para Usuario Model(DART)
    return list.map<UsuarioModel>((item)=>UsuarioModel.fromJson(item)).toList();


  }

  //GET -One

  Future<UsuarioModel> fetchOne(String id) async{
    final usuario = await ApiService.getOne("usuarios", id);
    return UsuarioModel.fromJson(usuario);
  }

 //POST 
 Future<UsuarioModel> creat(UsuarioModel u) async{
  final creatd = await ApiService.post("usuarios", u.toJson());
  //adicionar o Usuario e retorna o usuario adiconado
  return UsuarioModel.fromJson(creatd);
 }

//PUT
 Future<UsuarioModel> update(UsuarioModel u) async{
  final updated = await ApiService.put("usuario", u.toJson());
  // retorna  usúario atualizado
  return UsuarioModel.fromJson(updated);
  
 }

 // Delete
  Future<void> delete(String id) async{
    await ApiService.delete("usuario", id);
    //não tm retorno
    
  }


}