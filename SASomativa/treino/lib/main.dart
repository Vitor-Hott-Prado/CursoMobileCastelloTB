import 'package:flutter/material.dart';
import 'package:treino/models/training_rotine.dart';
import 'package:treino/services/training_routine_servece.dart';
import 'package:treino/views/routine_detail_screen.dart';
import 'package:treino/views/training_routine_form_screen.dart'; // Importe sua tela de formulário

void main() {
  runApp(TreinoApp());
}

class TreinoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Treinos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TrainingRoutineListScreen(),
    );
  }
}

class TrainingRoutineListScreen extends StatefulWidget {
  @override
  _TrainingRoutineListScreenState createState() => _TrainingRoutineListScreenState();
}

class _TrainingRoutineListScreenState extends State<TrainingRoutineListScreen> {
  final TrainingRoutineService _service = TrainingRoutineService();
  List<TrainingRoutine> _routines = [];

  @override
  void initState() {
    super.initState();
    _loadRoutines();
  }

  Future<void> _loadRoutines() async {
    final routines = await _service.getRoutines();
    setState(() {
      _routines = routines;
    });
  }

  void _goToAddRoutine() async {
    final created = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => TrainingRoutineFormScreen()),
    );

    if (created == true) {
      _loadRoutines();
    }
  }

  void _openRoutineDetail(TrainingRoutine routine) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => RoutineDetailScreen(routine: routine)),
    );
  }

  void _goToEditRoutine(TrainingRoutine routine) async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => TrainingRoutineFormScreen(routine: routine)),
    );
    if (updated == true) {
      _loadRoutines();
    }
  }

  Future<void> _deleteRoutine(int routineId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmar Exclusão'),
        content: Text('Tem certeza que deseja excluir esta rotina?'),
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
      await _service.deleteRoutine(routineId);
      _loadRoutines();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Rotina excluída com sucesso!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rotinas de Treino'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadRoutines,
            tooltip: 'Atualizar lista',
          ),
        ],
      ),
      body: _routines.isEmpty
          ? Center(child: Text('Nenhuma rotina cadastrada'))
          : ListView.builder(
              itemCount: _routines.length,
              itemBuilder: (_, index) {
                final routine = _routines[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 3,
                  child: ExpansionTile(
                    title: Text(
                      routine.name,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: (routine.exercises == null || routine.exercises!.isEmpty) // <--- CORREÇÃO AQUI
                              ? [Text('Nenhum exercício nesta rotina.')]
                              : routine.exercises!.map((exercise) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 4.0),
                                    child: Text(
                                      '• ${exercise.name}: ${exercise.series}x${exercise.repetitions} (${exercise.load})',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  );
                                }).toList(),
                        ),
                      ),
                      ButtonBar(
                        alignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _goToEditRoutine(routine),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteRoutine(routine.id!),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToAddRoutine,
        child: Icon(Icons.add),
        tooltip: 'Adicionar nova rotina',
      ),
    );
  }
}