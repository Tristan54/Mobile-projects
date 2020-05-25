import 'package:flutter/material.dart';
import 'package:fluttertesttechno/pages/api_get.dart';
import 'package:fluttertesttechno/pages/app.dart';
import 'package:fluttertesttechno/pages/choose_location.dart';
import 'package:fluttertesttechno/pages/home.dart';
import 'package:fluttertesttechno/pages/loading.dart';

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
        App.id: (context) => App(),
        Home.id: (context) => Home(),
        Chooselocation.id: (context) => Chooselocation(),
        Loading.id: (context) => Loading(),
        ApiGet.id: (context) => ApiGet(),
      },
    );
  }
}
