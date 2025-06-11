import 'package:flutter/material.dart';
import 'package:treino/models/training_rotine.dart';
import 'package:treino/services/training_routine_servece.dart';


class RoutineFormScreen extends StatefulWidget {
  final TrainingRoutine? routine; // opcional para editar futuramente

  RoutineFormScreen({this.routine});

  @override
  _RoutineFormScreenState createState() => _RoutineFormScreenState();
}

class _RoutineFormScreenState extends State<RoutineFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TrainingRoutineService _routineService = TrainingRoutineService();

  late String _name;
  late String _objective;

  @override
  void initState() {
    super.initState();
    _name = widget.routine?.name ?? '';
    _objective = widget.routine?.objective ?? '';
  }

  Future<void> _saveRoutine() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final routine = TrainingRoutine(
        id: widget.routine?.id,
        name: _name,
        objective: _objective,
      );

      if (widget.routine == null) {
        await _routineService.insertRoutine(routine);
      } else {
        await _routineService.updateRoutine(routine);
      }

      Navigator.pop(context); // Voltar para a lista depois de salvar
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.routine == null ? 'Nova Rotina' : 'Editar Rotina'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(labelText: 'Nome da Rotina'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um nome';
                  }
                  return null;
                },
                onSaved: (value) => _name = value!.trim(),
              ),
              SizedBox(height: 16),
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
