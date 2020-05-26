import 'dart:io';

import 'package:connectivity/connectivity.dart';

// cette classe permet de vérifie si le device a accès à internet
class CheckConnection {
  bool is_connect; // vrai si le device est connecté, false sinon

  Future<void> checkConnection() async {
    // regarde si le device est connecté à un réseau (wi-fi ou mobile)
    // on utilise le plugin connectivity: ^0.4.8+6
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      is_connect = true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      is_connect = true;
    } else {
      is_connect = false;
    }

    // regarde si le device a accès à internet
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
