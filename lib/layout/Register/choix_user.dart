import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'choix_subj_prof.dart';
import 'choix_subj_stud.dart';

class InscriptionSuiv extends StatefulWidget {
  final String nomComplet;
  final String phone;
  final String email;
  final String password;

  InscriptionSuiv(this.nomComplet, this.phone, this.email, this.password);

  InscriptionSuivState createState() => new InscriptionSuivState(
      this.nomComplet, this.phone, this.email, this.password);
}

class InscriptionSuivState extends State<InscriptionSuiv> {
  String nomComplet;
  String phone;
  String email;
  String password;

  InscriptionSuivState(this.nomComplet, this.phone, this.email, this.password);

  int selectedRadioTile;
  int choixUser;

  @override
  void initState() {
    super.initState();
    selectedRadioTile = 1;
  }

  setSelectedRadioTile(int val) {
    setState(() {
      selectedRadioTile = val;
    });
  }

  String textHolder =
      "Le choix apprenant, vous donne accès à toutes les ressources pédagogiques de votre classe. Vous profitez également d\'un suivi sur le forum par des enseignants qualifiés.";

  changeText() {
    setState(() {
      textHolder =
          'Le choix enseignant, vous donne accès à toutes les ressources pédagogiques de votre matière dans toutes les classes. Vous profitez d\'une visibilité auprès des élèves si vous dispensez des cours de soutien.';
    });
  }

  changeText2() {
    setState(() {
      textHolder =
          "Le choix apprenant, vous donne accès à toutes les ressources pédagogiques de votre classe. Vous profitez également d\'un suivi sur le forum par des enseignants qualifiés.";
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: new Text('Inscription 2/3'),
          centerTitle: true,
          elevation: 21.0,
        ),
        body: new Center(
          child: SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text.rich(
                TextSpan(
                  style: TextStyle(fontSize: 21),
                  text: 'Choix', // default text style
                  children: <TextSpan>[
                    TextSpan(
                        text: ' d\'utilisateur ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              new Card(
                color: Theme.of(context).primaryColor,
                margin: EdgeInsets.all(12.0),
                child: new Container(
                  color: Colors.white,
                  margin: EdgeInsets.only(top: 3.0),
                  padding: new EdgeInsets.all(21.0),
                  child: new Column(
                    children: <Widget>[
                      new Text(
                        "$textHolder",
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
              ),
              RadioListTile(
                value: 1,
                groupValue: selectedRadioTile,
                title: Text("Apprenant"),
                onChanged: (val) {
                  changeText2();
                  setSelectedRadioTile(val);
                },
                selected: false,
              ),
              RadioListTile(
                value: 2,
                groupValue: selectedRadioTile,
                title: Text("Enseignant"),
                onChanged: (val) {
                  changeText();
                  setSelectedRadioTile(val);
                },
                selected: false,
              ),
              new Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    new Container(
                        margin: EdgeInsets.all(12),
                        child: RaisedButton(
                          onPressed: () {
                            if (selectedRadioTile == 1) {
                              Navigator.push(
                                  context,
                                  new PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          new InscriptionStud(nomComplet, phone,
                                              email, password)));
                            } else {
                              Navigator.push(
                                  context,
                                  new PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          new InscriptionProf(nomComplet, phone,
                                              email, password)));
                            }
                          },
                          padding: EdgeInsets.only(right: 0, left: 12),
                          child: Row(
                            // Replace with a Row for horizontal icon + text
                            children: <Widget>[
                              Text(
                                "Continuer",
                                style: new TextStyle(fontSize: 12.0),
                              ),
                              Icon(Icons.navigate_next,
                                  color: Colors.yellow, size: 36),
                            ],
                          ),
                        ))
                  ])
            ],
          )),
        ));
  }
}
