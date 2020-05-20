import 'package:flutter/material.dart';
import 'package:fluttertesttechno/pages/home.dart';
import 'package:fluttertesttechno/pages/loading.dart';
import 'package:fluttertesttechno/pages/choose_location.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // retire la bannière debug
      debugShowCheckedModeBanner: false,
      // définis la page qui va être appelée au lancement de l'application
      initialRoute: Loading.id,
      // liste des routes de l'application qui peuvent être utilisées dans toute l'app
      routes: {
        Home.id : (context) => Home(),
        Chooselocation.id : (context) => Chooselocation(),
        Loading.id : (context) => Loading(),
      },
    );
  }
}
