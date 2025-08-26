import 'package:biblioteca_app/viws/home_view.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(MaterialApp(
    title: "Blinlioteca ",
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.blue,
      useMaterial3: true
      ),
      home: HomeView(),
      ));

}