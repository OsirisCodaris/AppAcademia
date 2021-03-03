import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ViewImage extends StatefulWidget {
  String url;
  ViewImage(this.url);
  @override
  _ViewImageState createState() => _ViewImageState(this.url);
}

class _ViewImageState extends State<ViewImage> {
  String url;
  _ViewImageState(this.url);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: InteractiveViewer(
      panEnabled: true,
      child: new Image.network(this.url,
          fit: BoxFit.contain,
          height: double.infinity,
          width: double.infinity,
          alignment: Alignment.center, errorBuilder:
              (BuildContext context, Object exception, StackTrace stackTrace) {
        return Container(
            child: Center(
                child:
                    Text("L'image a été supprimé ou n'est plus disponible")));
      }),
    ));
  }
}
