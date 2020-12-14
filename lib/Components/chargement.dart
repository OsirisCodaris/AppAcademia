import 'package:flutter/material.dart';
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
