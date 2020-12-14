import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quitter/quitter.dart';

class Nonetwork extends StatefulWidget {
  NetworkState createState() => new NetworkState();
}

class NetworkState extends State<Nonetwork> {
  final _keyForm = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: new Text('Hors connexion...'),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return new Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SingleChildScrollView(
                child: Form(
                  key: _keyForm,
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.all(45.0),
                          child: Image(
                            image: AssetImage('images/nonetwork.png'),
                            width: 111,
                            height: 111,
                          )),
                      new Container(
                        child: Text(
                          ' Veuillez vérifier votre connexion Internet !',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline2,
                        ),
                      ),
                      new Container(
                        margin: EdgeInsets.all(45.0),
                        child: RaisedButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            color: Theme.of(context).primaryColor,
                            child: Text("REESSAYER")),
                      )
                    ],
                  ),
                ),
              ),
              OutlineButton(
                  onPressed: () => Quitter.quitApplication(),
                  child: Text("SORTIR", style: TextStyle(color: Colors.red))),
            ],
          );
        },
      ),
    );
  }
}
