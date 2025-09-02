

import 'package:biblioteca_app/controllers/emprestiomo_cntroller.dart';
import 'package:biblioteca_app/controllers/livro_cntroller.dart';
import 'package:biblioteca_app/controllers/usuario_cntroller.dart';
import 'package:biblioteca_app/models/emprestimo_model.dart';
import 'package:biblioteca_app/models/usuario_model.dart';
import 'package:biblioteca_app/models/livro_model.dart';
import 'package:flutter/material.dart';

class EmprestimoFormView extends StatefulWidget {
  final EmprestimoModel? emprestimo;

  const EmprestimoFormView({super.key, this.emprestimo});

  @override
  State<EmprestimoFormView> createState() => _EmprestimoFormViewState();
}

class _EmprestimoFormViewState extends State<EmprestimoFormView> {
  final _formKey = GlobalKey<FormState>();
  final _controller = EmprestiomoCntroller();

  List<UsuarioModel> _usuarios = [];
  List<LivroModel> _livros = [];

  UsuarioModel? _usuarioSelecionado;
  LivroModel? _livroSelecionado;
  DateTime? _dataEmprestimo;

  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      _usuarios = await UsuarioContoller().fetchALL();
      _livros = await LivroController().fetchALL();

      if (widget.emprestimo != null) {
        _usuarioSelecionado =
            _usuarios.firstWhere((u) => u.id == widget.emprestimo!.idUsuarioId);
        _livroSelecionado =
            _livros.firstWhere((l) => l.id == widget.emprestimo!.livroId);
        _dataEmprestimo = widget.emprestimo!.dataDevolucao;
      } else {
        _dataEmprestimo = DateTime.now();
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erro ao carregar dados: $e')));
    }
    setState(() {
      _carregando = false;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dataEmprestimo ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _dataEmprestimo) {
      setState(() {
        _dataEmprestimo = picked;
      });
    }
  }

  void _salvar() async {
    if (!_formKey.currentState!.validate()) return;
    if (_usuarioSelecionado == null || _livroSelecionado == null || _dataEmprestimo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Selecione usuário, livro e data do empréstimo')),
      );
      return;
    }

    final novoEmprestimo = (
      id: widget.emprestimo?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      usuarioId: _usuarioSelecionado!.id!,
      usuarioNome: _usuarioSelecionado!.nome,
      livroId: _livroSelecionado!.id!,
      livroTitulo: _livroSelecionado!.titulo,
      dataEmprestimo: _dataEmprestimo!,
    );

    try {
      if (widget.emprestimo == null) {
        await _controller.create(novoEmprestimo);
      } else {
        await _controller.update(novoEmprestimo);
      }
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erro ao salvar: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.emprestimo == null ? 'Novo Empréstimo' : 'Editar Empréstimo'),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.emprestimo == null ? 'Novo Empréstimo' : 'Editar Empréstimo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<UsuarioModel>(
                value: _usuarioSelecionado,
                decoration: InputDecoration(labelText: 'Usuário'),
                items: _usuarios
                    .map((u) => DropdownMenuItem(
                          value: u,
                          child: Text(u.nome),
                        ))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    _usuarioSelecionado = val;
                  });
                },
                validator: (val) => val == null ? 'Selecione um usuário' : null,
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<LivroModel>(
                value: _livroSelecionado,
                decoration: InputDecoration(labelText: 'Livro'),
                items: _livros
                    .map((l) => DropdownMenuItem(
                          value: l,
                          child: Text(l.titulo),
                        ))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    _livroSelecionado = val;
                  });
                },
                validator: (val) => val == null ? 'Selecione um livro' : null,
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _dataEmprestimo == null
                          ? 'Data não selecionada'
                          : 'Data do Empréstimo: ${_dataEmprestimo!.toLocal().toString().split(' ')[0]}',
                    ),
                  ),
                  TextButton(
                    onPressed: () => _selectDate(context),
                    child: Text('Selecionar Data'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _salvar,
                child: Text(widget.emprestimo == null ? 'Salvar' : 'Atualizar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
