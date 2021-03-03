import 'package:academia/Components/alerteDialogue.dart';
import 'package:academia/Components/chargement.dart';
import 'package:academia/Components/fontImage.dart';
import 'package:academia/Components/handleError.dart';
import 'package:academia/Components/typedocDesign.dart';
import 'package:academia/HttpRequest/documentrequest.dart';
import 'package:academia/models/documents.dart';
import 'package:academia/models/typedocs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';

class DocType extends StatefulWidget {
  int matiereId;
  int classeId;
  Typedocs typeDoc;

  DocType(this.classeId, this.matiereId, this.typeDoc);

  DocTypeState createState() =>
      new DocTypeState(this.classeId, matiereId, typeDoc);
}

class DocTypeState extends State<DocType> {
  int matiereId;
  int classeId;
  Typedocs typeDoc;
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
      documents = await DocumentRequest.getDocuments(
          classeId, matiereId, typeDoc.idtypedocs);
      setState(() {
        isloading = false;
      });
    } catch (e) {
      HandleError.buildError(context, e).then((r) {
        return onLoad();
      });
    }
  }

  List<Widget> createListileDocument(BuildContext context) {
    List<Widget> widgets = [];
    for (Documents document in documents) {
      //appel de la class Card customisée notions
      var listnotion = NotionCard(document.notions);
      List<Card> notion = listnotion.getNotionCard();

      //appel de la class Card customisée listdoc
      var listInterDoc = InterCard(document.status, document.pathfile,
          document.pathAnswer, document.year, notion, document.name);

      widgets.add(listInterDoc.interCard(context));
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        decoration: DecoFontImage().fontClair(), //background
        child: isloading
            ? PageChargement()
            : Builder(
                builder: (BuildContext context) {
                  var contenantlist = Contientypedoc(
                      createListileDocument(context),
                      createListileDocument(context).length);
                  return SingleChildScrollView(
                      child: contenantlist.build(context));
                },
              ));
  }
}
