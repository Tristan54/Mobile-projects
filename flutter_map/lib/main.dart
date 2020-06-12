import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:latlong/latlong.dart';
import 'package:map_launcher/map_launcher.dart' as launcher;
import 'package:url_launcher/url_launcher.dart';
import 'package:user_location/user_location.dart';

import 'scale_layer_plugin_option.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Map(title: 'Flutter Map'),
    );
  }
}

class Map extends StatefulWidget {
  Map({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  LatLng nancy = LatLng(48.6872, 6.1724);
  LatLng ul = LatLng(48.6842566, 6.1936793);
  LatLng idmc = LatLng(48.6974421, 6.1719352);

  OpenStreetMap({LatLng local}) async {
    double latitude = local.latitude;
    double longitude = local.longitude;
    String url = 'https://www.openstreetmap.org/#map=16/$latitude/$longitude';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  openMapsSheet(context) async {
    try {
      final title = "Nancy";
      final description = "Nancy ville";
      final coords = launcher.Coords(48.6842566, 6.1936793);
      final availableMaps = await launcher.MapLauncher.installedMaps;

      print(availableMaps);

      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Container(
                child: Wrap(
                  children: <Widget>[
                    for (var map in availableMaps)
                      ListTile(
                        onTap: () => map.showMarker(
                          coords: coords,
                          title: title,
                          description: description,
                        ),
                        title: Text(map.mapName),
                        leading: Image(
                          image: map.icon,
                          height: 30.0,
                          width: 30.0,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

  MapController mapController = MapController();
  UserLocationOptions userLocationOptions;
  List<Marker> markers = [
    Marker(
      width: 80.0,
      height: 80.0,
      point: LatLng(48.6842566, 6.1936793),
      builder: (ctx) => Container(
        child: Icon(
          Icons.location_on,
          color: Colors.red,
        ),
      ),
    ),
    Marker(
      width: 80.0,
      height: 80.0,
      point: LatLng(48.6974421, 6.1719352),
      builder: (ctx) => Container(
        child: Icon(
          Icons.location_on,
          color: Colors.red,
        ),
      ),
    ),
  ];

  bool location = false;
  bool _dialVisible = true;

  @override
  Widget build(BuildContext context) {
    userLocationOptions = UserLocationOptions(
      context: context,
      mapController: mapController,
      markers: markers,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FlutterMap(
        options: MapOptions(center: nancy, zoom: 13, plugins: [
          UserLocationPlugin(),
          ScaleLayerPlugin(),
        ]),
        mapController: mapController,
        layers: [
          TileLayerOptions(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c']),
          MarkerLayerOptions(
            markers: markers,
          ),
          ScaleLayerPluginOption(
            lineColor: Colors.blue,
            lineWidth: 2,
            textStyle: TextStyle(color: Colors.blue, fontSize: 12),
            padding: EdgeInsets.all(10),
          ),
          if (location) userLocationOptions
        ],
      ),
      floatingActionButton: SpeedDial(
        // both default to 16
        marginRight: 18,
        marginBottom: 20,
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 22.0),
        // this is ignored if animatedIcon is non null
        // child: Icon(Icons.add),
        visible: _dialVisible,
        // If true user is forced to close dial manually
        // by tapping main button and overlay is not rendered.
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        onOpen: () => print('OPENING DIAL'),
        onClose: () => print('DIAL CLOSED'),
        tooltip: 'menu',
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 8.0,
        shape: CircleBorder(),
        children: [
          SpeedDialChild(
            child: Icon(Icons.my_location),
            backgroundColor: Colors.red,
            label: 'localisation',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () async {
              setState(() {
                location = true;
              });
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.near_me),
            backgroundColor: Colors.blue,
            label: 'Google map',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () => openMapsSheet(context),
          ),
          SpeedDialChild(
            child: Icon(Icons.map),
            backgroundColor: Colors.green,
            label: 'Open Street Pap',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () => OpenStreetMap(local: ul),
          ),
        ],
      ),
    );
  }
}
