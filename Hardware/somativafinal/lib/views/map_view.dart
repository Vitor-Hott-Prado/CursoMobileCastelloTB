//mapa com marcação de pontos

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:somativafinal/controllers/point_controller.dart';
import 'package:somativafinal/models/location_points.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  //atributos
  List<LocationPoints> listarPontos = []; //lista com os pontos marcados no map
   final _pointController =  PointController(); //obj de controller da classe pointController
  final MapController _flutterMapController = MapController();// obj do controller para manipulação do Mapa (criada pela biblioteca flutter_map)

  bool _isLoading = false;
  String? _erro;

  //método para adicionar o ponto no mapa
  void _adicionarPonto() async {
    setState(() {
      _isLoading = true;
      _erro = null;
    });
    try {
      //pegar a localização atual
     LocationPoints novaMarcacao = await _pointController.getCurrentPosition();

      listarPontos.add(novaMarcacao);
      //deslocar o mpara para o ponto marcado 
      _flutterMapController.move(LatLng(novaMarcacao.latitude, novaMarcacao.longitude),11);
    
    } catch (e) {
      _erro = e.toString();
      //mostrar o erro
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  //build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //adicionar pontos no Mapa
      //adicionar a biblioteca Flutter_Map(flutter_map)
      appBar: AppBar(
        title: Text("Mapa de Localização"),
        actions: [
          IconButton(
            //evita de apertar o botão seguidamente
            onPressed: _isLoading ? null : _adicionarPonto,
            icon: _isLoading
                ? Padding(
                    padding: EdgeInsets.all(8),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Icon(Icons.add_location_alt),
          ),
        ],
      ),
      body: FlutterMap(
        mapController: _flutterMapController , //manipular a imagem do mapa

        options: MapOptions(
          initialCenter: LatLng(-22.352, -47.2406), //qunado abrir  o mapa , cidade de limeira 
          initialZoom: 11,
        ),
        // mmapa funciona com camadas (pilhas - Stack)
        children: [
          //camada imagem do mapa
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            userAgentPackageName: "com.example.sa_locator.maps",
          ),
          // proxima camada pontos de Marcação
        MarkerLayer(
          markers: listarPontos.map(
            (ponto) => Marker(
              point: LatLng(ponto.latitude, ponto.longitude), 
              width: 50,
              height: 50,
              child: Icon(Icons.location_on, color: Colors.red, size: 35)) 
          ).toList())
        ]),
    );
  }
}
