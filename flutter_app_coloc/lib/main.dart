import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() => runApp(home());

class home extends StatefulWidget {
  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool morning = false;
  bool night = false;

  void proposeFastFood(BuildContext context_snackBar) {
    final snackBar = SnackBar(content: Text('On commande aujourd\'hui ?'));
    Scaffold.of(context_snackBar).showSnackBar(snackBar);
  }

  // Notification
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  var initializationSettingsAndroid;
  var initializationSettingsIOS;
  var initializationSettings;

  void _showNotification() async {
    if (morning && night) {
      await _demoNotification(time: Time(7, 0, 0));
      await _demoNotification(time: Time(13, 0, 0));
    } else if (morning) {
      await _demoNotification(time: Time(7, 0, 0));
    } else if (night) {
      await _demoNotification(time: Time(13, 0, 0));
    }
  }

  Future<void> _demoNotification({Time time}) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'channel_ID', 'channel name', 'channel description',
        importance: Importance.Max,
        priority: Priority.High,
        ticker: 'test ticker');

    var iOSChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSChannelSpecifics);

    await flutterLocalNotificationsPlugin.showDailyAtTime(0, 'Réveille toi !!',
        'Il faut que tu sorte la viande', time, platformChannelSpecifics,
        payload: 'test payload');
//    await flutterLocalNotificationsPlugin.show(0, 'Réveille toi !!',
//        'Il faut que tu sorte la viande', platformChannelSpecifics,
//        payload: 'test payload');
  }

  @override
  void initState() {
    super.initState();
    initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    initializationSettingsIOS = new IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String playload) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: Text(title),
              content: Text(body),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text('OK'),
                  onPressed: () async {
                    Navigator.of(context, rootNavigator: true).pop();
                    await Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new home()));
                  },
                )
              ],
            ));
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('Notification payload: $payload');
    }
    await Navigator.push(
        context, new MaterialPageRoute(builder: (context) => new home()));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.indigo,
        body: SafeArea(
          child: Container(
            child: Center(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 160.0, 0.0, 20.0),
                    child: Text(
                      "Il faut sortir la viande !",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 30.0,
                        fontFamily: 'Lemonada',
                      ),
                    ),
                  ),
                  const Divider(
                    color: Colors.grey,
                    height: 2.0,
                    indent: 30.0,
                    endIndent: 30.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                            flex: 2,
                            child: SizedBox(
                              width: 20.0,
                            )),
                        Expanded(
                          flex: 1,
                          child: Switch.adaptive(
                            value: morning,
                            onChanged: (value) {
                              setState(() {
                                morning = value;
                                _showNotification();
                              });
                            },
                            activeColor: Colors.grey[600],
                            activeTrackColor: Colors.grey[400],
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text("Matin",
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 20.0,
                                fontFamily: 'Lemonada',
                              )),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                          flex: 2,
                          child: SizedBox(
                            width: 20.0,
                          )),
                      Expanded(
                        flex: 1,
                        child: Switch.adaptive(
                          value: night,
                          onChanged: (value) {
                            setState(() {
                              night = value;
                              _showNotification();
                            });
                          },
                          activeColor: Colors.grey[600],
                          activeTrackColor: Colors.grey[400],
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text("Soir",
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 20.0,
                              fontFamily: 'Lemonada',
                            )),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: FloatingActionButton(
            backgroundColor: Colors.grey[400],
            onPressed: () {
              _scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text(
                  'On commande aujourd\'hui ?',
                  style: TextStyle(fontSize: 20.0),
                ),
                duration: Duration(seconds: 3),
                backgroundColor: Colors.grey[800],
              ));
            },
            child: IconButton(
              icon: Icon(Icons.fastfood),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
