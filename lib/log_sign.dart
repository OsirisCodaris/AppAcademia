import 'dart:io';

import 'package:academia/Components/transitionLeft.dart';
import 'package:academia/form_log.dart';
import 'package:academia/form_sign.dart';
import 'package:flutter/material.dart';

import 'Components/alerteDialogue.dart';

class ChoixLog extends StatefulWidget {
  ChoixLogState createState() => new ChoixLogState();
}

class ChoixLogState extends State<ChoixLog> {
  Future<bool> _onBackPressed() {
    return showDialog(
            context: context, builder: (context) => AlerteDialogue()) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Container(
                      margin: EdgeInsets.only(bottom: 36.0, left: 6.0),
                      child: Image(
                        image: AssetImage('images/ic_academia.png'),
                      )),
                  new RaisedButton(
                    onPressed: () {
                      Navigator.push(
                          context, new ScaleRoute(page: new Connexion()));
                    },
                    child: new Text(
                      "Connexion",
                      style: new TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ),
                  new RaisedButton(
                    onPressed: () {
                      Navigator.push(
                          context, new ScaleRoute(page: new Inscription()));
                    },
                    color: Colors.green[800],
                    child: new Text(
                      "Inscription",
                      style: new TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
