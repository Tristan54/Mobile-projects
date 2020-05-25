import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertesttechno/pages/app.dart';
import 'package:fluttertesttechno/services/world_time.dart';

class Loading extends StatefulWidget {
  static final String id = 'loading_screen';

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  void setupWorldTime() async {
    WorldTime instance =
        WorldTime(location: 'Paris', flag: 'fr_flag.png', url: '/Europe/Paris');
    await instance.getTime();

    Navigator.pushReplacementNamed(context, App.id, arguments: {
      'index': 0,
      'location': instance.location,
      'time': instance.time,
      'flag': instance.time,
      'isDaytime': instance.isDaytime,
      'url': instance.url,
    });
  }

  @override
  void initState() {
    super.initState();
    setupWorldTime();
  }

  @override
  Widget build(BuildContext context) {
    return
//      Scaffold(
//      backgroundColor: Colors.blue[900],
//      body:
        Container(
      decoration: BoxDecoration(
        color: Colors.blue[900],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 50.0),
        child: Center(
          child: SpinKitThreeBounce(
            color: Colors.white,
            size: 50.0,
          ),
        ),
      ),
    );
    //);
  }
}
