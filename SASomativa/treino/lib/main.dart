import 'package:flutter/material.dart';
import 'package:treino/models/training_rotine.dart';
import 'package:treino/services/training_routine_servece.dart';
import 'views/routine_detail_screen.dart';

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
    // Aqui você pode implementar uma tela para adicionar rotinas (opcional)
  }

  void _openRoutineDetail(TrainingRoutine routine) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => RoutineDetailScreen(routine: routine)),
    );
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
                return ListTile(
                  title: Text(routine.name),
                  subtitle: Text('Objetivo: ${routine.objective}'),
                  onTap: () => _openRoutineDetail(routine),
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
