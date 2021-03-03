import 'package:academia/Components/chargement.dart';
import 'package:academia/Components/handleError.dart';
import 'package:academia/Components/transitionLeft.dart';
import 'package:academia/HttpRequest/Api.dart';
import 'package:academia/LocalRequest/localDatabase.dart';
import 'package:academia/models/user.dart';
import 'package:flutter/material.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';

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
  User currentUser;
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
    try {
      if (urlToAction != null) {
        existCorrige = true;
      }
      var queryRows = await DatabaseHelper.instance.user();
      currentUser = User.fromJson(queryRows[0]);
      Map<String, String> headers = {
        "Authorization": "Bearer " + currentUser.refreshToken,
      };
      document = await PDFDocument.fromURL(urlToRead, headers: headers);

      setState(() => _isLoading = false);
    } catch (e) {
      HandleError.buildError(context, e).then((r) {
        return loadDocument(urlToRead);
      });
    }
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
