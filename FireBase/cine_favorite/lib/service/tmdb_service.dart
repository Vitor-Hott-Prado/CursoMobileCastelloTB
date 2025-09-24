// meu serviço e conexõ com API TMDN 

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http show get;

class TmdService {
  //colocar os dados da API 
  static const String _apiKey = "AIzaSyAhsZJ9Zix8B4Kh-aPjoXYNiNFUFyrJ4qY";
  static const String _baseUrl = "https://api.themoviedb.org/3";
  static const String _idioma = "pt-BR";
  //static -> atributo é da classe e não do OBJ 

   // métodos Static => métoods da Classe -> não precisa  instanciar OBJ
   // para acesa o método 

   //buscar filme na API pelo Termo 
   static Future<List<Map<String,dynamic>>> searchMovie(String termo ) async {
    //converter String em URl
    final apiURI = Uri.parse("$_baseUrl/search/movie?apik_key=$_apiKey&query=$termo&language=$_idioma");
   //HTTP REQUEST -> get
   final response = await http.get(apiURI);



    //verificar a resposta
    if(response.statusCode==200){
      //converter a resposta de json para dart
      final data = json.decode(response.body);
      //transformar data(string) em List<Map>
      return List<Map<String,dynamic>>.from(data["results"]);
    }else{//caso contrário statuscode != 200
      //criar uma exception
      throw Exception("Falha ao Carregar Filmes da API");
    }
  }
}
