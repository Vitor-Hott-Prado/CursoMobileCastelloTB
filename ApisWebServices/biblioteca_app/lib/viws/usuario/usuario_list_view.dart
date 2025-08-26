import 'package:biblioteca_app/controllers/usuario_cntroller.dart';
import 'package:biblioteca_app/models/usuario_model.dart';
import 'package:flutter/material.dart';

class UsuarioListView extends StatefulWidget {
  const UsuarioListView({super.key});

  @override
  State<UsuarioListView> createState() => _UsuarioListViewState();
}

class _UsuarioListViewState extends State<UsuarioListView> {
  //atrbitos

  final _controller = UsuarioContoller();
  List<UsuarioModel> _usuario = [];
  bool _carrgando = true;

  @override
  void initState() {
    super.initState();
    _load();
}


 _load() async {
  setState(() {
    _carrgando = true;
  });
   try {
     _usuario = await _controller.fetchALL();

   } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()))
        );     
   }
   setState(() {
    _carrgando = false;
   });
 }
  
  
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _carrgando 
      ? Center(child: CircularProgressIndicator(),)
      : ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: _usuario.length,
        itemBuilder: (context, index){
          final usuario = _usuario[index];
          return Card(
            child:  ListTile(
              title: Text(usuario.nome),
              subtitle: Text(usuario.email),
              //trailing para deletar usuario
            ),
          );        
          })
    );
  }
}