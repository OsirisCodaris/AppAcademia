import 'package:academia/Components/alerteDialogue.dart';
import 'package:academia/Components/transitionLeft.dart';
import 'package:academia/HttpRequest/document.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../read_pdf.dart';

//Class pour gérer la recherche
class DataSearch extends SearchDelegate<String> {
  List<Documents> docInClasse;

  DataSearch(this.docInClasse);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      Container(
        margin: EdgeInsets.only(top: 12.0),
      ),
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

//design de la recherche
  @override
  ThemeData appBarTheme(BuildContext context) {
    // TODO: implement appBarTheme
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme.copyWith(
        primaryColor: Theme.of(context).primaryColor,
        textTheme:
            TextTheme(title: TextStyle(color: Colors.white, fontSize: 18)),
        inputDecorationTheme:
            InputDecorationTheme(hintStyle: TextStyle(color: Colors.white54)));
  }

  @override
  // TODO: implement searchFieldLabel
  String get searchFieldLabel => "Recherche...";

  List<Widget> createListileDocument(
      BuildContext context, List<Documents> documents) {
    List<Widget> widgets = [];
    for (Documents document in documents) {
      List<Card> notion = document.notions
          .split(';') // split the text into an array
          .map(
            (String text) => Card(
                margin:
                    EdgeInsets.only(left: 0, right: 1.6, bottom: 1.6, top: 1.6),
                color: Theme.of(context).primaryColor,
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
          .toList();
      widgets.add(Card(
          color: Theme.of(context).primaryColor,
          margin: EdgeInsets.all(0.0),
          child: Container(
            margin: EdgeInsets.only(top: 1.0),
            color: Colors.white,
            child: ListTile(
              title: Text(
                document.nomDocument,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              subtitle: Container(
                  margin: EdgeInsets.symmetric(vertical: 12.0),
                  height: 18.0,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: notion,
                  )),
              //trailing: Text(document.yearPub.toString()),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  document.statut == true
                      ? Icon(
                          Icons.monetization_on_outlined,
                          size: 21,
                          color: Colors.amber,
                        )
                      : Icon(
                          Icons.picture_as_pdf,
                          size: 21,
                          color: Theme.of(context).primaryColor,
                        ),
                  Text(
                    document.pathAnswer != null ? "Corrigé" : '',
                    style: TextStyle(
                        fontSize: 12, color: Theme.of(context).accentColor),
                  ),
                  Text(document.yearPub.toString()),
                ],
              ),
              onTap: () {
                document.statut == true
                    ? showDialog(
                            context: context,
                            builder: (context) => AlertePayement()) ??
                        false
                    : Navigator.push(
                        context,
                        ScaleRoute(
                            page: new ReadPDF(document.path,
                                document.pathAnswer, "Voir le corrigé")));
              },
            ),
          )));
    }
    return widgets;
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(
        height: 100.0,
        width: 100.0,
        child: Card(
          shape: StadiumBorder(),
          child: Center(
            child: Text(query),
          ),
        ));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? docInClasse
        : docInClasse
            .where((p) =>
                p.nomDocument.toLowerCase().contains(query.toLowerCase()) ||
                p.notions.toLowerCase().contains(query.toLowerCase()))
            .toList();
    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/fond_light.png'), fit: BoxFit.cover),
        ),
        child: Builder(builder: (BuildContext context) {
          return SingleChildScrollView(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Chip(
                  avatar: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Text(
                        '${createListileDocument(context, suggestionList).length}'),
                  ),
                  label: Text('documents'),
                ),
                Column(
                  children: createListileDocument(context, suggestionList),
                ),
              ],
            ),
          );
        }));
  }
}
