import 'dart:convert';

import 'package:fluttertesttechno/services/check_connection.dart';
import 'package:http/http.dart' as http;

class WorldTime {
  String location;
  String time;
  String flag;
  String url;
  bool isDaytime;

  WorldTime({this.location, this.flag, this.url});

  Future<void> getTime() async {
    // on vérifie que le device a internet
    CheckConnection checkConnection = CheckConnection();
    await checkConnection.checkConnection();

    if (checkConnection.is_connect) {
      // on fait la requête avec le package http: ^0.12.1
      http.Response response =
          await http.get('http://worldtimeapi.org/api/timezone/$url');
      Map data = jsonDecode(response.body);

      // on récupère les données qui nous intéressent
      String datetime = data['datetime'];
      String operator = data['utc_offset'].substring(0, 1);
      String offset = data['utc_offset'].substring(1, 3);

      // on créer un objet DateTime
      DateTime now = DateTime.parse(datetime);
      now = operator == '+'
          ? now.add(Duration(hours: int.parse(offset)))
          : now.subtract(Duration(hours: int.parse(offset)));

      // permet de définir si il fait nouit ou non
      isDaytime = now.hour > 6 && now.hour < 20 ? true : false;

      time = '${now.hour}:${now.minute}:${now.second}';
    } else {
      time = 'no internet connection';
      isDaytime = false;
    }
  }
}
