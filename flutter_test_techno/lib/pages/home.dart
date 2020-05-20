import 'package:flutter/material.dart';
import 'package:fluttertesttechno/pages/choose_location.dart';

class Home extends StatefulWidget {
  static final String id = 'home_screen';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map data = {};

  @override
  Widget build(BuildContext context) {
    data = data.isNotEmpty ? data : ModalRoute.of(context).settings.arguments;

    String image = data['isDaytime'] ? 'day.jpg' : 'night.jpg';
    Color backgroudColor = data['isDaytime'] ? Colors.blue[200] : Colors.black;
    Color textColor = data['isDaytime'] ? Colors.black : Colors.white;

    return Scaffold(
      backgroundColor: backgroudColor,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage('assets/$image'),
            fit: BoxFit.cover,
          )),
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 200.0,
                ),
                FlatButton.icon(
                  onPressed: () async {
                    dynamic result =
                        await Navigator.pushNamed(context, Chooselocation.id);
                    setState(() {
                      data = {
                        'time': result['time'],
                        'location': result['location'],
                        'isDaytime': result['isDaytime'],
                        'flag': result['flag'],
                      };
                    });
                  },
                  icon: Icon(
                    Icons.add_location,
                    color: textColor,
                  ),
                  label: Text(
                    'Edit location',
                    style: TextStyle(color: textColor),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  data['location'],
                  style: TextStyle(
                      fontSize: 35.0, letterSpacing: 2.0, color: textColor),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  data['time'],
                  style: TextStyle(fontSize: 60.0, color: textColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
