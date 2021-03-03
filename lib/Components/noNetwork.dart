import 'dart:async';

import 'package:academia/HttpRequest/Api.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:quitter/quitter.dart';

class Nonetwork extends StatefulWidget {
  @override
  _Nonetwork createState() => _Nonetwork();
}

class _Nonetwork extends State<Nonetwork> {
  Connectivity connectivity = Connectivity();
  StreamSubscription streamSubscription;
  bool isdisable = true;
  String message = "Aucune connexion detecter...";

  @override
  Widget build(BuildContext context) {
    scheduleRequestRetry(context);
    return new AlertDialog(
      content: new Text(
        message,
        style: TextStyle(
            color: isdisable ? Colors.red : Theme.of(context).primaryColor),
      ),
      actions: isdisable
          ? <Widget>[
              OutlineButton(
                  onPressed: () => Quitter.quitApplication(),
                  child: Text(
                    "Sortir",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  )),
            ]
          : null,
    );
  }

  scheduleRequestRetry(context) async {
    Dio dio = new Dio(Api.options);
    streamSubscription = connectivity.onConnectivityChanged.listen(
      (connectivityResult) async {
        if (connectivityResult != ConnectivityResult.none &&
            isdisable == true) {
          await streamSubscription.cancel();
          if (mounted) {
            dio.get("/classes").then((response) {
              setState(() {
                isdisable = false;
                message = "Connexion rétabli...";
              });
              new Future.delayed(
                  const Duration(seconds: 1), () => Navigator.pop(context));
            }).catchError((err) {
              /*R setState(() {
                isdisable = true;
              });*/
              Navigator.pop(context);
            });
          }
        }
        if (connectivityResult == ConnectivityResult.none &&
            isdisable == false) {
          if (mounted) {
            setState(() {
              isdisable = true;
            });
          }
        }
      },
    );
  }
}
