// Importações de pacotes e arquivos do projeto
import 'package:flutter/material.dart';
import 'package:treino/models/exercise.dart';
import 'package:treino/models/training_rotine.dart';

import 'package:treino/services/exercise_service.dart';
import 'package:treino/services/training_routine_servece.dart';

/// Tela de formulário para criar ou editar uma rotina de treino
/// incluindo a possibilidade de adicionar exercícios
class TrainingRoutineFormScreen extends StatefulWidget {
  final TrainingRoutine? routine; // Se fornecido, o formulário será usado para edição

  TrainingRoutineFormScreen({this.routine});

  @override
  _TrainingRoutineFormScreenState createState() => _TrainingRoutineFormScreenState();
}

class _TrainingRoutineFormScreenState extends State<TrainingRoutineFormScreen> {
  final _formKey = GlobalKey<FormState>(); // Chave global para o formulário

  // Campos de entrada da rotina
  late String _routineName;
  late String _objective;

  // Lista temporária de exercícios adicionados pelo usuário
  List<Exercise> _exercises = [];

  // Serviços para interação com o banco de dados
  final TrainingRoutineService _routineService = TrainingRoutineService();
  final ExerciseService _exerciseService = ExerciseService();

  @override
  void initState() {
    super.initState();

    // Preenche os campos com valores existentes, se for edição
    _routineName = widget.routine?.name ?? '';
    _objective = widget.routine?.objective ?? '';

    // Carrega exercícios da rotina (caso seja uma edição)
    if (widget.routine != null && widget.routine!.id != null) {
      _loadExercisesForRoutine(widget.routine!.id!);
    }
  }

  // Carrega exercícios do banco associados à rotina atual
  Future<void> _loadExercisesForRoutine(int routineId) async {
    final exercises = await _exerciseService.getExercisesByRoutineId(routineId);
    setState(() {
      _exercises = exercises;
    });
  }

  // Adiciona ou edita um exercício (a ser implementado)
  Future<void> _addOrEditExercise({Exercise? exercise, int? index}) async {
    // Você pode abrir um formulário de exercício com Navigator.push
    // e usar o retorno para atualizar a lista de _exercises
  }

  // Remove exercício da lista local (não remove do banco ainda)
  void _removeExercise(int index) {
    setState(() {
      _exercises.removeAt(index);
    });
  }

  // Salva a rotina e todos os exercícios associados
  Future<void> _saveRoutine() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newRoutine = TrainingRoutine(
        id: widget.routine?.id, // Mantém o ID se for edição
        name: _routineName,
        objective: _objective,
      );

      int routineId;

      // Inserção ou atualização da rotina no banco
      if (widget.routine == null) {
        routineId = await _routineService.insertRoutine(newRoutine);
      } else {
        await _routineService.updateRoutine(newRoutine);
        routineId = newRoutine.id!;

        // Remove exercícios antigos antes de inserir os novos
        await _exerciseService.deleteExercisesByRoutineId(routineId);
      }

      // Insere todos os exercícios na base
      for (var exercise in _exercises) {
        exercise.routineId = routineId; // Garante que cada exercício tenha o ID correto da rotina
        await _exerciseService.insertExercise(exercise);
      }

      Navigator.pop(context, true); // Retorna à tela anterior indicando sucesso
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

              // Campo: Nome da rotina
              TextFormField(
                initialValue: _routineName,
                decoration: InputDecoration(labelText: 'Nome da Rotina'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Insira o nome da rotina' : null,
                onSaved: (value) => _routineName = value!.trim(),
              ),
              SizedBox(height: 16),

              // Campo: Objetivo da rotina
              TextFormField(
                initialValue: _objective,
                decoration: InputDecoration(labelText: 'Objetivo (Ex: Força, Hipertrofia)'),
                onSaved: (value) => _objective = value!.trim(),
              ),
              SizedBox(height: 20),

              // Título da seção de exercícios
              Text(
                'Exercícios:',
                style: Theme.of(context).textTheme.titleLarge,
              ),

              // Botão para adicionar novo exercício
              ElevatedButton.icon(
                onPressed: () => _addOrEditExercise(),
                icon: Icon(Icons.add),
                label: Text('Adicionar Exercício'),
              ),
              SizedBox(height: 10),

              // Lista de exercícios já adicionados
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
                              subtitle: Text(
                                  '${exercise.series} Séries, ${exercise.repetitions} Reps, ${exercise.load} Carga'),
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

              // Botão para salvar a rotina inteira
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
