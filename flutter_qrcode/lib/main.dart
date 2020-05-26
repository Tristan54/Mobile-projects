import 'package:flutter/material.dart';
import 'package:flutterqrcode/pages/app.dart';
import 'package:flutterqrcode/pages/book.dart';

// main de l'application exécuté au démarrage
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // début de l'application
    return MaterialApp(
      // permet de supprimer la banière en haut à droite
      debugShowCheckedModeBanner: false,
      // lance l'application avec cette première page
      initialRoute: App.id,
      // routes de l'application
      routes: {
        App.id: (context) => App(),
        Book.id: (context) => Book(),
      },
    );
  }
}
