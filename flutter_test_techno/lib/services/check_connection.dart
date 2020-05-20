import 'package:connectivity/connectivity.dart';
import 'dart:io';

class CheckConnection {

  bool is_connect; // true if the device is connect to the internet, false if not

  Future<void> checkConnection() async {

    // check if the device is connect to a network
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      is_connect = true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      is_connect = true;
    }else{
      is_connect = false;
    }

    // check if the network with internet access
    if(is_connect){
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          is_connect = true;
        }else{
          is_connect = false;
        }
      } on SocketException catch (e) {
        is_connect = false;
      }
    }
  }

}