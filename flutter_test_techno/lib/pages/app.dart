import 'package:flutter/material.dart';
import 'package:fluttertesttechno/pages/api.dart';
import 'package:fluttertesttechno/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App extends StatefulWidget {
  static final id = 'App';

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> with SingleTickerProviderStateMixin {
  bool isDark = true;

  @override
  void initState() {
    super.initState();
    // initialize the preference
    _preferences();
  }

  final tabs = [
    Tab(icon: Icon(Icons.home)),
    Tab(icon: Icon(Icons.vpn_key)),
  ];

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context) == null
        ? {'index': 1}
        : ModalRoute.of(context).settings.arguments;
    int index = data['index'];

    // on a besoin de l'identifiant du Scaffold pour afficher une snackBar
    GlobalKey<ScaffoldState> _key = GlobalKey();

    // change color for parameters
    Color backgroundColor = isDark ? Colors.blueGrey : Colors.grey[300];

    // get preferences before building the app
    _getPreferences();

    // build app
    return Scaffold(
      drawerEdgeDragWidth: 0,
      appBar: AppBar(
        title: Text('API connect'),
      ),
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
          ),
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            children: <Widget>[
              DrawerHeader(
                child: Text(
                  'Paramètres',
                  style: TextStyle(
                    fontSize: 30.0,
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      'Thème clair',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                  Switch.adaptive(
                      activeColor: Colors.white,
                      value: isDark,
                      onChanged: (value) {
                        setState(() {
                          isDark = value;
                          _setPreferences();
                        });
                      }),
                ],
              )
            ],
          ),
        ),
      ),
      body: DefaultTabController(
        length: tabs.length,
        initialIndex: index,
        child: Scaffold(
          key: _key,
          appBar: AppBar(
            title: TabBar(
              isScrollable: false,
              tabs: tabs,
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              Home(
                p_data: data,
              ),
              Api(
                keyScaffold: _key,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _preferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey('theme dark')) {
      prefs.setBool('theme dark', isDark);
    }
  }

  _getPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isDark = prefs.getBool('thme dark') ?? true;
  }

  _setPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('thme dark', isDark);
  }
}
