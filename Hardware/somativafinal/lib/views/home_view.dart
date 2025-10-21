import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import '../controllers/point_controller.dart';
import 'history_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthController();
    final point = PointController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bater Ponto'),
        actions: [
          IconButton(
            onPressed: () {
              auth.logout();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.exit_to_app),
          )
        ],
      ),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () async {
            final user = auth.currentUser;
            if (user != null) {
              await point.registrarPonto(user.uid);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Ponto registrado com sucesso!')),
              );
            }
          },
          icon: const Icon(Icons.access_time),
          label: const Text('Registrar Ponto'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => const HistoryView()));
        },
        child: const Icon(Icons.history),
      ),
    );
  }
}
