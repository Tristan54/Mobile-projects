import 'dart:convert';

import 'package:flutterqrcode/pages/book_template.dart';
import 'package:flutterqrcode/services/check_connection.dart';
import 'package:http/http.dart' as http;

class GetBook {
  // instance de la classe bookTemplate qui va nous permettre de stocker le résultat
  BookTemplate bookTemplate;

  // méthode pour faire la réquête à l'api
  Future<void> getBook({String isbn}) async {
    // on regarde si on est connecté à internet
    CheckConnection checkConnection = CheckConnection();
    await checkConnection.checkConnection();

    if (checkConnection.is_connect) {
      // création de la requête avec le plugin http: ^0.12.1
      http.Response response = await http.get(
          'https://ws-mobiles.univ-lorraine.fr/biblio/recherche?isbn=$isbn');

      // on transforme les données json en objet dart
      Map data = jsonDecode(response.body);

      // on converti la map en objet bookTemplate
      String titre = data['titre'];
      String auteur = data['auteurs'];
      String image = data['urlImage'];
      List<Bibliotheque> bibliotheques = List();

      List tmp = data['listeBibliotheques'];
      for (int i = 0; i < tmp.length; i++) {
        Map bibliotheque = tmp[i];
        bibliotheques.add(Bibliotheque(
            nom: bibliotheque['nom'], disposibilite: bibliotheque['dispo']));
      }

      bookTemplate = BookTemplate(
          titre: titre,
          auteur: auteur,
          image: image,
          bibliotheques: bibliotheques);
      bookTemplate.toString();
    } else {}
  }
}
