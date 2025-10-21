import 'package:geolocator/geolocator.dart';
import '../models/location_points.dart';

class MapControllerCustom {
  // Ponto fixo da empresa
  final double _latEmpresa = -23.550520;
  final double _lonEmpresa = -46.633308;

  // Ponto falso para demonstração
  final double _latFalso = -23.551500;
  final double _lonFalso = -46.632000;

  // Obter localização atual do usuário
  Future<LocationPoints> getUserLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("Ative o GPS do dispositivo");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Permissão de localização negada");
      }
    } else if (permission == LocationPermission.deniedForever) {
      throw Exception("Permissão de localização permanentemente negada");
    }

    Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    String dataHora = DateTime.now().toIso8601String();

    return LocationPoints(
      latitude: pos.latitude,
      longitude: pos.longitude,
      dataHora: dataHora,
      tipo: "usuario",
    );
  }

  // Retorna ponto da empresa
  LocationPoints getCompanyLocation() {
    return LocationPoints(
      latitude: _latEmpresa,
      longitude: _lonEmpresa,
      dataHora: DateTime.now().toIso8601String(),
      tipo: "empresa",
    );
  }

  // Retorna ponto falso
  LocationPoints getFakeLocation() {
    return LocationPoints(
      latitude: _latFalso,
      longitude: _lonFalso,
      dataHora: DateTime.now().toIso8601String(),
      tipo: "falso",
    );
  }

  // Calcula distância entre usuário e empresa
  Future<double> distanceToCompany() async {
    final userPos = await getUserLocation();
    return Geolocator.distanceBetween(
      userPos.latitude,
      userPos.longitude,
      _latEmpresa,
      _lonEmpresa,
    );
  }
}
