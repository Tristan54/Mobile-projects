import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertesttechno/services/server_cas.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthCAS extends StatefulWidget {
  // identifiant de la classe pour les routes
  static final String id = 'auth_cas';

  // clé du Scaffold utilisé pour afficher une snackbar ou un dialog par exemple
  final GlobalKey<ScaffoldState> keyScaffold;

  const AuthCAS({
    Key key,
    this.keyScaffold,
  }) : super(key: key);

  @override
  _AuthCASState createState() => _AuthCASState();
}

class _AuthCASState extends State<AuthCAS> {
  ServerCAS cas = ServerCAS();

  final username = TextEditingController();
  final password = TextEditingController();
  final formKey = GlobalKey<FormState>();

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
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 20.0, 0, 0),
            child: Text(
              'Authentification CAS',
              style: TextStyle(color: Colors.black, fontSize: 30.0),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 25.0),
            child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    validator: (value) =>
                        value.isEmpty ? 'Entrez une valeur' : null,
                    controller: username,
                    decoration: InputDecoration(
                        icon: Icon(Icons.account_circle),
                        labelText: 'identifiant'),
                  ),
                  TextFormField(
                    obscureText: true,
                    validator: (value) =>
                        value.isEmpty ? 'Entrez une valeur' : null,
                    controller: password,
                    decoration: InputDecoration(
                      icon: Icon(Icons.vpn_key),
                      labelText: 'mot de passe',
                    ),
                  ),
                ],
              ),
            ),
          ),
          FlatButton(
            onPressed: () async {
              if (formKey.currentState.validate()) {
                Map login = {
                  'username': username.text,
                  'password': password.text,
                };
                Map result = await cas.post_tgt(login);

                final bar = _snackSample(text: result['code']);
                widget.keyScaffold.currentState.showSnackBar(bar);

                if (result['code'] == 'connexion réussie') {
                  String res = await cas.post_st(result['url']);
                  print(res);
                  String uri =
                      'https://mail.etu.univ-lorraine.fr/zimbra/preauth/preauthUL_ETU.jsp?ticket=$res';

                  if (await canLaunch(uri)) {
                    await launch(uri);
                  } else {
                    throw 'Could not launch $uri';
                  }
                }
              }
            },
            padding: EdgeInsets.all(8.0),
            color: Colors.blue,
            textColor: Colors.white,
            child: Text(
              'se connecter',
              style: TextStyle(fontSize: 22.0),
            ),
          )
        ],
      ),
    );
  }
}
