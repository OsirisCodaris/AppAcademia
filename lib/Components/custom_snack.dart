import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomSnack {
  String text;
  String type;
  Color snackColor = Colors.white;
  Map color ={
    "danger": Colors.deepOrange,
    "success": Colors.white,
    "warning": Colors.amberAccent,

  };
  CustomSnack(String text, String type){
    this.text = text;
    this.type = type;
  }

  Text getText(){
    return new Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(color:color[this.type] ),
    );
  }
}