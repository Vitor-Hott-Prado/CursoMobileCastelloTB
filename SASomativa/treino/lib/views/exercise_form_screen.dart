import 'package:flutter/material.dart';
import '../models/exercise.dart';
import '../services/exercise_service.dart';

/// Tela de formulário para adicionar ou editar um exercício
class ExerciseFormScreen extends StatefulWidget {
  final int routineId; // ID da rotina à qual o exercício pertence
  final Exercise? exercise; // Exercício existente, se for edição

  ExerciseFormScreen({required this.routineId, this.exercise});

  @override
  _ExerciseFormScreenState createState() => _ExerciseFormScreenState();
}

class _ExerciseFormScreenState extends State<ExerciseFormScreen> {
  final _formKey = GlobalKey<FormState>(); // Chave para validar o formulário
  final _exerciseService = ExerciseService(); // Serviço para operações no banco

  // Variáveis para armazenar os dados do formulário
  late String _name;
  late int _series;
  late String _repetitions;
  late String _load;
  late String _type;

  @override
  void initState() {
    super.initState();

    // Inicializa os campos com os dados do exercício se for edição
    _name = widget.exercise?.name ?? '';
    _series = widget.exercise?.series ?? 1;
    _repetitions = widget.exercise?.repetitions ?? '';
    _load = widget.exercise?.load ?? '';
    _type = widget.exercise?.type ?? '';
  }

  /// Salva o exercício no banco (inserção ou atualização)
  Future<void> _saveExercise() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final exercise = Exercise(
        id: widget.exercise?.id, // Se for edição, mantém o ID
        routineId: widget.routineId,
        name: _name,
        series: _series,
        repetitions: _repetitions,
        load: _load,
        type: _type,
      );

      // Decide se vai inserir ou atualizar com base em `widget.exercise`
      if (widget.exercise == null) {
        await _exerciseService.insertExercise(exercise);
      } else {
        await _exerciseService.updateExercise(exercise);
      }

      Navigator.pop(context); // Retorna para a tela anterior
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exercise == null ? 'Novo Exercício' : 'Editar Exercício'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Campo Nome
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(labelText: 'Nome do Exercício'),
                validator: (value) => value == null || value.isEmpty ? 'Insira o nome' : null,
                onSaved: (value) => _name = value!.trim(),
              ),
              SizedBox(height: 16),

              // Campo Séries
              TextFormField(
                initialValue: _series.toString(),
                decoration: InputDecoration(labelText: 'Séries'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Insira o número de séries';
                  if (int.tryParse(value) == null) return 'Digite um número válido';
                  return null;
                },
                onSaved: (value) => _series = int.parse(value!),
              ),
              SizedBox(height: 16),

              // Campo Repetições
              TextFormField(
                initialValue: _repetitions,
                decoration: InputDecoration(labelText: 'Repetições'),
                validator: (value) => value == null || value.isEmpty ? 'Insira as repetições' : null,
                onSaved: (value) => _repetitions = value!.trim(),
              ),
              SizedBox(height: 16),

              // Campo Carga
              TextFormField(
                initialValue: _load,
                decoration: InputDecoration(labelText: 'Carga'),
                validator: (value) => value == null || value.isEmpty ? 'Insira a carga' : null,
                onSaved: (value) => _load = value!.trim(),
              ),
              SizedBox(height: 16),

              // Campo Tipo
              TextFormField(
                initialValue: _type,
                decoration: InputDecoration(labelText: 'Tipo (Força, Cardio, Alongamento, etc.)'),
                validator: (value) => value == null || value.isEmpty ? 'Insira o tipo' : null,
                onSaved: (value) => _type = value!.trim(),
              ),
              SizedBox(height: 32),

              // Botão de salvar
              ElevatedButton(
                onPressed: _saveExercise,
                child: Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
