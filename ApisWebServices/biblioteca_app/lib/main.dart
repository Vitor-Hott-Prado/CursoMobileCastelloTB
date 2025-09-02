import 'package:flutter/material.dart';

void main(){
  runApp(MaterialApp(
    title: "Biblioteca",
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.amber,
      useMaterial3: true
    ),
    home: HomeView(),
  ));
}