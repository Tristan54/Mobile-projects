import 'dart:convert';

import 'package:fluttertesttechno/services/check_connection.dart';
import 'package:fluttertesttechno/services/pram_helper.dart';
import 'package:http/http.dart' as http;

import 'cache_manager_get.dart';

class ApiKey {
  List<Param> params;
  Map results = {};

  Future<void> get({List params}) async {
    // instance de la classe CheckConnection, permet de vérifie si le device est connecté à internet
    CheckConnection checkConnection = CheckConnection();
    await checkConnection.checkConnection();

    // si le device est connecté à internet
    if (checkConnection.is_connect) {
      // on concaténe les paramètres
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

      // on créer la requêtes avec un header
      String url = 'https://api-public.univ-lorraine.fr/demo?$build_params';
      Map<String, String> headers = {
        'X-Gravitee-Api-Key': '97138730-a63f-4f14-a33e-4649c3a11791'
      };

      // on regarde s'il existe un fichier en cache, sinon on fait un appel
      // on utilise le package flutter_cache_manager: ^1.2.2 et la classe cache_manager_get.dart
      var file = await MyCacheManagerGet().getSingleFile(url, headers: headers);
      if (file != null && await file.exists()) {
        var response = await file.readAsString();

        // on transforme le json en objet dart
        Map data = jsonDecode(response.toString());
        results = data['query_params'];
      }
    }
  }

  Future<void> post({List<Param> builder}) async {
    // instance de la classe CheckConnection, permet de vérifie si le device est connecté à internet
    CheckConnection checkConnection = CheckConnection();
    await checkConnection.checkConnection();

    // si le device est connecté à internet
    if (checkConnection.is_connect) {
      // on créer le body de la requête
      Map<String, String> body = {};
      builder.forEach((element) {
        body[element.key] = element.value;
      });

      // on créer l'url et le header
      String url = 'https://api-public.univ-lorraine.fr/demo';
      Map<String, String> headers = {
        'X-Gravitee-Api-Key': '97138730-a63f-4f14-a33e-4649c3a11791'
      };

      // on fait l'appel avec le package http: ^0.12.1
      var response = await http.post(url, body: body, headers: headers);

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
