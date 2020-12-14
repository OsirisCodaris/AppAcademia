import 'package:academia/HttpRequest/typedoc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import 'HttpRequest/document.dart';
import 'LocalRequest/localDatabase.dart';
import 'doc_type.dart';
import 'Components/rechercheDoc.dart';
import 'Components/chargement.dart';
import 'nonetwork.dart';

class DocSubject extends StatefulWidget {
  int id;

  String name;

  DocSubject(this.id, this.name);

  DocSubjectState createState() => new DocSubjectState(id, name);
}

class DocSubjectState extends State<DocSubject> {
  int id;
  String name;
  List<Map<String, dynamic>> queryRows;
  List<TypeDocs> typedocs;
  bool isLoading = true;
  bool userProf = true;
  List<Documents> docInClasses = [];

  DocSubjectState(this.id, this.name);
  @override
  void initState() {
    super.initState();
    onLoad();
  }

  onLoad() async {
    try {
      queryRows = await DatabaseHelper.instance.user();
      typedocs = await TypeDocs.getTypeDoc();
      if (queryRows.length > 0) {
        if (queryRows[0]["role"] == "STUDENT") {
          userProf = false;
        }
      }
      var idclasse = userProf ? id : queryRows[0]['module'];
      var idmatiere = userProf ? queryRows[0]['module'] : id;
      docInClasses = await Documents.getDocInClasseSubject(idclasse, idmatiere);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Nonetwork()),
      ).then((value) => onLoad());
    }
  }

  getTabs() {
    List<Tab> tabs = [];
    typedocs.forEach((element) {
      tabs.add(new Tab(
        text: element.name,
      ));
    });
    return tabs;
  }

  final controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    Text title = new Text("$name");
    return new Scaffold(
      body: Builder(builder: (BuildContext context) {
        return isLoading
            ? new Center(
                child: new Container(
                    padding: new EdgeInsets.all(9.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            child: ColorizeAnimatedTextKit(
                                text: [
                                  "$name",
                                ],
                                textStyle: TextStyle(
                                    fontSize: 27.0,
                                    fontFamily: "Horizon",
                                    fontWeight: FontWeight.bold),
                                colors: [
                                  Theme.of(context).primaryColor,
                                  Colors.blue,
                                  Colors.yellow,
                                  Theme.of(context).accentColor,
                                ],
                                textAlign: TextAlign.center,
                                alignment: AlignmentDirectional
                                    .center // or Alignment.topLeft
                                ),
                          ),
                          ChargementClass(),
                        ])))
            : new DefaultTabController(
                length: typedocs.length,
                child: new Scaffold(
                  appBar: new AppBar(
                    title: title,
                    actions: <Widget>[
                      IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () {
                            showSearch(
                                context: context,
                                delegate: DataSearch(docInClasses));
                          })
                    ],
                    bottom: new TabBar(indicatorWeight: 4.0, tabs: getTabs()),
                  ),
                  body: new TabBarView(children: controllers()),
                ));
      }),
    );
  }

  List<Widget> controllers({controller}) {
    List<DocType> doctype = [];
    var idclasse = userProf ? id : queryRows[0]['module'];
    var idmatiere = userProf ? queryRows[0]['module'] : id;
    typedocs.forEach((element) {
      doctype.add(new DocType(idclasse, idmatiere, element));
    });
    return doctype;
  }
}
