import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../controllers/auth_controller.dart';
import '../controllers/point_controller.dart';
import 'package:intl/intl.dart';

class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthController();
    final point = PointController();
    final user = auth.currentUser!;

    return Scaffold(
      appBar: AppBar(title: const Text('Histórico de Pontos')),
      body: StreamBuilder<QuerySnapshot>(
        stream: point.listarPontos(user.uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return const Center(child: Text('Nenhum ponto registrado ainda.'));
          }
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, i) {
              final data = docs[i].data() as Map<String, dynamic>;
              final dataHora = DateTime.parse(data['dataHora']);
              final format = DateFormat('dd/MM/yyyy HH:mm');
              return ListTile(
                leading: const Icon(Icons.access_time, color: Colors.blue),
                title: Text(format.format(dataHora)),
                subtitle: Text(
                    'Lat: ${data['latitude']}\nLng: ${data['longitude']}'),
              );
            },
          );
        },
      ),
    );
  }
}
