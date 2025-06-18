// lib/views/routine_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:treino/models/training_rotine.dart';
import 'package:treino/models/exercise.dart';
import 'package:treino/services/exercise_service.dart';
import 'package:treino/views/exercise_form_screen.dart'; // Sua tela de formulário de exercício

class RoutineDetailScreen extends StatefulWidget {
  final TrainingRoutine routine;

  RoutineDetailScreen({required this.routine});

  @override
  _RoutineDetailScreenState createState() => _RoutineDetailScreenState();
}

class _RoutineDetailScreenState extends State<RoutineDetailScreen> {
  final ExerciseService _exerciseService = ExerciseService();
  late Future<List<Exercise>> _exercisesFuture;

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  void _loadExercises() {
    if (widget.routine.id != null) {
      setState(() {
        _exercisesFuture = _exerciseService.getExercisesByRoutineId(widget.routine.id!);
      });
    } else {
      // Se a rotina não tem ID, não há exercícios salvos para ela ainda.
      setState(() {
        _exercisesFuture = Future.value([]);
      });
    }
  }

  Future<void> _navigateToAddExercise() async {
    if (widget.routine.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, salve a rotina primeiro para adicionar exercícios.')),
      );
      return;
    }
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExerciseFormScreen(routineId: widget.routine.id!),
      ),
    );

    if (result == true) { // Ou se ExerciseFormScreen retorna o exercício, capture-o
      _loadExercises(); // Recarrega os exercícios após adicionar/editar
    }
  }

  Future<void> _navigateToEditExercise(Exercise exercise) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExerciseFormScreen(
          routineId: widget.routine.id!, // Passa o ID da rotina para o formulário
          exercise: exercise, // Passa o exercício para edição
        ),
      ),
    );

    if (result == true) { // Se o formulário retorna true ao salvar/editar
      _loadExercises(); // Recarrega os exercícios
    }
  }

  Future<void> _deleteExercise(int exerciseId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmar Exclusão'),
        content: Text('Tem certeza que deseja excluir este exercício?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _exerciseService.deleteExercise(exerciseId);
      _loadExercises(); // Recarrega a lista
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Exercício excluído com sucesso!')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.routine.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Objetivo: ${widget.routine.objective}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 20),
            Text(
              'Exercícios da Rotina:',
              style: Theme.of(context).textTheme.titleLarge, // Correção para headline6
            ),
            SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List<Exercise>>(
                future: _exercisesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Erro ao carregar exercícios: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('Nenhum exercício adicionado a esta rotina.'));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final exercise = snapshot.data![index];
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
                                  onPressed: () => _navigateToEditExercise(exercise),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteExercise(exercise.id!),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _navigateToAddExercise,
              icon: Icon(Icons.add),
              label: Text('Adicionar Novo Exercício'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size.fromHeight(50), // Faz o botão ocupar a largura total
              ),
            ),
          ],
        ),
      ),
    );
  }
}