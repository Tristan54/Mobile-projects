import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';

void main() => runApp(XylophoneApp());

class XylophoneApp extends StatelessWidget {
  void _playSong(int _number) {
    final player = AudioCache();
    player.play('note$_number.wav');
  }

  Expanded buildKey({Color color, int number}) {
    return Expanded(
      child: FlatButton(
        color: color,
        onPressed: () {
          _playSong(number);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                buildKey(color: Colors.red, number: 1),
                buildKey(color: Colors.orange, number: 2),
                buildKey(color: Colors.yellow, number: 3),
                buildKey(color: Colors.greenAccent, number: 4),
                buildKey(color: Colors.green, number: 5),
                buildKey(color: Colors.blue, number: 6),
                buildKey(color: Colors.deepPurple, number: 7),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
