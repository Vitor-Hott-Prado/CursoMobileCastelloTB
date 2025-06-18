import 'package:flutter/material.dart';
import '../models/exercise.dart';
import '../services/exercise_service.dart';

class ExerciseFormScreen extends StatefulWidget {
  final int routineId;
  final Exercise? exercise; // opcional para edição

  ExerciseFormScreen({required this.routineId, this.exercise});

  @override
  _ExerciseFormScreenState createState() => _ExerciseFormScreenState();
}

class _ExerciseFormScreenState extends State<ExerciseFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final  _exerciseService = ExerciseService();

  late String _name;
  late int _series;
  late String _repetitions;
  late String _load;
  late String _type;

  @override
  void initState() {
    super.initState();

    _name = widget.exercise?.name ?? '';
    _series = widget.exercise?.series ?? 1;
    _repetitions = widget.exercise?.repetitions ?? '';
    _load = widget.exercise?.load ?? '';
    _type = widget.exercise?.type ?? '';
  }

  Future<void> _saveExercise() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final exercise = Exercise(
        id: widget.exercise?.id,
        routineId: widget.routineId,
        name: _name,
        series: _series,
        repetitions: _repetitions,
        load: _load,
        type: _type,
      );

      if (widget.exercise == null) {
        await _exerciseService.insertExercise(exercise);
      } else {
        await _exerciseService.updateExercise(exercise);
      }

      Navigator.pop(context);
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
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(labelText: 'Nome do Exercício'),
                validator: (value) => value == null || value.isEmpty ? 'Insira o nome' : null,
                onSaved: (value) => _name = value!.trim(),
              ),
              SizedBox(height: 16),
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
              TextFormField(
                initialValue: _repetitions,
                decoration: InputDecoration(labelText: 'Repetições'),
                validator: (value) => value == null || value.isEmpty ? 'Insira as repetições' : null,
                onSaved: (value) => _repetitions = value!.trim(),
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: _load,
                decoration: InputDecoration(labelText: 'Carga'),
                validator: (value) => value == null || value.isEmpty ? 'Insira a carga' : null,
                onSaved: (value) => _load = value!.trim(),
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: _type,
                decoration: InputDecoration(labelText: 'Tipo (Força, Cardio, Alongamento, etc.)'),
                validator: (value) => value == null || value.isEmpty ? 'Insira o tipo' : null,
                onSaved: (value) => _type = value!.trim(),
              ),
              SizedBox(height: 32),
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
