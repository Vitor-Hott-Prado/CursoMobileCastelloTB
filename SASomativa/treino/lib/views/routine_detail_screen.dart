import 'package:flutter/material.dart';
import 'package:treino/models/exercise.dart';
import 'package:treino/models/training_rotine.dart';


import '../services/exercise_service.dart';
import 'exercise_form_screen.dart'; // Tela para adicionar/editar exercício (criaremos depois)

class RoutineDetailScreen extends StatefulWidget {
  final TrainingRoutine routine;

  RoutineDetailScreen({required this.routine});

  @override
  _RoutineDetailScreenState createState() => _RoutineDetailScreenState();
}

class _RoutineDetailScreenState extends State<RoutineDetailScreen> {
  final  ExerciseDbHelper _exerciseService = ExerciseDbHelper();
  List<Exercise> _exercises = [];

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    final exercises = await _exerciseService.getExercisesByRoutineId(widget.routine.id!);
    setState(() {
      _exercises = exercises;
    });
  }

  void _goToAddExercise() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ExerciseFormScreen(routineId: widget.routine.id!),
      ),
    );
    _loadExercises(); // Atualiza lista ao voltar
  }

  void _deleteExercise(int id) async {
    await _exerciseService.deleteExercise(id);
    _loadExercises();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.routine.name),
      ),
      body: _exercises.isEmpty
          ? Center(child: Text('Nenhum exercício cadastrado'))
          : ListView.builder(
              itemCount: _exercises.length,
              itemBuilder: (_, index) {
                final exercise = _exercises[index];
                return Card(
                  child: ListTile(
                    title: Text(exercise.name),
                    subtitle: Text(
                        'Séries: ${exercise.series}, Repetições: ${exercise.repetitions}, Carga: ${exercise.load}, Tipo: ${exercise.type}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteExercise(exercise.id!),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToAddExercise,
        child: Icon(Icons.add),
        tooltip: 'Adicionar Exercício',
      ),
    );
  }
}
