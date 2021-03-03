import 'package:academia/Components/FileReader.dart';
import 'package:academia/models/problems.dart';
import 'package:flutter/material.dart';

class ShowProblem extends StatelessWidget {
  final Problems problems;
  ShowProblem(this.problems);

  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(problems.fullname.toUpperCase(),
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              )),
          SizedBox(height: 8.0),
          problems.file != null
              ? new Expanded(flex: 1, child: FileReader(problems.file))
              : Container(),
          SizedBox(height: 2.0),
          new Expanded(
              flex: 1,
              child: SingleChildScrollView(
                  child: Text(
                problems.content,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16.0,
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.justify,
              ))),
        ],
      ),
      actions: <Widget>[
        RaisedButton(
            onPressed: () {
              return Navigator.pop(context);
            },
            color: Theme.of(context).primaryColor,
            child: Text("RETOUR")),
      ],
    );
  }
}
