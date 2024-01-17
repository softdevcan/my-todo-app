import 'package:flutter/material.dart';
import 'home_page.dart'; // Eklenen satır

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark, // Tema parlaklığı
        primaryColor: Colors.amber, // Ana renk
        scaffoldBackgroundColor: Colors.indigoAccent, // Arka plan rengi
      ),
      home: HomePage(),
    );
  }
}
