import 'dart:convert';

import 'package:fluttertesttechno/pages/api_get.dart';
import 'package:fluttertesttechno/services/check_connection.dart';
import 'package:http/http.dart' as http;

import 'cache_manager_get.dart';

class ApiKey {
  List<Param> params;
  Map results;

  Future<void> get({List params}) async {
    CheckConnection checkConnection = CheckConnection();
    await checkConnection.checkConnection();

    //if (checkConnection.is_connect) {
    // make the request
    var build_params = new StringBuffer();
    for (int i = 0; i < params.length; i++) {
      Param element = params[i];
      if (params.length == 1) {
        build_params.write(element.key + '=' + element.value);
      } else {
        if (i == params.length - 1) {
          build_params.write(element.key + '=' + element.value);
        } else {
          build_params.write(element.key + '=' + element.value + '&');
        }
      }
    }

    String url = 'https://api-public.univ-lorraine.fr/demo?$build_params';
    Map<String, String> headers = {
      'X-Gravitee-Api-Key': '97138730-a63f-4f14-a33e-4649c3a11791'
    };

    var file = await MyCacheManagerGet().getSingleFile(url, headers: headers);
    if (file != null && await file.exists()) {
      var response = await file.readAsString();

      Map data = jsonDecode(response.toString());
      results = data['query_params'];
    }
    //}
  }

  Future<void> post({List<Param> body}) async {
    CheckConnection checkConnection = CheckConnection();
    await checkConnection.checkConnection();

    if (checkConnection.is_connect) {
      // make the request

      Map<String, String> body_builder = {};
      body.forEach((element) {
        body_builder[element.key] = element.value;
      });

      print(body_builder);

      String url = 'https://api-public.univ-lorraine.fr/demo';
      Map<String, String> headers = {
        'X-Gravitee-Api-Key': '97138730-a63f-4f14-a33e-4649c3a11791'
      };

      var response = await http.post(url, body: body_builder, headers: headers);

      // séparation des résultats du body
      var tmp = response.body.split('&');

      // mise en forme des résultats dans une map
      for (int i = 0; i < tmp.length; i++) {
        var element = tmp[i].split('=');
        results[element[0]] = element[1];
      }
    } else {}
  }
}
