import 'dart:io';
import 'dart:ui';

import 'package:academia/Components/cardProblem.dart';
import 'package:academia/Components/chargement.dart';
import 'package:academia/Components/custom_snack.dart';
import 'package:academia/Components/fontImage.dart';
import 'package:academia/Components/handleError.dart';
import 'package:academia/HttpRequest/problemrequest.dart';
import 'package:academia/models/problems.dart';
import 'package:academia/models/user.dart';
import 'package:academia/utils/debouncer.dart';
import 'package:academia/utils/multipartfile.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:simple_moment/simple_moment.dart';

class Problem extends StatefulWidget {
  int id;
  String name;
  User currentUser;
  Problem(this.id, this.name, this.currentUser);
  @override
  _ProblemState createState() => _ProblemState(id, name, currentUser);
}

class _ProblemState extends State<Problem> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _debouncer = Debouncer(milliseconds: 500);
  int id;
  String name;
  List<Problems> problems;
  List<Problems> filterprob = [];
  bool isLoading = true;
  bool isSending = false;
  List<Map<String, dynamic>> queryRows;
  // ignore: non_constant_identifier_names
  String query = '';
  User currentUser;
  _ProblemState(this.id, this.name, this.currentUser);

  String fileName = '';
  TextEditingController _controller = TextEditingController();
  File file;

  @override
  void initState() {
    super.initState();
    onLoad();
  }

  onLoad() async {
    try {
      if (currentUser.role == "STUDENT") {
        problems = await ProblemRequest.getProblem(currentUser.module, id);
      } else {
        problems = await ProblemRequest.getProblem(id, currentUser.module);
      }

      setState(() {
        isLoading = false;
        isSending = false;
      });
    } catch (e) {
      HandleError.buildError(context, e).then((r) {
        return onLoad();
      });
    }
  }

  List<Widget> createCardListProblems() {
    List<Widget> widgets = [];
    final suggestionList = query.isEmpty ? problems : filterprob;
    for (Problems problem in suggestionList) {
      widgets.add(
        Container(
            key: new Key(problem.content),
            height: 108,
            width: double.infinity,
            margin: EdgeInsets.only(left: 18.0, right: 18.0),
            child: CardProblem(problem, currentUser)),
      );
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: new Text(name),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: isLoading
                      ? () {}
                      : () {
                          setState(() {
                            isLoading = true;
                            onLoad();
                          });
                        },
                  child: Icon(
                    Icons.refresh,
                    size: 26.0,
                  ),
                )),
          ],
        ),
        body: Builder(
          builder: (BuildContext context) {
            return new Container(
                decoration: DecoFontImage().fontClair(), //background
                child: new Container(
                    child: isLoading
                        ? Center(child: ChargementClass())
                        : Column(children: [
                            isSending ? PageChargement() : Divider(),
                            postProblem(),
                            Divider(),
                            Chip(
                              avatar: CircleAvatar(
                                backgroundColor: Theme.of(context).primaryColor,
                                child:
                                    Text('${createCardListProblems().length}'),
                              ),
                              label: Text('problèmes'),
                            ),
                            Expanded(
                              child: ListView(
                                children: createCardListProblems(),
                              ),
                            )
                          ])));
          },
        ));
  }

  Widget postProblem() {
    return Container(
        margin: EdgeInsets.only(left: 8.0, right: 8.0),
        child: Column(children: [
          Row(children: [
            Expanded(
                child: TextField(
              controller: _controller,
              autocorrect: true,
              minLines: 1,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: currentUser.role == 'STUDENT'
                    ? 'Postez votre Problème...'
                    : 'Rechercher un Problème',
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.white70,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
                suffixIcon: currentUser.role == 'STUDENT'
                    ? IconButton(
                        icon: Icon(Icons.attach_file),
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          _openFileExplorer();
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                _debouncer.run(() {
                  setState(() {
                    query = value.replaceAll('\n', ' ').trim();
                    filterprob = filtre(query, problems);
                  });
                });
              },
            )),
            currentUser.role == 'STUDENT'
                ? IconButton(
                    icon: Icon(Icons.send),
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      if (_controller.text.isNotEmpty) {
                        _sendProblem();
                      } else {
                        var custom = new CustomSnack(
                            "Veuillez indiquer le contenu de votre problème !",
                            "warning");
                        _scaffoldKey.currentState.showSnackBar(new SnackBar(
                          content: custom.getText(),
                        ));
                      }
                    },
                  )
                : Divider(),
          ]),
          Container(
              child: fileName.isNotEmpty
                  ? GestureDetector(
                      child: Chip(
                        avatar: Icon(
                          Icons.clear,
                          size: 14,
                          color: Theme.of(context).primaryColor,
                        ),
                        label: Text(fileName,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                            )),
                      ),
                      onTap: () {
                        setState(() {
                          fileName = '';
                        });
                      },
                    )
                  : null),
        ]));
  }

  List<Problems> filtre(String query, List<Problems> problems) {
    List<Problems> suggestionList = [];
    for (var p in problems) {
      bool isContains = false;
      var queryList = query.split(" ").toList();
      for (String q in queryList) {
        if (p.content.toLowerCase().contains(q.toLowerCase()) ||
            (p.fullname.toLowerCase().contains(q.toLowerCase()))) {
          isContains = true;
        }
      }
      if (isContains) {
        suggestionList.add(p);
      }
    }
    bool changed = false;
    do {
      changed = false;
      for (int i = 0; i < suggestionList.length - 1; i++) {
        if (compteur(suggestionList[i], query) <
            compteur(suggestionList[i + 1], query)) {
          var tmp = suggestionList[i + 1];
          suggestionList[i + 1] = suggestionList[i];
          suggestionList[i] = tmp;
          changed = true;
        }
      }
    } while (changed);
    return suggestionList;
  }

  int compteur(Problems p, String query) {
    int compte = 0;
    for (String q in query.split(" ").toList()) {
      if (p.content?.toLowerCase()?.contains(q.toLowerCase()) ??
          p.fullname.toLowerCase().contains(q.toLowerCase())) {
        compte++;
      }
    }
    return compte;
  }

  void _openFileExplorer() async {
    FilePickerResult result = await FilePicker.platform.pickFiles();

    if (result != null) {
      file = File(result.files.single.path);
      setState(() {
        fileName = result.files.single.name;
      });
    } else {
      // User canceled the picker
    }
  }

  void _sendProblem() async {
    try {
      setState(() {
        isSending = true;
      });
      var files = file != null
          ? MultipartFileExtended.fromFileSync(file.path, filename: fileName)
          : null;
      print(files);
      await ProblemRequest.sendProblem(currentUser.idusers, id,
          _controller.text.toString(), files, fileName);
      setState(() {
        isSending = false;
      });
      _scaffoldKey.currentState.showSnackBar(new SnackBar(
          content: new Text('Votre problème a été posté!',
              textAlign: TextAlign.center)));
      setState(() {
        file = null;
        fileName = '';
        query = '';
        _controller.clear();
        onLoad();
      });
    } catch (e) {
      HandleError.buildError(context, e, _scaffoldKey)
          .then((result) => onLoad());
    }
  }
}
