//classe controller
//pegar ageolocalização
//busca api para transforma lat e lon em localização
//tirar a photo
//retornar o OBJ 
import 'dart:convert';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:sa02_geolapi_image/models/photo_model.dart';

class PhotoController {
  //controlador para cmaer
  final _picker = ImagePicker();
  final File _file;
  String? location;
  //método que retornara um obj de photoModel

//método que rotronará um obj de photoModel
  Future<PhotoModel> getImageWithLocation() async{
    //verificar se goelocalização esta habilitada
    bool serviceEnable = await Geolocator.isLocationServiceEnabled();
    if(!serviceEnable){
      throw Exception("Servicço desabilitado");
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
      if(permission == LocationPermission.denied){
        throw Exception("Continua não Permitida");
      }
    }
   //foi liberado pelo usuario
    Position position = await Geolocator.getCurrentPosition();//lat e lon
    //chamar a api e buscar o nome da localização
    final result = await http.get(
      Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?appid=CHAVE_API&lat=${position.latitude}&lon=${position.longitude}"
        )
    );
    // verifiacar se api encontrou alguma coisa
    if(result.statusCode ==200){
      //transfomra em Map<string, dynamic>
      Map<String,dynamic> data = jsonDecode(result.body);

      location = date ["name"].toString(); // nome da cidade 
    }
  
    //tirar a photo
    final XFile? photoTirada = await _picker.pickImage(source: ImageSource.camera);
    //verificar se a photo foi tirada
    if(photoTirada != null){
      _file = File(photoTirada.path).path; //manipula
    }else{
      throw Exception("Foto nao Tirada");
    }

    //criar o obgj de PhotoModel e retornar
    final photo = PhotoModel(
      photoPath: photoPath, 
      location: location, 
      timeStam: DateTime.now().toIso8601String()); //fsts internacional (intl)
   return photo;
  }
}

