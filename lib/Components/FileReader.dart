import 'package:academia/Components/transitionLeft.dart';
import 'package:academia/layout/read_pdf.dart';
import 'package:academia/layout/viewImage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FileReader extends StatefulWidget {
  String url;
  FileReader(this.url);
  @override
  _FileReaderState createState() => _FileReaderState(this.url);
}

class _FileReaderState extends State<FileReader> {
  String url;
  _FileReaderState(this.url);

  final RegExp imageReg =
      new RegExp(r'([/|.|\w|\s|-|:])*\.(?:jpg|JPG|jpeg|JPEG|gif|GIF|png|PNG)');
  final RegExp pdfReg = new RegExp(r'([/|.|\w|\s|-])*\.(?:pdf|PDF)');

  Widget ImageView(BuildContext context) {
    return GestureDetector(
      child: Card(
        child: Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              border:
                  Border.all(color: Theme.of(context).primaryColor, width: 0.5),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(this.url),
              ),
            ),
            child: Center(
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Theme.of(context).primaryColor)),
                child: Text(
                  'Voir',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.transparent,
                onPressed: () {
                  Navigator.push(
                      context,
                      new PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  new ViewImage(this.url)));
                },
              ),
            )),
      ),
      onTap: () {
        Navigator.push(
            context,
            new PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    new ViewImage(this.url)));
      },
    );
  }

  Widget PdfView(BuildContext context, String fileName) {
    return Container(
        color: Colors.transparent,
        child: Center(
          child: RaisedButton(
            color: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Theme.of(context).primaryColor)),
            child: Row(
              children: [
                Icon(
                  Icons.attach_file,
                  color: Theme.of(context).primaryColor,
                ),
                Text(
                  'Fichier joint - voir',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                )
              ],
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  new ScaleRoute(
                      page: new ReadPDF(this.url, null, 'forum document')));
            },
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    String fileName = url?.split('/')?.last ?? null;

    final isImage = imageReg.hasMatch(url);
    final isPDF = pdfReg.hasMatch(url);
    if (isImage) {
      return ImageView(context);
    } else if (isPDF) {
      return PdfView(context, fileName);
    } else if (fileName == '' ||
        fileName.isEmpty ||
        fileName == null ||
        fileName == 'null') {
      return SizedBox(height: 0.3);
    } else {
      return Text('Fichier inconnu $fileName');
    }
  }
}
