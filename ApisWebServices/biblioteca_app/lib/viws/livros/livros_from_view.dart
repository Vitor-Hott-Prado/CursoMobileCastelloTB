
import 'package:biblioteca_app/controllers/livro_cntroller.dart';
import 'package:biblioteca_app/models/livro_model.dart';
import 'package:flutter/material.dart';

class LivroFormView extends StatefulWidget {
  final LivroModel? livro;

  const LivroFormView({super.key, this.livro});

  @override
  State<LivroFormView> createState() => _LivroFormViewState();
}

class _LivroFormViewState extends State<LivroFormView> {
  final _formKey = GlobalKey<FormState>();
  final _controller = LivroController();
  final _tituloField = TextEditingController();
  final _autorField = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.livro != null) {
      _tituloField.text = widget.livro!.titulo;
      _autorField.text = widget.livro!.autor;
    }
  }

  void _criar() async {
    if (_formKey.currentState!.validate()) {
      final novoLivro = LivroModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        titulo: _tituloField.text.trim(),
        autor: _autorField.text.trim(), disponivl: null,
      );
      try {
        await _controller.creat(novoLivro);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Livro criado com sucesso!")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao criar livro: $e")),
        );
      }
      Navigator.pop(context);
    }
  }

  void _atualizar() async {
    if (_formKey.currentState!.validate()) {
      final livroAtualizado = LivroModel(
        id: widget.livro!.id,
        titulo: _tituloField.text.trim(),
        autor: _autorField.text.trim(), disponivl: null,
      );
      try {
        await _controller.update(livroAtualizado);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Livro atualizado com sucesso!")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao atualizar livro: $e")),
        );
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.livro == null ? "Novo Livro" : "Editar Livro"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _tituloField,
                decoration: InputDecoration(labelText: "Título"),
                validator: (value) =>
                    value!.isEmpty ? "Informe o título" : null,
              ),
              TextFormField(
                controller: _autorField,
                decoration: InputDecoration(labelText: "Autor"),
                validator: (value) => value!.isEmpty ? "Informe o autor" : null,
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: widget.livro == null ? _criar : _atualizar,
                child: Text(widget.livro == null ? "Salvar" : "Atualizar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
