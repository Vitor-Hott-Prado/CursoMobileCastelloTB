import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: (
          const Color.fromARGB(31, 255, 255, 255)
      
        ),
        appBar: AppBar(
          title: Text("Meu Primeiro App"),
        ),
        body: Center(
          child: Text("Óla, Mundo!!")
        ),
      )
    
    );
    
  }
}
