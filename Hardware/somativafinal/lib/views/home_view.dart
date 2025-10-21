import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import '../controllers/auth_controller.dart';
import '../controllers/point_controller.dart';
import '../models/location_points.dart';
import 'history_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final auth = AuthController();
  final pointController = PointController();
  final flutterMapController = MapController();

  LocationPoints? userPosition;

  // Ponto da empresa em Limeira (SP)
  final LocationPoints companyPosition = LocationPoints(
    latitude: -22.5645,
    longitude: -47.4006,
    dataHora: '',
    tipo: 'empresa',
  );

  Stream<Position>? _positionStream;

  @override

  void initState() {
    super.initState();
    _initLocationStream();
  }

  void _initLocationStream() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
      ),
    );

    _positionStream!.listen((Position pos) {
      setState(() {
        userPosition = LocationPoints(
          latitude: pos.latitude,
          longitude: pos.longitude,
          dataHora: DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now()),
        );
      });

      flutterMapController.move(
        LatLng(pos.latitude, pos.longitude),
        flutterMapController.zoom,
      );
    });
  }

  // Registrar ponto com validação de distância (100 metros)
  Future<void> registerPoint() async {
    final user = auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuário não logado')),
      );
      return;
    }

    if (userPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Localização não disponível')),
      );
      return;
    }

    final distancia = Geolocator.distanceBetween(
      userPosition!.latitude,
      userPosition!.longitude,
      companyPosition.latitude,
      companyPosition.longitude,
    );

    if (distancia > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Você está fora do serviço. Ponto não registrado.'),
        ),
      );
      return;
    }

    try {
      final result = await pointController.registrarPonto(user.uid);

      final pos = result['position'];
      final distancia = result['distanciaServico'];

      setState(() {
        userPosition = LocationPoints(
          latitude: pos.latitude,
          longitude: pos.longitude,
          dataHora: DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now()),
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Ponto registrado!\n'
            'Latitude: ${pos.latitude}\n'
            'Longitude: ${pos.longitude}\n'
            'Distância do serviço: ${distancia.toStringAsFixed(2)} m\n'
            'Data/Hora: ${userPosition!.dataHora}',
          ),
          duration: const Duration(seconds: 5),
        ),
      );

      flutterMapController.move(LatLng(pos.latitude, pos.longitude), 16);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao registrar ponto: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
          ),
        ],
      ),
      body: Column(
        children: [
          // Mapa
          Expanded(
            flex: 3,
            child: FlutterMap(
              mapController: flutterMapController,
              options: MapOptions(
                center: userPosition != null
                    ? LatLng(userPosition!.latitude, userPosition!.longitude)
                    : LatLng(companyPosition.latitude, companyPosition.longitude),
                zoom: 16,
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                  userAgentPackageName: 'com.example.somativafinal',
                ),
                MarkerLayer(
                  markers: [
                    // Marcador da empresa
                    Marker(
                      point: LatLng(companyPosition.latitude, companyPosition.longitude),
                      width: 50,
                      height: 50,
                      child: const Icon(Icons.location_on, color: Colors.red, size: 40),
                    ),
                    // Marcador do usuário
                    if (userPosition != null)
                      Marker(
                        point: LatLng(userPosition!.latitude, userPosition!.longitude),
                        width: 50,
                        height: 50,
                        child: const Icon(Icons.person_pin_circle, color: Colors.blue, size: 40),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Botão Registrar Ponto
          ElevatedButton.icon(
            icon: const Icon(Icons.access_time),
            label: const Text('Registrar Ponto'),
            onPressed: registerPoint,
          ),
          const SizedBox(height: 10),
          // Histórico de pontos
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HistoryView()),
              );
            },
            child: const Icon(Icons.history),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
