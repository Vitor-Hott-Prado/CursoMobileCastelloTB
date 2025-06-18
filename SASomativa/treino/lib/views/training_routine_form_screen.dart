// lib/views/training_routine_form_screen.dart
// ... (imports conforme o exemplo anterior) ...

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:treino/models/exercise.dart';
import 'package:treino/models/training_rotine.dart';

class TrainingRoutineFormScreen extends StatefulWidget{
  final TrainingRoutine? routine; // Opcional para edição

  TrainingRoutineFormScreen({this.routine});

  @override
  _TrainingRoutineFormScreenState createState() => _TrainingRoutineFormScreenState();
}

class _TrainingRoutineFormScreenState extends State<TrainingRoutineFormScreen> {
  // ... (variáveis e _formKey) ...

  late String _routineName;
  late String _objective; // Adicionado
  List<Exercise> _exercises = [];

  @override
  void initState() {
    super.initState();
    _routineName = widget.routine?.name ?? '';
    _objective = widget.routine?.objective ?? ''; // Inicializa o objetivo

    if (widget.routine != null && widget.routine!.id != null) {
      (widget.routine!.id!);
    }
  }

  // ... (métodos _loadExercisesForRoutine, _addOrEditExercise, _removeExercise) ...

  Future<void> _saveRoutine() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newRoutine = TrainingRoutine(
        id: widget.routine?.id,
        name: _routineName,
        objective: _objective, // Salva o objetivo
      );

      int routineId;
      if (widget.routine == null) {
        routineId = await _routineName.insertRoutine(newRoutine);
      } else {
        await _routineService.updateRoutine(newRoutine);
        routineId = newRoutine.id!;

        // Se estiver editando, é uma boa prática limpar e recriar os exercícios
        // para evitar complexidade de upsert individual.
        // Certifique-se que seu ExerciseService tem deleteExercisesByRoutineId
        await _exerciseService.deleteExercisesByRoutineId(routineId);
      }

      for (var exercise in _exercises) {
        exercise.routineId = routineId;
        // Não precisa verificar exercise.id aqui, pois estamos inserindo tudo novamente
        // após deletar os antigos para esta rotina. Se você não deletar antes,
        // precisará verificar se é insert ou update.
        await _.insertExercise(exercise);
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
          key: ,
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
                decoration: InputDecoration(labelText: 'Objetivo (Ex: Força, Hipertrofia)'), // Campo objetivo
                onSaved: (value) => _objective = value!.trim(),
              ),
              SizedBox(height: 20),
              Text(
                'Exercícios:',
                style: Theme.of(context).textTheme.titleLarge, // Correção para headline6
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