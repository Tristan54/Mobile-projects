import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dice.dart';

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
  List<Dice> dices = [
    Dice(visible: true, image: 1),
    Dice(visible: true, image: 1),
    Dice(visible: false, image: 1),
    Dice(visible: false, image: 1),
    Dice(visible: false, image: 1),
    Dice(visible: false, image: 1),
  ];

  int diceNumber = 2;

  void addVisible(){
    dices[diceNumber-1].visible = true;
  }

  void removeVisible(){
    dices[diceNumber].visible = false;
  }

  void randomDices(){
    setState(() {
      for(int i = 0; i < diceNumber; i++){
        dices[i].image = Random().nextInt(6) + 1;
      }
    });
  }

  void randomDice(int number){
    setState(() {
      dices[number].image = Random().nextInt(6) + 1;

    });
  }

  Expanded dice({int number}) {
    int imageNumber = dices[number].image;
    return Expanded(
      child: Visibility(
        visible: dices[number].visible,
        child: FlatButton(
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          onPressed: () {
            setState(() {
              randomDice(number);
            });
          },
          child: Image(
            image: AssetImage('images/dice$imageNumber.png'),
          ),
        ),
      ),
    );
  }

  Column addDices(){
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[dice(number: 0),dice(number: 1),],
        ),
        Row(
          children: <Widget>[dice(number: 2),dice(number: 3),],
        ),
        Row(
          children: <Widget>[dice(number: 4),dice(number: 5),],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.remove, size: 30.0,),
                color: Colors.white,
                onPressed: (){
                  setState(() {
                    if(diceNumber > 1){
                      diceNumber--;
                      removeVisible();
                    }
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.add, size: 30.0,),
                color: Colors.white,
                onPressed: (){
                  setState(() {
                    if(diceNumber < 6){
                      diceNumber++;
                      addVisible();
                    }
                  });
                },
              ),
            ],
          ),

          addDices(),

          Container(
            margin: EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              child: Text(
                'Random',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: randomDices,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
