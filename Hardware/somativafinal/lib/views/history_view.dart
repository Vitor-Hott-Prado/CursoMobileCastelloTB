import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../controllers/auth_controller.dart';
import '../controllers/point_controller.dart';

class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthController();
    final pointController = PointController();
    final user = auth.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Histórico de Pontos')),
        body: const Center(child: Text('Usuário não logado')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Histórico de Pontos')),
      body: StreamBuilder<QuerySnapshot>(
        stream: pointController.listarPontos(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Nenhum ponto registrado.'));
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final dataHora = DateTime.parse(data['dataHora']);
              final formattedDate = DateFormat('dd/MM/yyyy HH:mm:ss').format(dataHora);

              return ListTile(
                leading: const Icon(Icons.access_time, color: Colors.blue),
                title: Text('Data/Hora: $formattedDate'),
                subtitle: Text(
                  'Latitude: ${data['latitude']}\n'
                  'Longitude: ${data['longitude']}\n'
                  'Distância do serviço: ${data['distanciaServico']?.toStringAsFixed(2) ?? '0'} m',
                ),
              );
            },
          );
        },
      ),
    );
  }
}
