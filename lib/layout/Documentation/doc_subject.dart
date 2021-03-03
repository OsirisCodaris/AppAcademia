import 'package:academia/Components/alerteDialogue.dart';
import 'package:academia/Components/chargement.dart';
import 'package:academia/Components/handleError.dart';
import 'package:academia/Components/rechercheDoc.dart';
import 'package:academia/HttpRequest/documentrequest.dart';
import 'package:academia/HttpRequest/typedocrequest.dart';
import 'package:academia/LocalRequest/localDatabase.dart';
import 'package:academia/layout/Documentation/doc_type.dart';
import 'package:academia/models/documents.dart';
import 'package:academia/models/typedocs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

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
  List<Typedocs> typedocs;
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
      typedocs = await TypeDocRequest.getTypeDoc();
      if (queryRows.length > 0) {
        if (queryRows[0]["role"] == "STUDENT") {
          userProf = false;
        }
      }
      var idclasse = userProf ? id : queryRows[0]['module'];
      var idmatiere = userProf ? queryRows[0]['module'] : id;
      docInClasses =
          await DocumentRequest.getDocInClasseSubject(idclasse, idmatiere);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      HandleError.buildError(context, e).then((r) {
        return onLoad();
      });
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
