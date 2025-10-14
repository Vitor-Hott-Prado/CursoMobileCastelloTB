import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

 // Para formatar data/hora

void main() {
  runApp(MaterialApp(home: ImagePickerScreen()));
}

class ImagePickerScreen extends StatefulWidget {
  const ImagePickerScreen({super.key});

  @override
  State<ImagePickerScreen> createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  File? _image; // Arquivo da imagem
  String? _imagePath; // Caminho da imagem
  String? _imageDateTime; // Data e hora em que foi selecionada
  final _picker = ImagePicker(); // Controlador do ImagePicker

  // Método para pegar imagem (da câmera ou galeria)
  Future<void> _getImage(ImageSource source) async {
    final XFile? fotoTemporaria = await _picker.pickImage(source: source);
    if (fotoTemporaria != null) {
      setState(() {
        _image = File(fotoTemporaria.path);
        _imagePath = fotoTemporaria.path;
        _imageDateTime = DateFormat('dd/MM/yyyy – HH:mm:ss').format(DateTime.now());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Exemplo Image Picker")),
      body: Center(
        child: SingleChildScrollView( // Evita overflow
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Mostrar a imagem selecionada
              _image != null
                  ? Column(
                      children: [
                        Image.file(_image!, height: 300),
                        SizedBox(height: 10),
                        Text("Caminho: $_imagePath", textAlign: TextAlign.center),
                        Text("Data/Hora: $_imageDateTime"),
                      ],
                    )
                  : Text("Nenhuma Imagem Selecionada"),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _getImage(ImageSource.camera),
                child: Text("Tirar Foto"),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => _getImage(ImageSource.gallery),
                child: Text("Escolher da Galeria"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
