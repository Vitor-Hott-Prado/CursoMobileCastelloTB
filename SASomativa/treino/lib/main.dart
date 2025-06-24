// Importações dos pacotes do Flutter e arquivos do seu projeto
import 'package:flutter/material.dart';
import 'package:treino/models/training_rotine.dart';
import 'package:treino/services/training_routine_servece.dart';
import 'package:treino/views/routine_detail_screen.dart';
import 'package:treino/views/training_routine_form_screen.dart'; // Tela de criação/edição de rotina

// Função principal que inicia o app
void main() {
  runApp(TreinoApp());
}

// Widget raiz do app
class TreinoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Treinos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TrainingRoutineListScreen(), // Tela inicial
    );
  }
}

// Tela que lista todas as rotinas de treino
class TrainingRoutineListScreen extends StatefulWidget {
  @override
  _TrainingRoutineListScreenState createState() => _TrainingRoutineListScreenState();
}

class _TrainingRoutineListScreenState extends State<TrainingRoutineListScreen> {
  final TrainingRoutineService _service = TrainingRoutineService(); // Serviço para banco
  List<TrainingRoutine> _routines = []; // Lista de rotinas

  @override
  void initState() {
    super.initState();
    _loadRoutines(); // Carrega rotinas ao iniciar
  }

  // Busca rotinas do banco e atualiza a lista
  Future<void> _loadRoutines() async {
    final routines = await _service.getRoutines();
    setState(() {
      _routines = routines;
    });
  }

  // Navega para tela de adicionar nova rotina
  void _goToAddRoutine() async {
    final created = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => TrainingRoutineFormScreen()),
    );

    if (created == true) {
      _loadRoutines(); // Atualiza lista ao voltar
    }
  }

  // Abre os detalhes da rotina selecionada
  void _openRoutineDetail(TrainingRoutine routine) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => RoutineDetailScreen(routine: routine)),
    );
  }

  // Edita uma rotina existente
  void _goToEditRoutine(TrainingRoutine routine) async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => TrainingRoutineFormScreen(routine: routine)),
    );

    if (updated == true) {
      _loadRoutines(); // Recarrega lista após edição
    }
  }

  // Exclui uma rotina após confirmação
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
            onPressed: _loadRoutines, // Atualiza manualmente
            tooltip: 'Atualizar lista',
          ),
        ],
      ),
      body: _routines.isEmpty
          ? Center(child: Text('Nenhuma rotina cadastrada')) // Quando não há rotinas
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
                          // Verifica se há exercícios; evita erro de null
                          children: (routine.exercises == null || routine.exercises!.isEmpty)
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
