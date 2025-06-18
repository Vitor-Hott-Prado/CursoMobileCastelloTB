import 'package:flutter/material.dart';
import 'package:treino/models/exercise.dart';
import 'package:treino/models/training_rotine.dart';

import 'package:treino/services/exercise_service.dart';
import 'package:treino/services/training_routine_servece.dart';

class TrainingRoutineFormScreen extends StatefulWidget {
  final TrainingRoutine? routine;

  TrainingRoutineFormScreen({this.routine});

  @override
  _TrainingRoutineFormScreenState createState() => _TrainingRoutineFormScreenState();
}

class _TrainingRoutineFormScreenState extends State<TrainingRoutineFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _routineName;
  late String _objective;
  List<Exercise> _exercises = [];

  final TrainingRoutineService _routineService = TrainingRoutineService();
  final ExerciseService _exerciseService = ExerciseService();

  @override
  void initState() {
    super.initState();
    _routineName = widget.routine?.name ?? '';
    _objective = widget.routine?.objective ?? '';

    if (widget.routine != null && widget.routine!.id != null) {
      _loadExercisesForRoutine(widget.routine!.id!);
    }
  }

  Future<void> _loadExercisesForRoutine(int routineId) async {
    final exercises = await _exerciseService.getExercisesByRoutineId(routineId);
    setState(() {
      _exercises = exercises;
    });
  }

  Future<void> _addOrEditExercise({Exercise? exercise, int? index}) async {
    // Implemente a lógica de adicionar/editar exercício via diálogo ou nova tela.
  }

  void _removeExercise(int index) {
    setState(() {
      _exercises.removeAt(index);
    });
  }

  Future<void> _saveRoutine() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newRoutine = TrainingRoutine(
        id: widget.routine?.id,
        name: _routineName,
        objective: _objective,
      );

      int routineId;
      if (widget.routine == null) {
        routineId = await _routineService.insertRoutine(newRoutine);
      } else {
        await _routineService.updateRoutine(newRoutine);
        routineId = newRoutine.id!;
        await _exerciseService.deleteExercisesByRoutineId(routineId);
      }

      for (var exercise in _exercises) {
        exercise.routineId = routineId;
        await _exerciseService.insertExercise(exercise);
      }

      Navigator.pop(context, true);
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                initialValue: _routineName,
                decoration: InputDecoration(labelText: 'Nome da Rotina'),
                validator: (value) => value == null || value.isEmpty ? 'Insira o nome da rotina' : null,
                onSaved: (value) => _routineName = value!.trim(),
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: _objective,
                decoration: InputDecoration(labelText: 'Objetivo (Ex: Força, Hipertrofia)'),
                onSaved: (value) => _objective = value!.trim(),
              ),
              SizedBox(height: 20),
              Text(
                'Exercícios:',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              ElevatedButton.icon(
                onPressed: () => _addOrEditExercise(),
                icon: Icon(Icons.add),
                label: Text('Adicionar Exercício'),
              ),
              SizedBox(height: 10),
              Expanded(
                child: _exercises.isEmpty
                    ? Center(child: Text('Nenhum exercício adicionado ainda.'))
                    : ListView.builder(
                        itemCount: _exercises.length,
                        itemBuilder: (context, index) {
                          final exercise = _exercises[index];
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              title: Text(exercise.name),
                              subtitle: Text('${exercise.series} Séries, ${exercise.repetitions} Reps, ${exercise.load} Carga'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () => _addOrEditExercise(exercise: exercise, index: index),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _removeExercise(index),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveRoutine,
                child: Text('Salvar Rotina'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
