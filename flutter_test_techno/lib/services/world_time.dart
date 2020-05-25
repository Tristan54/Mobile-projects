import 'dart:convert';

import 'package:fluttertesttechno/services/check_connection.dart';
import 'package:http/http.dart' as http;

class WorldTime {
  String location; // location name
  String time; // time in that location
  String flag; // url to on asset flag icon
  String url; // location url for api
  bool isDaytime; // true or false if daytime or not

  WorldTime({this.location, this.flag, this.url});

  Future<void> getTime() async {
    CheckConnection checkConnection = CheckConnection();
    await checkConnection.checkConnection();
    if (checkConnection.is_connect) {
      // make the request
      http.Response response =
          await http.get('http://worldtimeapi.org/api/timezone/$url');
      Map data = jsonDecode(response.body);

      // get properties from data
      String datetime = data['datetime'];
      String operator = data['utc_offset'].substring(0, 1);
      String offset = data['utc_offset'].substring(1, 3);

      // create DataTime object
      DateTime now = DateTime.parse(datetime);
      now = operator == '+'
          ? now.add(Duration(hours: int.parse(offset)))
          : now.subtract(Duration(hours: int.parse(offset)));

      // set the time property
      isDaytime = now.hour > 6 && now.hour < 20 ? true : false;

      time = '${now.hour}:${now.minute}:${now.second}';
    } else {
      time = 'no internet connection';
      isDaytime = false;
    }
  }
}
