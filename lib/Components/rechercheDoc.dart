import 'package:academia/Components/fontImage.dart';
import 'package:academia/Components/typedocDesign.dart';
import 'package:academia/models/documents.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      var listnotion = NotionCard(document.notions);
      List<Card> notion = listnotion.getNotionCard();

      //appel de la class Card customisée listdoc
      var listInterDoc = InterCard(document.status, document.pathfile,
          document.pathAnswer, document.year, notion, document.name);

      widgets.add(listInterDoc.interCard(context));
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
    final suggestionList = query.isEmpty
        ? docInClasse
        : docInClasse
            .where((p) =>
                p.name.toLowerCase().contains(query.toLowerCase()) ||
                p.notions.toLowerCase().contains(query.toLowerCase()))
            .toList();
    return Container(
        decoration: DecoFontImage().fontClair(),
        child: Builder(builder: (BuildContext context) {
          var contenantlist = Contientypedoc(
              createListileDocument(context, suggestionList),
              createListileDocument(context, suggestionList).length);
          return SingleChildScrollView(child: contenantlist.build(context));
        }));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? docInClasse
        : docInClasse
            .where((p) =>
                p.name.toLowerCase().contains(query.toLowerCase()) ||
                (p.notions?.toLowerCase()?.contains(query.toLowerCase()) ??
                    false))
            .toList();
    return Container(
        decoration: DecoFontImage().fontClair(),
        child: Builder(builder: (BuildContext context) {
          var contenantlist = Contientypedoc(
              createListileDocument(context, suggestionList),
              createListileDocument(context, suggestionList).length);
          return SingleChildScrollView(child: contenantlist.build(context));
        }));
  }
}
