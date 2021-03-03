import 'package:academia/Components/alerteDialogue.dart';
import 'package:academia/Components/transitionLeft.dart';
import 'package:academia/layout/read_pdf.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/rendering.dart';

//style notion card
class NotionCard {
  String textnotion;

  NotionCard(String textnotion) {
    this.textnotion = textnotion;
  }
  List<Card> getNotionCard() {
    return textnotion != null
        ? textnotion
            .split(';')
            .map(
              (String text) => Card(
                  margin: EdgeInsets.only(
                      left: 0, right: 1.6, bottom: 1.6, top: 1.6),
                  color: Color(0xff5F8463),
                  elevation: 2.1,
                  child: Container(
                    color: Colors.grey[300],
                    margin: EdgeInsets.only(left: 1.6, right: 1.6),
                    padding: EdgeInsets.all(1.2),
                    child: Text(
                      text,
                      style: TextStyle(fontSize: 11),
                    ),
                  )),
            ) // put the text inside a widget
            .toList()
        : [
            Card(
                margin:
                    EdgeInsets.only(left: 0, right: 1.6, bottom: 1.6, top: 1.6),
                color: Color(0xff5F8463),
                elevation: 2.1,
                child: Container(
                  color: Colors.grey[300],
                  margin: EdgeInsets.only(left: 1.6, right: 1.6),
                  padding: EdgeInsets.all(1.2),
                  child: Text(
                    'Non renseigné',
                    style: TextStyle(fontSize: 11),
                  ),
                ))
          ];
  }
}
//fin style notion

//Style card liste documents
class ListdocCard {
  bool statutdoc;
  dynamic chemindoc;
  dynamic chemincorrige;
  int anneepub;
  List notions;
  String nomdocument;

  ListdocCard(bool statutdoc, dynamic chemindoc, dynamic chemincorrige,
      int anneepub, List notions, String nomdocument) {
    this.statutdoc = statutdoc;
    this.chemindoc = chemindoc;
    this.chemincorrige = chemincorrige;
    this.anneepub = anneepub;
    this.notions = notions;
    this.nomdocument = nomdocument;
  }

  Card getListCard() {
    return new Card(
        color: Color(0xff5F8463),
        margin: EdgeInsets.all(0.0),
        child: Container(
            margin: EdgeInsets.only(top: 1.0),
            color: Colors.white,
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    nomdocument,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          margin: EdgeInsets.symmetric(vertical: 12.0),
                          height: 18.0,
                          child: notions != null
                              ? ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: notions,
                                )
                              : null),
                    ],
                  ),
                  //trailing: Text(document.yearPub.toString()),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      statutdoc == true
                          ? Icon(
                              Icons.monetization_on_outlined,
                              size: 21,
                              color: Colors.amber,
                            )
                          : Icon(
                              Icons.picture_as_pdf,
                              size: 21,
                              color: Color(0xff5F8463),
                            ),
                      Text(
                        chemincorrige != null ? "Corrigé" : '',
                        style: TextStyle(fontSize: 12, color: Colors.green),
                      ),
                      Text(anneepub.toString()),
                    ],
                  ),
                ),
              ],
            )));
  }
}
//Fin Style card liste documents

//style contient la liste
class Contientypedoc extends StatelessWidget {
  dynamic creationlistdoc;
  int nbrdoc;

  Contientypedoc(dynamic creationlistdoc, int nbrdoc) {
    this.creationlistdoc = creationlistdoc;
    this.nbrdoc = nbrdoc;
  }

  @override
  Column build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Chip(
          avatar: CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
            child: Text('$nbrdoc'),
          ),
          label: Text('documents'),
        ),
        Column(
          children: creationlistdoc,
        ),
      ],
    );
  }
}
//Fin style contient la liste

//Contenant général de doc type
class InterCard {
  bool statutdoc;
  dynamic chemindoc;
  dynamic chemincorrige;
  int anneepub;
  List notions;
  String nomDoc;

  InterCard(bool statutdoc, dynamic chemindoc, dynamic chemincorrige,
      int anneepub, List notions, String nomDoc) {
    this.statutdoc = statutdoc;
    this.chemindoc = chemindoc;
    this.chemincorrige = chemincorrige;
    this.anneepub = anneepub;
    this.notions = notions;
    this.nomDoc = nomDoc;
  }

  Card interCard(BuildContext context) {
    var listdoc = ListdocCard(
        statutdoc, chemindoc, chemincorrige, anneepub, notions, nomDoc);

    return new Card(
        color: Theme.of(context).primaryColor,
        margin: EdgeInsets.all(0.0),
        child: GestureDetector(
          child: Container(child: listdoc.getListCard()),

          //ontap en double à rechercheDoc
          onTap: () {
            statutdoc == true
                ? showDialog(
                        context: context,
                        builder: (context) => AlertePayement()) ??
                    false
                : Navigator.push(
                    context,
                    ScaleRoute(
                        page: new ReadPDF(
                            chemindoc, chemincorrige, "Voir le corrigé")));
          },
        ));
  }
}
//fin
