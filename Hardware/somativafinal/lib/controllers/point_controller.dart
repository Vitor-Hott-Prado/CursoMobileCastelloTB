import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class PointController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Local de trabalho fixo em Limeira
  final double _latServico = -22.5645;  // latitude de Limeira
  final double _lonServico = -47.4006;  // longitude de Limeira

  Future<Map<String, dynamic>> registrarPonto(String userId) async {
    // Verifica GPS
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Ative o GPS para registrar o ponto.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Permissão de localização negada.');
      }
    } else if (permission == LocationPermission.deniedForever) {
      throw Exception('Permissão de localização permanentemente negada.');
    }

    // Pega posição atual
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Calcula distância até o serviço
    double distancia = Geolocator.distanceBetween(
        position.latitude, position.longitude, _latServico, _lonServico);

    // Bloqueia registro se estiver fora do serviço (100 metros)
    if (distancia > 100) {
      throw Exception('Você está fora do serviço, ponto não registrado.');
    }

    // Salva no Firestore
    await _db.collection('pontos').add({
      'userId': userId,
      'latitude': position.latitude,
      'longitude': position.longitude,
      'dataHora': DateTime.now().toIso8601String(),
      'distanciaServico': distancia,
    });

    return {
      'position': position,
      'distanciaServico': distancia,
    };
  }

  Stream<QuerySnapshot> listarPontos(String userId) {
    return _db
        .collection('pontos')
        .where('userId', isEqualTo: userId)
        .orderBy('dataHora', descending: true)
        .snapshots();
  }
}
