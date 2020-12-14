import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quitter/quitter.dart';
import 'package:url_launcher/url_launcher.dart';

class AlerteDialogue extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      title: new Text('Academia'),
      content: new Text("Voulez-vous sortir ?"),
      actions: <Widget>[
        OutlineButton(
            onPressed: () => Quitter.quitApplication(),
            child: Text(
              "OUI",
              style: TextStyle(color: Theme.of(context).primaryColor),
            )),
        RaisedButton(
            onPressed: () => Navigator.of(context).pop(false),
            color: Theme.of(context).primaryColor,
            child: Text("NON")),
      ],
    );
  }
}

class AlertePayement extends StatelessWidget {
  String url = 'https://play.google.com/store/apps/details?id=ga.academiagabon';
  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      title: const Text.rich(
        TextSpan(
          text: 'Document', // default text style
          children: <TextSpan>[
            TextSpan(text: ' Payant', style: TextStyle(color: Colors.amber)),
          ],
        ),
      ),
      content: new Text(
          "Veuillez procéder à la mise à jour de l'application pour y accéder."),
      actions: <Widget>[
        OutlineButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              "Plus tard",
              style: TextStyle(color: Theme.of(context).primaryColor),
            )),
        RaisedButton(
            onPressed: () async {
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                Navigator.of(context).pop(false);
              }
            },
            color: Theme.of(context).primaryColor,
            child: Text("Mettre à jour")),
      ],
    );
  }

  Future<void> _launchURL(context) async {}
}
