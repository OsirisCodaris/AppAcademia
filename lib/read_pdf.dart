import 'package:academia/Components/transitionLeft.dart';
import 'package:flutter/material.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'Components/chargement.dart';

class ReadPDF extends StatefulWidget {
  String urlToRead;
  String urlToAction;
  String action;

  ReadPDF(this.urlToRead, this.urlToAction, this.action);

  @override
  _MyAppState createState() => _MyAppState(urlToRead, urlToAction, action);
}

class _MyAppState extends State<ReadPDF> {
  bool _isLoading = true;
  PDFDocument document;

  String urlToRead;
  String urlToAction;
  String action = '';
  String newAction;

  bool existCorrige = false;

  _MyAppState(this.urlToRead, this.urlToAction, this.action);

  @override
  void initState() {
    super.initState();
    loadDocument(urlToRead);
  }

  loadDocument(String urlToRead) async {
    if (urlToAction != null) {
      existCorrige = true;
    }
    document = await PDFDocument.fromURL(urlToRead);

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black45,
          centerTitle: true,
          title: existCorrige
              ? action == "Voir le sujet"
                  ? Text(
                      "Correction",
                      style: TextStyle(color: Colors.white24),
                    )
                  : new OutlineButton(
                      onPressed: () {
                        newAction = "Voir le sujet";

                        Navigator.push(
                            context,
                            new ScaleRoute(
                                page: new ReadPDF(
                                    urlToAction, urlToRead, newAction)));
                      },
                      color: Theme.of(context).accentColor,
                      child: new Text(action),
                    )
              : Text(
                  "Correction en cours...",
                  style: TextStyle(color: Colors.white24),
                )),
      body: Center(
        child: _isLoading
            ? ChargementClass()
            : PDFViewer(
                document: document,
                zoomSteps: 1,
                lazyLoad: false,
                indicatorPosition: IndicatorPosition.bottomRight,
              ),
      ),
    );
  }
}
