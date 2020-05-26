import 'package:flutter/material.dart';
import 'package:flutterqrcode/pages/book_template.dart';

// cette classe permet d'afficher le contenu des données récupérées via l'api
class Book extends StatelessWidget {
  static final String id = 'book';

  @override
  Widget build(BuildContext context) {
    // on récupére les données transmises par le routage
    Map map = ModalRoute.of(context).settings.arguments;

    BookTemplate book = map['book'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Book details'),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: Column(
            children: <Widget>[
              Text(
                book.titre,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              Text(
                book.auteur,
                style: TextStyle(fontSize: 15.0),
              ),
              Image.network(book.image != null
                  ? book.image
                  : 'https://img.over-blog-kiwi.com/0/96/40/14/20180613/ob_b18dc3_vide.jpg'),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: book.bibliotheques.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 5.0),
                        child: Column(
                          children: <Widget>[
                            Text(
                              book.bibliotheques[index].nom,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 15.0),
                            ),
                            Text(
                                'disponible : ${book.bibliotheques[index].disposibilite}'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
