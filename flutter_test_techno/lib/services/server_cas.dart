import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

import 'check_connection.dart';

class ServerCAS {
  String no_connection = 'pas de connexion';
  String wrong_user_ID = 'mauvais identifiants';
  String successful = 'connexion réussie';

  Future<Map<String, dynamic>> post_tgt(Map login) async {
    Map<String, dynamic> result = {};

    // instance de la classe CheckConnection, permet de vérifier si le device est connecté à internet
    CheckConnection checkConnection = CheckConnection();
    await checkConnection.checkConnection();

    // si le device est connecté à internet
    if (checkConnection.is_connect) {
      String body =
          'username=${login['username']}&password=${login['password']}';

      // on créé l'url
      String url = 'https://auth.univ-lorraine.fr/REST/tickets';

      // on fait l'appel avec le package http: ^0.12.1
      var response = await http.post(url, body: body);

      if (response.statusCode == 201) {
        // séparation du résultat du body
        var document = parse(response.body);
        var form = document.body.children[1];
        var tab = form.outerHtml.split(' ');
        var uri = tab[1].split('=');
        var res = uri[1].split('\"');

        result['code'] = successful;
        result['url'] = res[1];

        return result;
      } else {
        result['code'] = wrong_user_ID;
        return result;
      }
    } else {
      result['code'] = no_connection;

      return result;
    }
  }

  Future<String> post_st(String url) async {
    // instance de la classe CheckConnection, permet de vérifie si le device est connecté à internet
    CheckConnection checkConnection = CheckConnection();
    await checkConnection.checkConnection();

    // si le device est connecté à internet
    if (checkConnection.is_connect) {
      String body =
          'service=https://mail.etu.univ-lorraine.fr/zimbra/preauth/preauthUL_ETU.jsp';

      // on fait l'appel avec le package http: ^0.12.1
      var response = await http.post(
        url,
        body: body,
      );

      return response.body;
    } else {
      return no_connection;
    }
  }
}
