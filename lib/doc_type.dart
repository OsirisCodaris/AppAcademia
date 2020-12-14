import 'package:academia/Components/alerteDialogue.dart';
import 'package:academia/HttpRequest/typedoc.dart';
import 'package:academia/read_pdf.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/rendering.dart';

import 'Components/transitionLeft.dart';
import 'HttpRequest/document.dart';
import 'nonetwork.dart';

class DocType extends StatefulWidget {
  int matiereId;
  int classeId;
  TypeDocs typeDoc;

  DocType(this.classeId, this.matiereId, this.typeDoc);

  DocTypeState createState() =>
      new DocTypeState(this.classeId, matiereId, typeDoc);
}

class DocTypeState extends State<DocType> {
  int matiereId;
  int classeId;
  TypeDocs typeDoc;
  bool isloading = true;

  PDFDocument lireDocument;

  DocTypeState(this.classeId, this.matiereId, this.typeDoc);

  List<Documents> documents;

  @override
  void initState() {
    super.initState();

    onLoad();
  }

  onLoad() async {
    try {
      documents =
          await Documents.getDocuments(classeId, matiereId, typeDoc.idtypedocs);
      setState(() {
        isloading = false;
      });
    } catch (e) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Nonetwork()),
      ).then((value) => onLoad());
    }
  }

  List<Widget> createListileDocument(BuildContext context) {
    List<Widget> widgets = [];
    for (Documents document in documents) {
      List<Card> notion = document.notions
          .split(';') // split the text into an array
          .map(
            (String text) => Card(
                margin:
                    EdgeInsets.only(left: 0, right: 1.6, bottom: 1.6, top: 1.6),
                color: Theme.of(context).primaryColor,
                elevation: 2.1,
                child: Container(
                  color: Colors.grey[300],
                  margin: EdgeInsets.only(left: 1.6, right: 1.6),
                  padding: EdgeInsets.all(1.2),
                  child: Text(
                    text,
                    style: TextStyle(fontSize: 11),
                  ),
                )),
          ) // put the text inside a widget
          .toList();
      widgets.add(Card(
          color: Theme.of(context).primaryColor,
          margin: EdgeInsets.all(0.0),
          child: Container(
              margin: EdgeInsets.only(top: 1.0),
              color: Colors.white,
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      document.nomDocument,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            margin: EdgeInsets.symmetric(vertical: 12.0),
                            height: 18.0,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: notion,
                            )),
                      ],
                    ),
                    //trailing: Text(document.yearPub.toString()),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        document.statut == true
                            ? Icon(
                                Icons.monetization_on_outlined,
                                size: 21,
                                color: Colors.amber,
                              )
                            : Icon(
                                Icons.picture_as_pdf,
                                size: 21,
                                color: Theme.of(context).primaryColor,
                              ),
                        Text(
                          document.pathAnswer != null ? "Corrigé" : '',
                          style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).accentColor),
                        ),
                        Text(document.yearPub.toString()),
                      ],
                    ),
                    onTap: () {
                      document.statut == true
                          ? showDialog(
                                  context: context,
                                  builder: (context) => AlertePayement()) ??
                              false
                          : Navigator.push(
                              context,
                              ScaleRoute(
                                  page: new ReadPDF(document.path,
                                      document.pathAnswer, "Voir le corrigé")));
                    },
                  ),
                ],
              ))));
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage('images/fond_light.png'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.4), BlendMode.dstATop),
        )),
        child: Builder(
          builder: (BuildContext context) {
            return SingleChildScrollView(
              child: isloading
                  ? new Center(
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        new Container(
                          padding: new EdgeInsets.all(3.0),
                          child: LinearProgressIndicator(),
                        )
                      ],
                    ))
                  : new Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Chip(
                          avatar: CircleAvatar(
                            backgroundColor: Theme.of(context).primaryColor,
                            child: Text(
                                '${createListileDocument(context).length}'),
                          ),
                          label: Text('documents'),
                        ),
                        Column(
                          children: createListileDocument(context),
                        ),
                      ],
                    ),
            );
          },
        ));
  }
}
