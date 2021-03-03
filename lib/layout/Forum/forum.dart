import 'package:academia/Components/alerteDialogue.dart';
import 'package:academia/Components/cardDesign.dart';
import 'package:academia/Components/chargement.dart';
import 'package:academia/Components/handleError.dart';
import 'package:academia/Components/menu.dart';
import 'package:academia/HttpRequest/classerequest.dart';
import 'package:academia/HttpRequest/matiererequest.dart';
import 'package:academia/LocalRequest/localDatabase.dart';
import 'package:academia/layout/Forum/problem.dart';
import 'package:academia/models/classe.dart';
import 'package:academia/models/matiere.dart';
import 'package:academia/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Forum extends StatefulWidget {
  @override
  _ForumState createState() => _ForumState();
}

class _ForumState extends State<Forum> {
  var labels;
  bool isLoading = true;
  String userInfo = '';
  User currentUser;
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
        labels = await MatiereRequest.getForumMatiereClasse(currentUser.module);
      } else {
        var modules = await MatiereRequest.getMatiere();
        for (Matieres label in modules) {
          if (label.idsubjects == currentUser.module) {
            userInfo = label.name;
          }
        }
        labels = await ClasseRequest.getForumClassesSubject(currentUser.module);
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

  List<Widget> createCardListLabels() {
    List<Widget> widgets = [];

    for (var label in labels) {
      double pourcentage = label.countProblem != null &&
              label.countResponse != null
          ? label.countProblem > 0 && label.countResponse > 0
              ? ((label.countResponse * 100) / label.countProblem).toDouble()
              : 0
          : 0;
      double pourcentageSimple = pourcentage / 100;

      //appel de la class Card customisée
      var custom = CustomCard(pourcentageSimple, pourcentage, label.name,
          label.countProblem, label.countResponse, false);

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
                      new PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  new Problem(id, label.name, currentUser)))
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
              title: new Text('Forum'),
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
            drawer: userInfo != '' ? Menu(currentUser, userInfo) : null,
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
                    child: new Container(
                        child: isLoading
                            ? ChargementClass()
                            : SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Divider(),
                                    Container(
                                      child: Text(
                                        'Tableau de bord',
                                        style: TextStyle(
                                            fontSize: 27,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    Container(
                                      child: Column(
                                        children: createCardListLabels(),
                                      ),
                                    )
                                  ],
                                ),
                              )));
              },
            )));
  }
}
