import 'package:flutter/material.dart';
import 'package:treino/models/training_rotine.dart';
import 'package:treino/services/training_routine_servece.dart'; // Serviço que lida com banco de dados

/// Tela de formulário para criar ou editar uma rotina de treino
class RoutineFormScreen extends StatefulWidget {
  final TrainingRoutine? routine; // Rotina existente, se for edição

  RoutineFormScreen({this.routine});

  @override
  _RoutineFormScreenState createState() => _RoutineFormScreenState();
}

class _RoutineFormScreenState extends State<RoutineFormScreen> {
  final _formKey = GlobalKey<FormState>(); // Chave para validar e salvar o formulário
  final TrainingRoutineService _routineService = TrainingRoutineService(); // Instância do serviço de rotina

  late String _name;      // Nome da rotina
  late String _objective; // Objetivo da rotina

  @override
  void initState() {
    super.initState();
    // Inicializa os campos com valores existentes (caso esteja editando), ou vazios (caso esteja criando)
    _name = widget.routine?.name ?? '';
    _objective = widget.routine?.objective ?? '';
  }

  /// Salva ou atualiza a rotina
  Future<void> _saveRoutine() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // Salva os dados do formulário

      // Cria uma instância da rotina com os dados do formulário
      final routine = TrainingRoutine(
        id: widget.routine?.id, // Se estiver editando, mantém o ID
        name: _name,
        objective: _objective,
      );

      // Se for nova rotina, insere no banco. Senão, atualiza.
      if (widget.routine == null) {
        await _routineService.insertRoutine(routine);
      } else {
        await _routineService.updateRoutine(routine);
      }

      Navigator.pop(context); // Fecha a tela e volta para a anterior
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Título muda conforme for criação ou edição
        title: Text(widget.routine == null ? 'Nova Rotina' : 'Editar Rotina'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey, // Liga o formulário à chave para validação
          child: Column(
            children: [
              // Campo de texto para o nome da rotina
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(labelText: 'Nome da Rotina'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um nome';
                  }
                  return null;
                },
                onSaved: (value) => _name = value!.trim(), // Remove espaços extras
              ),
              SizedBox(height: 16),

              // Campo de texto para o objetivo da rotina
              TextFormField(
                initialValue: _objective,
                decoration: InputDecoration(labelText: 'Objetivo'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um objetivo';
                  }
                  return null;
                },
                onSaved: (value) => _objective = value!.trim(),
              ),
              SizedBox(height: 32),

              // Botão para salvar a rotina
              ElevatedButton(
                onPressed: _saveRoutine,
                child: Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
