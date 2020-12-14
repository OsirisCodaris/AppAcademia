import 'dart:math';
import 'package:academia/Components/alerteDialogue.dart';
import 'package:academia/Components/transitionLeft.dart';
import 'package:academia/HttpRequest/document.dart';
import 'package:academia/read_pdf.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../HttpRequest/document.dart';

class DocPopulaire extends StatefulWidget {
  List<Documents> list_doc = [];
  DocPopulaire(this.list_doc) {}
  @override
  _DocPopulaireState createState() => _DocPopulaireState(list_doc);
}

class _DocPopulaireState extends State<DocPopulaire> {
  int _index = 0;
  List<Documents> listDoc = [];
  _DocPopulaireState(this.listDoc);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 153.0,
      child: listDoc.length > 0
          ? SizedBox(
              child: PageView.builder(
                itemCount: listDoc.length,
                controller: PageController(viewportFraction: 0.6),
                onPageChanged: (int index) => setState(() => _index = index),
                itemBuilder: (_, i) {
                  return Transform.scale(
                      scale: i == _index ? 1.0 : 0.8,
                      child: GestureDetector(
                        onTap: () {
                          listDoc[i].statut == true
                              ? showDialog(
                                      context: context,
                                      builder: (context) => AlertePayement()) ??
                                  false
                              : Navigator.push(
                                  context,
                                  ScaleRoute(
                                      page: ReadPDF(
                                          listDoc[i].path,
                                          listDoc[i].pathAnswer,
                                          "Voir le corrigé")));
                        },
                        child: Column(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Card(
                                color: Colors.primaries[
                                    Random().nextInt(Colors.primaries.length)],
                                elevation: 6,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(9)),
                                child: Container(
                                    margin:
                                        EdgeInsets.only(top: 9.0, bottom: 9.0),
                                    color: Colors.white,
                                    child: Center(
                                        child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        listDoc[i].statut == true
                                            ? Column(
                                                children: [
                                                  Text("Payant",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.amber)),
                                                  Icon(
                                                    Icons.picture_as_pdf,
                                                    size: 36,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                ],
                                              )
                                            : Icon(
                                                Icons.picture_as_pdf,
                                                size: 36,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                        Text(
                                          listDoc[i].pathAnswer != null
                                              ? "Corrigé"
                                              : '',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Theme.of(context)
                                                  .accentColor),
                                        ),
                                        Text("${listDoc[i].yearPub}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2)
                                      ],
                                    ))),
                              ),
                            ),
                            Text("${listDoc[i].nomDocument}",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ));
                },
              ),
            )
          : Center(
              child: Text("Pas de documents proposés..."),
            ),
    );
  }
}
