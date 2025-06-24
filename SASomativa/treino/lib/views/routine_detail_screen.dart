import 'package:flutter/material.dart';
import 'package:treino/models/training_rotine.dart';
import 'package:treino/models/exercise.dart';
import 'package:treino/services/exercise_service.dart';
import 'package:treino/views/exercise_form_screen.dart'; // Tela de formulário para adicionar/editar exercícios

/// Tela que mostra os detalhes de uma rotina de treino, incluindo os exercícios associados.
class RoutineDetailScreen extends StatefulWidget {
  final TrainingRoutine routine; // Rotina que será exibida

  RoutineDetailScreen({required this.routine});

  @override
  _RoutineDetailScreenState createState() => _RoutineDetailScreenState();
}

class _RoutineDetailScreenState extends State<RoutineDetailScreen> {
  final ExerciseService _exerciseService = ExerciseService(); // Serviço de acesso ao banco
  late Future<List<Exercise>> _exercisesFuture; // Lista futura de exercícios da rotina

  @override
  void initState() {
    super.initState();
    _loadExercises(); // Carrega os exercícios ao iniciar a tela
  }

  /// Carrega os exercícios da rotina atual
  void _loadExercises() {
    if (widget.routine.id != null) {
      setState(() {
        _exercisesFuture = _exerciseService.getExercisesByRoutineId(widget.routine.id!);
      });
    } else {
      // Se a rotina ainda não tem ID (não foi salva), retorna uma lista vazia
      setState(() {
        _exercisesFuture = Future.value([]);
      });
    }
  }

  /// Navega para o formulário para adicionar novo exercício
  Future<void> _navigateToAddExercise() async {
    if (widget.routine.id == null) {
      // Garante que a rotina esteja salva antes de permitir adicionar exercícios
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, salve a rotina primeiro para adicionar exercícios.')),
      );
      return;
    }

    // Vai para a tela de formulário
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExerciseFormScreen(routineId: widget.routine.id!),
      ),
    );

    // Se retornou algo (como true), recarrega os exercícios
    if (result == true) {
      _loadExercises();
    }
  }

  /// Navega para o formulário com dados do exercício preenchidos para edição
  Future<void> _navigateToEditExercise(Exercise exercise) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExerciseFormScreen(
          routineId: widget.routine.id!,
          exercise: exercise,
        ),
      ),
    );

    if (result == true) {
      _loadExercises(); // Recarrega a lista após edição
    }
  }

  /// Exclui o exercício após confirmação do usuário
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
      _loadExercises(); // Atualiza a lista após deletar
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
            // Exibe o objetivo da rotina
            Text(
              'Objetivo: ${widget.routine.objective}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 20),

            // Título da seção de exercícios
            Text(
              'Exercícios da Rotina:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 10),

            // Lista de exercícios
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
                                // Botão de editar
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => _navigateToEditExercise(exercise),
                                ),
                                // Botão de deletar
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

            // Botão para adicionar novo exercício
            ElevatedButton.icon(
              onPressed: _navigateToAddExercise,
              icon: Icon(Icons.add),
              label: Text('Adicionar Novo Exercício'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size.fromHeight(50), // Botão ocupa largura total
              ),
            ),
          ],
        ),
      ),
    );
  }
}
