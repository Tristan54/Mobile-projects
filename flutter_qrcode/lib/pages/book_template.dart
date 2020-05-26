class BookTemplate {
  String titre, auteur, image;
  List<Bibliotheque> bibliotheques;

  BookTemplate({this.titre, this.auteur, this.image, this.bibliotheques});
}

class Bibliotheque {
  String nom;
  int disposibilite;

  Bibliotheque({this.nom, this.disposibilite});
}
