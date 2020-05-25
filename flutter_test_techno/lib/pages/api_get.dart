import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertesttechno/services/api_key.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ApiGet extends StatefulWidget {
  static final String id = 'api_get';

  final GlobalKey<ScaffoldState> keyScaffold;

  const ApiGet({
    Key key,
    this.keyScaffold,
  }) : super(key: key);

  @override
  _ApiGetState createState() => _ApiGetState();
}

class _ApiGetState extends State<ApiGet> {
  // instance de la classe ApiGet pour se connecter à l'api https://api-public.univ-lorraine.fr/demo
  ApiKey apiKey = ApiKey();

  // liste des paramètres
  List<Param> params = [
    Param(key: 'premier', value: '1'),
    Param(key: 'deuxieme', value: '2'),
    Param(key: 'troisieme', value: '3'),
  ];

  // fonction pour ajouter un paramètre
  void addParams({String key, String value}) {
    params.add(Param(key: key, value: value));
  }

  // Style graphique du pop-up
  var alertStyle = AlertStyle(
    animationType: AnimationType.fromTop,
    isCloseButton: false,
    isOverlayTapDismiss: false,
    descStyle: TextStyle(fontWeight: FontWeight.bold),
    animationDuration: Duration(milliseconds: 400),
    alertBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(0.0),
      side: BorderSide(
        color: Colors.grey,
      ),
    ),
    titleStyle: TextStyle(
      color: Colors.blue,
    ),
  );

  // pop-up qui ajoute des paramètres
  void alert({BuildContext context}) {
    final key = TextEditingController();
    final value = TextEditingController();

    final formKey = GlobalKey<FormState>();

    Alert(
      style: alertStyle,
      context: context,
      title: 'Ajouter un params',
      content: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              validator: (value) => value.isEmpty ? 'Entrez une valeur' : null,
              controller: key,
              decoration:
                  InputDecoration(icon: Icon(Icons.vpn_key), labelText: 'key'),
            ),
            TextFormField(
              validator: (value) => value.isEmpty ? 'Entrez une valeur' : null,
              controller: value,
              decoration: InputDecoration(
                icon: Icon(Icons.subject),
                labelText: 'value',
              ),
            ),
          ],
        ),
      ),
      buttons: [
        DialogButton(
          child: Text(
            'ajouter',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          color: Colors.green,
          onPressed: () {
            setState(() {
              if (formKey.currentState.validate()) {
                addParams(key: key.text, value: value.text);
                Navigator.pop(context);
              }
            });
          },
          width: 120,
        )
      ],
    ).show();
  }

  Widget _snackSample({String text}) => SnackBar(
        content: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.grey[800],
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: params.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                  child: ListTile(
                    onTap: () {
                      print(params[index].key);
                    },
                    title:
                        Text(params[index].key + ' : ' + params[index].value),
                  ),
                );
              },
            ),
            FlatButton(
              onPressed: () {
                alert(context: context);
              },
              color: Colors.green,
              textColor: Colors.white,
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.add),
                  Text(
                    'ajouter params',
                    style: TextStyle(fontSize: 22.0),
                  ),
                ],
              ),
            ),
            FlatButton(
              onPressed: () async {
                await apiKey.get(params: params);

                var text = new StringBuffer();
                apiKey.results.forEach((key, value) {
                  text.write(key + ' : ' + value + '\n');
                });
                final bar = _snackSample(text: text.toString());
                widget.keyScaffold.currentState.showSnackBar(bar);
              },
              color: Colors.blue,
              textColor: Colors.white,
              padding: EdgeInsets.all(8.0),
              child: Text(
                'envoyer en get',
                style: TextStyle(fontSize: 22.0),
              ),
            ),
            FlatButton(
              onPressed: () async {
                await apiKey.post(body: params);

                var text = new StringBuffer();
                apiKey.results.forEach((key, value) {
                  text.write(key + ' : ' + value + '\n');
                });
                final bar = _snackSample(text: text.toString());
                widget.keyScaffold.currentState.showSnackBar(bar);
              },
              color: Colors.blue,
              textColor: Colors.white,
              padding: EdgeInsets.all(8.0),
              child: Text(
                'envoyer en post',
                style: TextStyle(fontSize: 22.0),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Param {
  String key;
  String value;

  Param({this.key, this.value});
}
