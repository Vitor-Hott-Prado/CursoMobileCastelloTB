import 'package:flutter/material.dart';
import 'package:sa03_navegacao/view/tela_cadastro.dart';
import 'package:sa03_navegacao/view/tela_confirmacao.dart';
import 'package:sa03_navegacao/view/telas_boasvindas.dart';

void main(){
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: "/",
    routes: {
      // nome_da_rota => Tela()
      "/": (context) => TelaBoasvindas(),
      "/cadastro": (context) => TelaCadastro(),
      "/confirmacao": (context) => TelaConfirmacao()
    },
  ));
}

