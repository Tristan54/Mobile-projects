import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  return runApp(
    MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.red,
        appBar: AppBar(
          title: Text('Dicee'),
          backgroundColor: Colors.red,
        ),
        body: DicePage(),
      ),
    ),
  );
}

class DicePage extends StatefulWidget {
  @override
  _DicePageState createState() => _DicePageState();
}

class _DicePageState extends State<DicePage> {
  int _leftDiceNumber = 1;
  int _rightDiceNumber = 1;

  void _randomDice() {
    setState(() {
      _leftDiceNumber = Random().nextInt(6) + 1;
      _rightDiceNumber = Random().nextInt(6) + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children : <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: FlatButton(
                  onPressed: (){
                    setState(() {
                      _leftDiceNumber = Random().nextInt(6) + 1;
                    });
                  },
                  child: Image(
                    image: AssetImage('images/dice$_leftDiceNumber.png'),
                  ),
                ),
              ),
              Expanded(
                child: FlatButton(
                  onPressed: (){
                    setState(() {
                      _rightDiceNumber = Random().nextInt(6) + 1;
                    });
                  },
                  child: Image(
                    image: AssetImage('images/dice$_rightDiceNumber.png'),
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              child: Text('Random'),
              onPressed: _randomDice,
              color: Colors.red[300],
            ),
          ),
        ],
      ),
    );
  }
}

