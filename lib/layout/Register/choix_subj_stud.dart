import 'package:academia/Components/alerteDialogue.dart';
import 'package:academia/Components/chargement.dart';
import 'package:academia/Components/custom_snack.dart';
import 'package:academia/Components/handleError.dart';
import 'package:academia/HttpRequest/authrequest.dart';
import 'package:academia/HttpRequest/classerequest.dart';

import 'package:academia/layout/Login/form_log.dart';
import 'package:academia/models/classe.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;

class InscriptionStud extends StatefulWidget {
  String nomComplet;
  String phone;
  String email;
  String password;

  InscriptionStud(this.nomComplet, this.phone, this.email, this.password);

  InscriptionStudState createState() => new InscriptionStudState(
      this.nomComplet, this.phone, this.email, this.password);
}

class InscriptionStudState extends State<InscriptionStud> {
  String nomComplet;
  String phone;
  String email;
  String password;
  List<Classes> classes;
  Classes selectedClasse;
  bool isLoading = true;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  InscriptionStudState(this.nomComplet, this.phone, this.email, this.password);

  @override
  initState() {
    super.initState();
    onLoad();
  }

  onLoad() async {
    try {
      classes = await ClasseRequest.getClasses();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      HandleError.buildError(context, e).then((r) {
        return onLoad();
      });
    }
  }

  List<Widget> createRadioListClasses() {
    List<Widget> widgets = [];
    for (Classes classe in classes) {
      widgets.add(
        RadioListTile(
          value: classe,
          groupValue: selectedClasse,
          title: Text(classe.name),
          onChanged: (currentClasse) {
            setSelectedClasse(currentClasse);
          },
          selected: selectedClasse == classe,
        ),
      );
    }

    return widgets;
  }

  setSelectedClasse(Classes classe) {
    setState(() {
      selectedClasse = classe;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: new Text('Inscription 3/3'),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return new Center(
              child: SingleChildScrollView(
            child: isLoading
                ? ChargementClass()
                : new Column(
                    children: <Widget>[
                      const Text.rich(
                        TextSpan(
                          style:
                              TextStyle(fontSize: 21, color: Color(0xff5F8463)),
                          text: 'Vous êtes', // default text style
                          children: <TextSpan>[
                            TextSpan(
                                text: ' élève',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Divider(),
                      const Text.rich(
                        TextSpan(
                          style: TextStyle(
                            fontSize: 18,
                          ),
                          text: 'Choisissez votre', // default text style
                          children: <TextSpan>[
                            TextSpan(
                                text: ' classe',
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
                            child: Column(
                              children: createRadioListClasses(),
                            ),
                          )),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          new Container(
                            child: RaisedButton(
                              onPressed: () {
                                if (selectedClasse == null) {
                                  erreurSelection(context);
                                } else {
                                  enregistreUser(context, nomComplet, phone,
                                      email, password, selectedClasse);
                                }
                              },
                              padding: EdgeInsets.only(right: 0, left: 6),
                              child: Row(
                                // Replace with a Row for horizontal icon + text
                                children: <Widget>[
                                  Text(
                                    "Finir ",
                                    style: new TextStyle(fontSize: 15.0),
                                  ),
                                  Icon(Icons.check_circle,
                                      color: Colors.yellow, size: 21),
                                ],
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
          ));
        },
      ),
    );
  }

  void erreurSelection(BuildContext context) {
    var custom = new CustomSnack("Veuillez choisir une classe !", "warning");
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: custom.getText(),
    ));
  }

  Future<void> enregistreUser(
      BuildContext context,
      String nomComplet,
      String phone,
      String email,
      String password,
      Classes selectedClasse) async {
    try {
      var response = await Authentification.register(nomComplet, phone, email,
          password, selectedClasse.idclasses, 'students');

      var custom = new CustomSnack("Inscription validée", "success");
      Scaffold.of(context).showSnackBar(new SnackBar(
        content: custom.getText(),
      ));
      new Future.delayed(
          const Duration(seconds: 2),
          () => Navigator.push(context,
              new MaterialPageRoute(builder: (context) => new Connexion())));
    } catch (e) {
      HandleError.buildError(context, e, _scaffoldKey);
    }
  }
}
