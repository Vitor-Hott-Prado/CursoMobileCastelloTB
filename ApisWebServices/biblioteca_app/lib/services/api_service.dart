import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  //atributos e métodos da classe e não do objeto
  // base URL para conexão API
  // static -> transforma o atributo em atributo da classe e não Obj
  static const String _baseUrl = "http://10.109.197.4:3005";

  // -------------------------------------------------------------------------------------------
  //métodos
  //GET (Listar todos os Recursos)
  static Future<List<dynamic>> getList(String path) async {
    final res = await http.get(Uri.parse("$_baseUrl/$path")); //uri -> converte string -> url
    if (res.statusCode == 200) return json.decode(res.body); // deu certo converte resposta de json -> List<dynamic> e final
    // se der errado vou criar um erro
    throw Exception('Falha ao Carregar Lista de $path');
  }

  // ------------------------------------------------------------------------------------------------------
  //GET (Listar um Único Recurso)
  static Future<Map<String, dynamic>> getOne(String path, String id) async {
    final res = await http.get(Uri.parse("$_baseUrl/$path/$id"));
    if (res.statusCode == 200) return json.decode(res.body);
    // se não deu certo -> Criar Erro
    throw Exception('Falha ao carregar Recurso $path/$id');
  }

  // ---------------------------------------------------------------------------------------------
  //POST (Criar novo Recurso)
  static Future<Map<String, dynamic>> post(
      String path, Map<String, dynamic> body) async {
    final res = await http.post(
      //endereço da API
      Uri.parse("$_baseUrl/$path"),
      //headers
      headers: {"Content-Type": "application/json"},
      body: json.encode(body),
    );
    if (res.statusCode == 201) return json.decode(res.body);
    //se não deu certo -> gerar erro
    throw Exception("Falha ao Criar Recurso em $path");
  }

  // -----------------------------------------------------------------------------------
  //PUT (Atualizar Recurso)
  static Future<Map<String, dynamic>> put(
      String path, String id, Map<String, dynamic> data) async {
    final res = await http.put(
      //endereço da API
      Uri.parse("$_baseUrl/$path/$id"),
      //headers
      headers: {"Content-Type": "application/json"},
      body: json.encode(data),
    );
    if (res.statusCode == 200) return json.decode(res.body);
    //se não deu certo
    throw Exception('Falha ao Alterar $path/$id');
  }

  // -----------------------------------------------------------------------------------
  //DELETE (Apagar Recurso)
  static Future<void> delete(String path, String id) async {
    final res = await http.delete(Uri.parse("$_baseUrl/$path/$id"));
    if (res.statusCode == 200) return;
    //se não deu certo
    throw Exception('Falha ao Apagar Recurso $path/$id');
  }
}
