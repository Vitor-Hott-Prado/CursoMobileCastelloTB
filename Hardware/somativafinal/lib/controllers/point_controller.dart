import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class PointController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> registrarPonto(String userId) async {
    final position = await Geolocator.getCurrentPosition();

    await _db.collection('pontos').add({
      'userId': userId,
      'latitude': position.latitude,
      'longitude': position.longitude,
      'dataHora': DateTime.now().toIso8601String(),
    });
  }

  Stream<QuerySnapshot> listarPontos(String userId) {
    return _db
        .collection('pontos')
        .where('userId', isEqualTo: userId)
        .orderBy('dataHora', descending: true)
        .snapshots();
  }
}
