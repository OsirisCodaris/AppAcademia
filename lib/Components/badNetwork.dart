import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:quitter/quitter.dart';

class BadNetwork extends StatelessWidget {
  BadNetwork();

  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      content: new Text(
        "Impossible de se connecter au Serveur! Vérifier votre connexion internet ou réessayer plus tard",
        style: TextStyle(color: Colors.blueGrey),
      ),
      actions: <Widget>[
        OutlineButton(
            onPressed: () => Quitter.quitApplication(),
            child: Text(
              "Sortir",
              style: TextStyle(color: Theme.of(context).primaryColor),
            )),
        RaisedButton(
            onPressed: () {
              return Navigator.pop(context);
            },
            color: Theme.of(context).primaryColor,
            child: Text("Réessayer")),
      ],
    );
  }
}
