
import 'package:biblioteca_app/controllers/emprestiomo_cntroller.dart';
import 'package:biblioteca_app/models/emprestimo_model.dart';

import 'package:biblioteca_app/viws/empretimos/emprestimos_from_view.dart';
import 'package:flutter/material.dart';

class EmprestimoListView extends StatefulWidget {
  const EmprestimoListView({super.key});

  @override
  State<EmprestimoListView> createState() => _EmprestimoListViewState();
}

class _EmprestimoListViewState extends State<EmprestimoListView> {
  final _buscarField = TextEditingController();
  List<EmprestimoModel> _emprestimosFiltrados = [];
  final _controller = EmprestiomoCntroller();
  List<EmprestimoModel> _emprestimos = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  _load() async {
    setState(() {
      _carregando = true;
    });
    try {
      _emprestimos = await _controller.fetchALL();
      _emprestimosFiltrados = _emprestimos;
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Erro: $e")));
    }
    setState(() {
      _carregando = false;
    });
  }

  void _filtrar() {
    final busca = _buscarField.text.toLowerCase();
    setState(() {
      _emprestimosFiltrados = _emprestimos.where((emp) {
        // Aqui você pode adaptar os campos para filtrar, ex:
        // filtrar pelo nome do usuário ou título do livro
        final usuario = emp.usuarioNome.toLowerCase();
        final livro = emp.livroTitulo.toLowerCase();
        return usuario.contains(busca) || livro.contains(busca);
      }).toList();
    });
  }

  void _delete(EmprestimoModel emp) async {
    if (emp.id == null) return;
    final confirme = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirma Exclusão"),
        content: Text(
            "Deseja Realmente Excluir o Empréstimo de ${emp.livroId} para ${emp.idUsuarioId}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Cancelar"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("Ok"),
          ),
        ],
      ),
    );
    if (confirme == true) {
      try {
        await _controller.delete(emp.id!);
        _load();
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Erro ao excluir: $e")));
      }
    }
  }

  void _openForm({EmprestimoModel? emp}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmprestimoFormView(emprestimo: emp),
      ),
    );
    _load(); // atualizar lista após fechar formulário
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Empréstimos"),
      ),
      body: _carregando
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(8),
                  child: TextField(
                    controller: _buscarField,
                    decoration: InputDecoration(labelText: "Pesquisar Empréstimo"),
                    onChanged: (value) => _filtrar(),
                  ),
                ),
                Divider(),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(8),
                    itemCount: _emprestimosFiltrados.length,
                    itemBuilder: (context, index) {
                      final emp = _emprestimosFiltrados[index];
                      return Card(
                        child: ListTile(
                          leading: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => _openForm(emp: emp),
                          ),
                          title: Text(emp.livroId),
                          subtitle: Text("Usuário: ${emp.idUsuarioId}\nData: ${emp.dataEmprestimo}"),
                          isThreeLine: true,
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _delete(emp),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        child: Icon(Icons.add),
      ),
    );
  }
}
