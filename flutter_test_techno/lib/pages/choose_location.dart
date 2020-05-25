import 'package:flutter/material.dart';
import 'package:fluttertesttechno/services/world_time.dart';

class Chooselocation extends StatefulWidget {
  static final String id = 'choose_location_screen';

  @override
  _ChooselocationState createState() => _ChooselocationState();
}

class _ChooselocationState extends State<Chooselocation> {
  List<WorldTime> locations = [
    WorldTime(location: 'Paris', flag: 'france.png', url: '/Europe/Paris'),
    WorldTime(
        location: 'London', flag: 'angleterre.png', url: '/Europe/London'),
    WorldTime(location: 'Berlin', flag: 'allemagne.png', url: '/Europe/Berlin'),
    WorldTime(location: 'Rome', flag: 'italie.png', url: '/Europe/Rome'),
    WorldTime(location: 'Madrid', flag: 'espagne.png', url: '/Europe/Madrid'),
    WorldTime(
        location: 'Lisbonne', flag: 'portugal.png', url: '/Europe/Lisbon'),
    WorldTime(location: 'Dublin', flag: 'irlande.png', url: '/Europe/Dublin'),
    WorldTime(
        location: 'Bruxelles', flag: 'belgique.png', url: '/Europe/Brussels'),
    WorldTime(location: 'New York', flag: 'USA.png', url: '/America/New_York'),
  ];

  void getTime({int index}) async {
    WorldTime instance = locations[index];
    await instance.getTime();

    Navigator.pop(context, {
      'location': instance.location,
      'time': instance.time,
      'flag': instance.time,
      'isDaytime': instance.isDaytime,
      'url': instance.url,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue[900],
        title: Text('Choose location'),
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: locations.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: ListTile(
              onTap: () {
                getTime(index: index);
              },
              title: Text(locations[index].location),
              leading: CircleAvatar(
                backgroundImage: AssetImage('assets/${locations[index].flag}'),
              ),
            ),
          );
        },
      ),
    );
  }
}
