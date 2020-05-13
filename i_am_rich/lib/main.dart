import 'package:flutter/material.dart';

// La fonction main est le point de commencement de toute l'application
void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('I AM RICH'),
          backgroundColor: Colors.brown[500],
        ),
        backgroundColor: Colors.brown[200],
        body: Center(
          child: Image(
            image: AssetImage('images/diamond.png'),
          ),
        ),
      ),
    ),
  );
}
