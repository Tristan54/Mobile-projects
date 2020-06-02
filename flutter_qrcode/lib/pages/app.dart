import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:flutterqrcode/pages/book.dart';
import 'package:flutterqrcode/services/get_book.dart';
import 'package:url_launcher/url_launcher.dart';

class App extends StatefulWidget {
  // id de la page pour définir la route
  static final String id = 'app';

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  // résultat issu des scannerd du code barre ou du qrcode
  String result = '';

  // Instance de la classe getBook qui permet de faire les appels aux api
  GetBook getBook = GetBook();

  // méthode asynchrone  pour scanner un code barre et afficher le résultat
  Future<void> scanBarcodeNormal() async {
    // résultat
    String barcodeScanRes;

    // utilise le package flutter_barcode_scanner: ^1.0.1 pour scanner un code barre
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // Si le scanner et fermé, on annule l'opération pour ne pas changer des élements qui ne se trouvent plus dans l'arbre des Widget
    if (!mounted) return;

    // on met à jour le résultat sur l'affichage
    setState(() {
      result = barcodeScanRes;
    });

    // on récupère les données via l'api et le numéro isbn
    await getBook.getBook(isbn: result);

    // on ouvre une nouvelle fenêtre au dessus de la courante
    Navigator.pushNamed(context, Book.id, arguments: {
      'book': getBook.bookTemplate,
    });
  }

  // méthode asynchrone  pour scanner un qrcode et afficher le résultat
  Future<void> scanQR() async {
    // résultat
    String barcodeScanRes;

    // utilise le package flutter_barcode_scanner: ^1.0.1 pour scanner un qrcode
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // Si le scanner et fermé, on annule l'opération pour ne pas changer des élements qui ne se trouvent plus dans l'arbre des Widget
    if (!mounted) return;

    // on met à jour le résultat sur l'affichage
    setState(() {
      result = barcodeScanRes;
    });

    // on utilise le package url_launcher: ^5.4.10 pour ouvrir un navigateur avec le résultat
    if (await canLaunch(result)) {
      await launch(result);
    } else {
      throw 'Could not launch $result';
    }
  }

  // méthode qui permet d'ouvrir un mailer avec différentes options
  // on utilise le package flutter_mailer: ^0.5.0
  final MailOptions mailOptions = MailOptions(
    body: 'a long body for the email <br> with a subset of HTML',
    subject: 'the Email Subject',
    recipients: ['example@example.com'],
    isHTML: true,
    bccRecipients: ['other@example.com'],
    ccRecipients: ['third@example.com'],
    attachments: [''],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scanner'),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  onPressed: () {
                    scanBarcodeNormal();
                  }, //scanBarcodeNormal(),
                  child: Text("Start barcode scan"),
                ),
                SizedBox(width: 30.0),
                RaisedButton(
                  onPressed: () => scanQR(),
                  child: Text("Start QR scan"),
                ),
              ],
            ),
            Text('Scan result : $result', style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 8.0,
        onPressed: () async {
          await FlutterMailer.send(mailOptions);
        },
        child: Icon(Icons.mail),
      ),
    );
  }
}

// V2

//_camState
//? Center(
//child: SizedBox(
//height: 1000,
//width: 500,
//child: QRScannerCamera(
//onError: (context, error) => Text(
//error.toString(),
//style: TextStyle(color: Colors.red),
//),
//qrCodeCallback: (code) {
//_qrCallback(code);
//},
//),
//),
//)
//: Center(
//child: Text(_qrInfo),
//),

//String _qrInfo = 'Scan a QR/Bar code';
//bool _camState = false;
//
//@override
//void initState() {
//  super.initState();
//  _scanCode();
//}
//
//_qrCallback(String code) {
//  setState(() {
//    _camState = false;
//    _qrInfo = code;
//  });
//}
//
//_scanCode() {
//  setState(() {
//    _camState = true;
//  });
//}
