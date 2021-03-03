import 'package:academia/layout/Login/form_log.dart';
import 'package:flutter/material.dart';
import 'package:quitter/quitter.dart';

class DisconnectDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      content: new Text(
        "Vous avez été déconnecté ",
        style: TextStyle(color: Colors.red),
      ),
      actions: <Widget>[
        OutlineButton(
            onPressed: () {
              Quitter.quitApplication();
            },
            child: Text(
              "Sortir",
              style: TextStyle(color: Theme.of(context).primaryColor),
            )),
        RaisedButton(
            onPressed: () => Navigator.push(
                context,
                PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        new Connexion())),
            color: Theme.of(context).primaryColor,
            child: Text("Connexion")),
      ],
    );
  }
}
