import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Components/alerteDialogue.dart';
import 'Components/docPopulaire.dart';
import 'HttpRequest/classe.dart';
import 'HttpRequest/document.dart';
import 'HttpRequest/matiere.dart';
import 'LocalRequest/localDatabase.dart';
import 'doc_subject.dart';
import 'Components/menuStud.dart';

import 'Components/chargement.dart';

import 'package:percent_indicator/percent_indicator.dart';

import 'nonetwork.dart';

class AllSubject extends StatefulWidget {
  @override
  _AllSubjectState createState() => _AllSubjectState();
}

class _AllSubjectState extends State<AllSubject> {
  List<Matieres> matieres;
  bool isLoading = true;
  List<Map<String, dynamic>> queryRows;
  // ignore: non_constant_identifier_names
  List<Documents> pop_doc;
  List<Matieres> allMatieres;
  List<Classes> allClasses;
  String userInfo = '';

  @override
  void initState() {
    super.initState();
    onLoad();
  }

  onLoad() async {
    try {
      queryRows = await DatabaseHelper.instance.user();

      if (queryRows[0]["role"] == "STUDENT") {
        allClasses = await Classes.getClasses();
        for (Classes classe in allClasses) {
          if (classe.idclasses == queryRows[0]["module"]) {
            userInfo = classe.name;
          }
        }
      } else {
        allMatieres = await Matieres.getMatiere();
        for (Matieres matiere in allMatieres) {
          if (matiere.idsubjects == queryRows[0]["module"]) {
            userInfo = matiere.name;
          }
        }
      }
      matieres = await Matieres.getMatiereClasse(queryRows[0]['module']);
      pop_doc = await Documents.getDocumentClasseRandom(queryRows[0]['module']);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Nonetwork()),
      ).then((value) => onLoad());
    }
  }

  List<Widget> createCardListMatieresClasses() {
    List<Widget> widgets = [];

    for (Matieres matiere in matieres) {
      double pourcentage =
          matiere.countDoc != null && matiere.countAnswer != null
              ? matiere.countDoc > 0 && matiere.countAnswer > 0
                  ? ((matiere.countAnswer * 100) / matiere.countDoc).toDouble()
                  : 0
              : 0;

      double pourcentageSimple = pourcentage / 100;

      //design de la card
      final matierecard = new Card(
          color: Theme.of(context).primaryColor,
          child: GestureDetector(
            child: Container(
              color: Colors.white,
              margin: EdgeInsets.only(left: 3.0, right: 3.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                        child: Column(
                      children: [
                        Expanded(
                            flex: 1,
                            child: CircularPercentIndicator(
                              radius: 60.0,
                              lineWidth: 3.0,
                              percent: pourcentageSimple,
                              center: new Text("${pourcentage.truncate()} %"),
                              progressColor: Theme.of(context).accentColor,
                            ))
                      ],
                    )),
                  ),
                  Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(matiere.name,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              )),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text.rich(
                                TextSpan(
                                  text: 'Documents :', // default text style
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: ' ' + matiere.countDoc.toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              Text.rich(
                                TextSpan(
                                  text: 'Corrigés :', // default text style
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: ' ' +
                                            matiere.countAnswer.toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .primaryColor)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
                ],
              ),
            ),
            onTap: () {
              Navigator.push(
                      context,
                      new PageRouteBuilder(
                          pageBuilder: (context, animation,
                                  secondaryAnimation) =>
                              new DocSubject(matiere.idsubjects, matiere.name)))
                  .then((value) => onLoad());
            },
          ));

      widgets.add(
        Container(
          height: 108,
          width: double.infinity,
          margin: EdgeInsets.only(left: 18.0, right: 18.0),
          child: matierecard,
        ),
      );
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
              title: new Text('Academia'),
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
                ? MenuStud(userInfo)
                : null, //appelle du menu de l'élève
            body: Builder(
              builder: (BuildContext context) {
                return new Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage('images/fond_light.png'),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.3), BlendMode.dstATop),
                    )),
                    child: new Center(
                        child: isLoading
                            ? ChargementClass()
                            : SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Container(
                                      child: Text(
                                        'Documents Populaires',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline2,
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    DocPopulaire(
                                        pop_doc), //appelle du composant des docs popu
                                    Divider(),
                                    Container(
                                      child: Text(
                                        'Matières',
                                        style: TextStyle(
                                            fontSize: 27,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
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
