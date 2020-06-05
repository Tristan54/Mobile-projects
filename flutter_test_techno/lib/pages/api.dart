import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertesttechno/services/api_key.dart';
import 'package:fluttertesttechno/services/pram_helper.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sqlite_viewer/sqlite_viewer.dart';

class Api extends StatefulWidget {
  // identifiant de la classe pour les routes
  static final String id = 'api_get';

  // clé du Scaffold utilisé pour afficher une snackbar ou un dialog par exemple
  final GlobalKey<ScaffoldState> keyScaffold;

  const Api({
    Key key,
    this.keyScaffold,
  }) : super(key: key);

  @override
  _ApiState createState() => _ApiState();
}

class _ApiState extends State<Api> {
  // instance de la base de donnée
  ParamProvider db_param;

  // instance de la classe ApiGet pour se connecter à l'api https://api-public.univ-lorraine.fr/demo
  ApiKey apiKey;

  @override
  void initState() {
    super.initState();
    apiKey = ApiKey();
    db_param = ParamProvider();

    // ajouter les paramètres par défaut dans la BDD
    initParams();
  }

  // fermeture de la basse de données à la fermeture de la page / application
//  @override
//  void dispose() async {
//    await db_param.close();
//  }

  // liste des paramètres
  List<Param> params = [];
  int nb_param_courant = 1;

  // fonction pour ajouter un paramètre et l'insérer dans la BDD s'il n'existe pas encore
  Future<void> addParam({Param param}) async {
    Param tmp = await db_param.getParam(nb_param_courant);
    if (tmp == null) {
      await db_param.insert(param);
      nb_param_courant++;
    }
  }

  // ajoute les paramètres par défaut dans la BDD
  void initParams() async {
    // ouverture de la basse de données
    await db_param.open();

    await addParam(param: Param(key: 'premier', value: '1'));
    await addParam(param: Param(key: 'deuxieme', value: '2'));
    await addParam(param: Param(key: 'troisieme', value: '3'));

    await getParams();

    setState(() {});
  }

  // récupère tous les paramètres dans la BDD
  Future<void> getParams() async {
    bool fin = false;
    Param tmp;
    int i = 1;
    while (!fin) {
      tmp = await db_param.getParam(i);
      if (tmp != null) {
        if (!params.contains(tmp)) {
          params.add(tmp);
        }
        i++;
      } else {
        fin = true;
      }
    }
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
  // utilise le package rflutter_alert: ^1.0.3
  void alert({BuildContext context}) {
    final key = TextEditingController();
    final value = TextEditingController();
    final formKey = GlobalKey<FormState>();

    Alert(
      style: alertStyle,
      context: context,
      title: 'Ajouter un paramètre',
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
          onPressed: () async {
            if (formKey.currentState.validate()) {
              await addParam(param: Param(key: key.text, value: value.text));
              await getParams();
              setState(() {});
              Navigator.pop(context);
            }
          },
          width: 120,
        )
      ],
    ).show();
  }

  // permet d'afficher une snackbar
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
      child: Column(
        children: <Widget>[
          FlatButton(
            onPressed: () async {
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
                  'ajouter un paramètre',
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
              await apiKey.post(builder: params);

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
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlatButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => DatabaseList()));
                },
                color: Colors.red,
                textColor: Colors.white,
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'voir BDD',
                  style: TextStyle(fontSize: 22.0),
                ),
              ),
              SizedBox(
                width: 30.0,
              ),
              FlatButton(
                onPressed: () {
                  db_param.delete_table();
                },
                color: Colors.red,
                textColor: Colors.white,
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'delete BDD',
                  style: TextStyle(fontSize: 22.0),
                ),
              )
            ],
          ),
          Expanded(
            flex: 7,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: params.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                  child: ListTile(
                    onTap: () {
                      final bar = _snackSample(text: params[index].key);
                      widget.keyScaffold.currentState.showSnackBar(bar);
                    },
                    onLongPress: () {
                      final bar = _snackSample(text: params[index].value);
                      widget.keyScaffold.currentState.showSnackBar(bar);
                    },
                    title:
                        Text(params[index].key + ' : ' + params[index].value),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
