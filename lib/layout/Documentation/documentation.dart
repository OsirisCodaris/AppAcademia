import 'package:academia/Components/alerteDialogue.dart';
import 'package:academia/Components/cardDesign.dart';
import 'package:academia/Components/chargement.dart';
import 'package:academia/Components/docPopulaire.dart';
import 'package:academia/Components/fontImage.dart';
import 'package:academia/Components/handleError.dart';
import 'package:academia/Components/menu.dart';
import 'package:academia/HttpRequest/classerequest.dart';
import 'package:academia/HttpRequest/documentrequest.dart';
import 'package:academia/HttpRequest/matiererequest.dart';
import 'package:academia/LocalRequest/localDatabase.dart';

import 'package:academia/layout/Documentation/doc_subject.dart';
import 'package:academia/models/classe.dart';
import 'package:academia/models/documents.dart';
import 'package:academia/models/matiere.dart';
import 'package:academia/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Documentation extends StatefulWidget {
  @override
  _DocumentationState createState() => _DocumentationState();
}

class _DocumentationState extends State<Documentation> {
  User currentUser;

  List<dynamic> labels;
  bool isLoading = true;
  List<Documents> docPopulaire;
  String userInfo = '';
  @override
  void initState() {
    super.initState();
    onLoad();
  }

  onLoad() async {
    try {
      var queryRows = await DatabaseHelper.instance.user();
      currentUser = User.fromJson(queryRows[0]);
      if (currentUser.role == "STUDENT") {
        var modules = await ClasseRequest.getClasses();
        for (Classes classe in modules) {
          if (classe.idclasses == currentUser.module) {
            userInfo = classe.name;
          }
        }
        labels = await MatiereRequest.getMatiereClasse(currentUser.module);
        docPopulaire =
            await DocumentRequest.getDocumentClasseRandom(currentUser.module);
      } else {
        var modules = await MatiereRequest.getMatiere();
        for (Matieres matiere in modules) {
          if (matiere.idsubjects == currentUser.module) {
            userInfo = matiere.name;
          }
        }
        labels = await ClasseRequest.getClassesSubject(currentUser.module);
        docPopulaire =
            await DocumentRequest.getDocumentSubjectRandom(currentUser.module);
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      HandleError.buildError(context, e).then((r) {
        return onLoad();
      });
    }
  }

  List<Widget> createCardListMatieresClasses() {
    List<Widget> widgets = [];

    for (var label in labels) {
      double pourcentage =
          label.countDocument != null && label.countAnswer != null
              ? label.countDocument > 0 && label.countAnswer > 0
                  ? ((label.countAnswer * 100) / label.countDocument).toDouble()
                  : 0
              : 0;

      double pourcentageSimple = pourcentage / 100;

      //appel de la class Card customisée
      var custom = CustomCard(pourcentageSimple, pourcentage, label.name,
          label.countDocument, label.countAnswer, true);

      //design de la card
      final labelcard = new Card(
          color: Theme.of(context).primaryColor,
          child: GestureDetector(
            //design card appelé
            child: Container(child: custom.getCard()),
            onTap: () {
              int id = (label is Matieres) ? label.idsubjects : label.idclasses;
              Navigator.push(
                      context,
                      PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  new DocSubject(id, label.name)))
                  .then((value) => onLoad());
            },
          ));

      var custumEnd = CustomCardend(labelcard);

      widgets.add(custumEnd.getCardEnd());
    }
    return widgets;
  }

  Future<bool> _onBackPressed() {
    return showDialog(
            context: context, builder: (context) => AlerteDialogue()) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
            appBar: AppBar(
              title: AccueilTextAppBar().textAppBar(context),
              actions: <Widget>[
                Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: GestureDetector(
                      onTap: isLoading
                          ? () {}
                          : () {
                              setState(() {
                                isLoading = true;
                                onLoad();
                              });
                            },
                      child: Icon(
                        Icons.refresh,
                        size: 26.0,
                      ),
                    )),
              ],
            ),
            drawer: userInfo != ''
                ? Menu(currentUser, userInfo)
                : null, //appelle du menu de l'élève
            body: Builder(
              builder: (BuildContext context) {
                return new Container(
                    decoration: DecoFontImage().fontClair(), //background
                    child: new Center(
                        child: isLoading
                            ? ChargementClass()
                            : SingleChildScrollView(
                                child: Column(
                                  children: [
                                    AccueilComposantsTop().textTop(context),
                                    DocPopulaire(
                                        docPopulaire), //appelle du composant des docs popu
                                    Divider(),
                                    AccueilComposantsMiddle("Tableau de Bord")
                                        .textMiddle(context),
                                    Container(
                                      child: Column(
                                        children:
                                            createCardListMatieresClasses(),
                                      ),
                                    )
                                  ],
                                ),
                              )));
              },
            )));
  }
}
