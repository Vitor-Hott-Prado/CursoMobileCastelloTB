
import 'package:biblioteca_app/controllers/livro_cntroller.dart';
import 'package:biblioteca_app/models/livro_model.dart';
import 'package:biblioteca_app/viws/livros/livros_from_view.dart';
import 'package:flutter/material.dart';

class LivroListView extends StatefulWidget {
  const LivroListView({super.key});

  @override
  State<LivroListView> createState() => _LivroListViewState();
}

class _LivroListViewState extends State<LivroListView> {
  //atributos
  final _buscarField = TextEditingController();
  List<LivroModel> _livrosFiltrados = [];
  final _controller = LivroController();
  List<LivroModel> _livros = [];
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
      _livros = await _controller.fetchALL();
      _livrosFiltrados = _livros;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
    setState(() {
      _carregando = false;
    });
  }

  void _filtrar() {
    final busca = _buscarField.text.toLowerCase();
    setState(() {
      _livrosFiltrados = _livros.where((livro) {
        return livro.titulo.toLowerCase().contains(busca) ||
            livro.autor.toLowerCase().contains(busca);
      }).toList();
    });
  }

  void _delete(LivroModel livro) async {
    if (livro.id == null) return;
    final confirme = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirma Exclusão"),
        content: Text("Deseja realmente excluir o livro '${livro.titulo}'?"),
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
        await _controller.delete(livro.id!);
        _load();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao deletar livro: $e")),
        );
      }
    }
  }

  void _openForm({LivroModel? livro}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LivroFormView(livro: livro)),
    );
    _load(); // recarrega a lista após o retorno do formulário
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Livros"),
      ),
      body: _carregando
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _buscarField,
                    decoration: InputDecoration(
                      labelText: "Pesquisar Livro",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => _filtrar(),
                  ),
                ),
                Divider(),
                Expanded(
                  child: _livrosFiltrados.isEmpty
                      ? Center(child: Text("Nenhum livro encontrado."))
                      : ListView.builder(
                          padding: EdgeInsets.all(8),
                          itemCount: _livrosFiltrados.length,
                          itemBuilder: (context, index) {
                            final livro = _livrosFiltrados[index];
                            return Card(
                              child: ListTile(
                                leading: IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () => _openForm(livro: livro),
                                ),
                                title: Text(livro.titulo),
                                subtitle: Text("Autor: ${livro.autor}"),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _delete(livro),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        child: Icon(Icons.add),
      ),
    );
  }
}
