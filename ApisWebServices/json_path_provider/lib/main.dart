import 'dart:convert';
import 'dart:io'; // biblioteca para acesar os caminhos do dispositivo movel

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MaterialApp(home:ProdutoPage()));
}

class ProdutoPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _ProdutoPageSate();
  }
}

class _ProdutoPageSate extends State<ProdutoPage>{
  List<Map<String,dynamic>> produtos = []; //Lista para armazenar os produtos
  final TextEditingController _nomeController = TextEditingController(); //fprmulario para o nome d produto
  final TextEditingController _valorController = TextEditingController(); //formular para valor do produto

 //carregar as informçoes no inico do carrregamento do aplicativo
 @override
  void initState() {
    super.initState();
    _carregarProdutos();
  }

//mpetodos para conexão com  a base de dados

Future<File> _getArquivo() async{
  final dir = await getApplicationCacheDirectory();
  return File("${dir.path}/produtos.json");

}

  _salvarProduto() async{
    final file = await _getArquivo();
    String jsonProdutos = json.encode(produtos);
    await file.writeAsString((jsonProdutos));
  }
 

  void _carregarProdutos() async{
    try {
      final file = await _getArquivo();
      String conteudo = await file.readAsString();
      List<dynamic> dados = json.decode(conteudo);
      setState(() {
        produtos = dados.cast<Map<String,dynamic>>();
      });
    } catch (e) {
      setState(() {
        produtos = [];
      });
      
    }
  }

  void _adicionarProduto(){
    String nome = _nomeController.text.trim();
    String valorStr = _valorController.text.trim();
    if(nome.isEmpty || valorStr.isEmpty) return;
    double? valor = double.tryParse(valorStr); // convertendo string em Numero
    final novoProduto = {"nome": nome, "valor": valor};
    setState(() {
      produtos.add(novoProduto);
    });
    _nomeController.clear();
    _valorController.clear();
    _salvarProduto();
  }
  void _removerProduto (int index){
    setState(() {
      produtos.removeAt(index);

    });
    _salvarProduto();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cadastro de Produtos"),),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(labelText: "Nome do Produto"),
            ),
            TextField(
              controller: _valorController,
              decoration: InputDecoration(labelText: "Valor (ex:15.53)"),
              keyboardType: TextInputType.numberWithOptions(decimal: true),

            ),
            SizedBox(height: 15,),
            ElevatedButton(
              onPressed: _adicionarProduto, 
              child: Text("Adionar Produto")),
            SizedBox(height: 10,),
            Divider(),
            Expanded(
              //operador Ternario
              child: produtos.isEmpty ? Center(child: Text("Nenhum Produto Cadastrado"),):
              ListView.builder(
                itemCount: produtos.length,
                itemBuilder: (context, index){
                  final produto = produtos[index];
                  return ListTile(
                    title: Text(produto["nome"]),
                    subtitle: Text("R\$ ${produto["valor"].toString()}"),
                       trailing: IconButton(
                      onPressed: () => _removerProduto(index), 
                      icon: Icon(Icons.delete)),
                  );
                })
              )
          ],
        ),
      ),
    );
  }
  
}