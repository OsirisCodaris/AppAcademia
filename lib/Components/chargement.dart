import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:loading_animations/loading_animations.dart';

class ChargementClass extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Center(
        child: Center(
            child: LoadingBouncingGrid.square(
      backgroundColor: Theme.of(context).primaryColor,
      borderColor: Colors.transparent,
    )));
  }
}

class PageChargement extends StatelessWidget {
  @override
  Center build(BuildContext context) {
    return new Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        new Container(
          padding: new EdgeInsets.all(3.0),
          child: LinearProgressIndicator(),
        )
      ],
    ));
  }
}
