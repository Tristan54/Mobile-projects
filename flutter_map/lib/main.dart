import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:user_location/user_location.dart';

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
        options: MapOptions(center: nancy, zoom: 13.0, plugins: [
          UserLocationPlugin(),
        ]),
        mapController: mapController,
        layers: [
          TileLayerOptions(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c']),
          MarkerLayerOptions(
            markers: markers,
          ),
          if (location) userLocationOptions
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            location = true;
          });
        },
        child: Icon(Icons.my_location),
      ),
    );
  }
}
