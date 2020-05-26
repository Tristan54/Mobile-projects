import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertesttechno/pages/choose_location.dart';
import 'package:fluttertesttechno/services/world_time.dart';

class Home extends StatefulWidget {
  // identifiant de la classe pour les routes
  static final String id = 'home_screen';

  final Map p_data;

  const Home({
    Key key,
    this.p_data,
  }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map data = {};

  // actualise les données
  void getTime() async {
    WorldTime instance = WorldTime(
        location: data['location'], flag: data['flag'], url: data['url']);
    await instance.getTime();

    data = {
      'time': instance.time,
      'location': instance.location,
      'isDaytime': instance.isDaytime,
      'flag': instance.flag,
      'url': instance.url,
    };
  }

  @override
  Widget build(BuildContext context) {
    // récupération des données
    data = data.isNotEmpty ? data : widget.p_data;

    // création du Timer pour l'actualisation
    const oneSecond = const Duration(seconds: 15);
    new Timer.periodic(
        oneSecond,
        (Timer t) => () {
              setState(() {
                getTime();
              });
            });

    // changement de couleur en fonction de l'heure
    String image = data['isDaytime'] ? 'day.jpg' : 'night.jpg';
    Color textColor = data['isDaytime'] ? Colors.black : Colors.white;

    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage('assets/$image'),
        fit: BoxFit.cover,
      )),
      child: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 200.0,
            ),
            FlatButton.icon(
              onPressed: () async {
                // on push une page au dessus de la courante pour choisir une nouvelle localisation
                dynamic result =
                    await Navigator.pushNamed(context, Chooselocation.id);
                // on actualise les données
                setState(() {
                  data = {
                    'time': result['time'],
                    'location': result['location'],
                    'isDaytime': result['isDaytime'],
                    'flag': result['flag'],
                    'url': result['url'],
                  };
                });
              },
              icon: Icon(
                Icons.add_location,
                color: textColor,
              ),
              label: Text(
                'Edit location',
                style: TextStyle(color: textColor),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              data['location'],
              style: TextStyle(
                  fontSize: 35.0, letterSpacing: 2.0, color: textColor),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              data['time'],
              style: TextStyle(fontSize: 60.0, color: textColor),
            ),
          ],
        ),
      ),
    );
  }
}
