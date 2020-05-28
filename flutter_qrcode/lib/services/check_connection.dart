import 'dart:io';

import 'package:connectivity/connectivity.dart';

class CheckConnection {
  bool is_connect; // true si le device est connecté à internet, false sinon

  Future<void> checkConnection() async {
    // vérification qui utilise le package connectivity: ^0.4.8+6
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      is_connect = true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      is_connect = true;
    } else {
      is_connect = false;
    }

    // une fois la connexion vérifie
    // on regarde si le device à bien accès à internet
    if (is_connect) {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          is_connect = true;
        } else {
          is_connect = false;
        }
      } on SocketException catch (e) {
        is_connect = false;
      }
    }
  }
}
