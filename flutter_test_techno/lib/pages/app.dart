import 'package:flutter/material.dart';
import 'package:fluttertesttechno/pages/api_get.dart';
import 'package:fluttertesttechno/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App extends StatefulWidget {
  static final id = 'App';

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> with SingleTickerProviderStateMixin {
  bool isMenu = true;
  bool isDark = true;
  double screenWidth, screenHeight;
  final Duration duration = const Duration(milliseconds: 300);
  AnimationController _controller;
  Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: duration);
    _scaleAnimation = Tween<double>(begin: 1, end: 1).animate(_controller);

    // initialize the preference
    _preferences();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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

    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;

    // change color for parameters
    Color backgroundColor = isDark ? Colors.blueGrey : Colors.grey[300];

    // get preferences before building the app
    _getPreferences();

    return Stack(
      children: <Widget>[
        // build menu
        menu(context: context, backgroundColor: backgroundColor),

        // build app
        AnimatedPositioned(
          duration: duration,
          top: 0,
          bottom: 0,
          left: isMenu ? 0 : 0.6 * screenWidth,
          right: isMenu ? 0 : -0.4 * screenWidth,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Material(
              animationDuration: const Duration(milliseconds: 3000),
              borderRadius: BorderRadius.all(Radius.circular(40.0)),
              elevation: 8,
              child: DefaultTabController(
                length: tabs.length,
                initialIndex: index,
                child: Scaffold(
                  key: _key,
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    title: Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.menu),
                          onPressed: () {
                            setState(() {
                              isMenu
                                  ? _controller.forward()
                                  : _controller.reverse();
                              isMenu = !isMenu;
                            });
                          },
                        ),
                        Text('API connect')
                      ],
                    ),
                    bottom: TabBar(
                      isScrollable: false,
                      tabs: tabs,
                    ),
                  ),
                  body: TabBarView(
                    children: <Widget>[
                      Home(
                        p_data: data,
                      ),
                      ApiGet(
                        keyScaffold: _key,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget menu({BuildContext context, Color backgroundColor}) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Align(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(10.0, 6.0, 0, 15.0),
                child: Text(
                  'Paramètres',
                  textAlign: TextAlign.left,
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
