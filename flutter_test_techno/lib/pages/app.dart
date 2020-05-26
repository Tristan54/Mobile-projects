import 'package:flutter/material.dart';
import 'package:fluttertesttechno/pages/api.dart';
import 'package:fluttertesttechno/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App extends StatefulWidget {
  // identifiant de la classe pour les routes
  static final id = 'App';

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> with SingleTickerProviderStateMixin {
  // préférence de l'application
  bool isDark = true;

  @override
  void initState() {
    super.initState();
    // initialise les préférences
    _preferences();
  }

  // tableau qui contient les icônes de la tabBar
  final tabs = [
    Tab(icon: Icon(Icons.home)),
    Tab(icon: Icon(Icons.vpn_key)),
  ];

  @override
  Widget build(BuildContext context) {
    // on récupère les données transmise avec la route
    Map data = ModalRoute.of(context) == null
        ? {'index': 1}
        : ModalRoute.of(context).settings.arguments;
    // l'index permet d'ouvrir l'application directement avec l'onglet que l'on souhaite
    int index = data['index'];

    // on a besoin de l'identifiant du Scaffold pour afficher une snackBar
    GlobalKey<ScaffoldState> _key = GlobalKey();

    // change la couleur du menu en fonction des préférences
    Color backgroundColor = isDark ? Colors.blueGrey : Colors.grey[300];

    // on récupère les préférences avant de build la vue
    _getPreferences();

    // build app
    return Scaffold(
      drawerEdgeDragWidth: 0,
      appBar: AppBar(
        title: Text('API connect'),
      ),
      // un Drawer permet de faire un menu
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
                      'Thème foncé',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                  // Switch.adaptive va prendre un style différent selon la plateforme
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
            // on appel les autres classes en fonction de l'onglet sélectionné
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

  // initialise les préférences
  // utilise le plugin shared_preferences: ^0.5.7+3
  _preferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // si la préférence n'existe pas on le créer
    if (!prefs.containsKey('theme dark')) {
      prefs.setBool('theme dark', isDark);
    }
  }

  // permet de récupérer les préférences
  _getPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isDark = prefs.getBool('theme dark') ?? true;
  }

  // permet de modifier les préférences
  _setPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('theme dark', isDark);
  }
}
