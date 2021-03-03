import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

// Class des cartes pour la liste des matières et classes

class CustomCardend {
  dynamic eltcard;

  CustomCardend(dynamic eltcard) {
    this.eltcard = eltcard;
  }

  Container getCardEnd() {
    return new Container(
      height: 108,
      width: double.infinity,
      margin: EdgeInsets.only(left: 18.0, right: 18.0),
      child: eltcard,
    );
  }
}
//fin design card matière et classes

//design documentation générale
class CustomCard {
  double nbrPourcent;
  double pourcentage;
  String nomElement;
  int nbrDoc;
  int nbrCorr;
  bool isDocument;

  CustomCard(this.nbrPourcent, this.pourcentage, this.nomElement, this.nbrDoc,
      this.nbrCorr, this.isDocument);

  Container getCard() {
    return new Container(
      color: Colors.white,
      margin: EdgeInsets.only(left: 3.0, right: 3.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
                child: Column(
              children: [
                Expanded(
                    flex: 1,
                    child: CircularPercentIndicator(
                      radius: 60.0,
                      lineWidth: 3.0,
                      percent: nbrPourcent,
                      center: new Text("${pourcentage.truncate()} %"),
                      progressColor: Colors.green,
                    ))
              ],
            )),
          ),
          Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(nomElement,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      )),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: isDocument
                              ? 'Documents :'
                              : 'Questions : ', // default text style
                          children: <TextSpan>[
                            TextSpan(
                                text: ' ' + nbrDoc.toString(),
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          text: isDocument
                              ? 'Corrigés :'
                              : 'Résolus :', // default text style
                          children: <TextSpan>[
                            TextSpan(
                                text: ' ' + nbrCorr.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
//fin documentation générale

//Design Composantes du contenant
class AccueilComposantsMiddle {
  String titreList;
  AccueilComposantsMiddle(String titreList) {
    this.titreList = titreList;
  }

  Container textMiddle(BuildContext context) {
    return new Container(
      child: Text(
        titreList,
        style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
        textAlign: TextAlign.left,
      ),
    );
  }
}

class AccueilComposantsTop {
  Container textTop(BuildContext context) {
    return new Container(
      child: Text(
        'Documents Populaires',
        style: Theme.of(context).textTheme.headline2,
        textAlign: TextAlign.left,
      ),
    );
  }
}

class AccueilTextAppBar {
  Text textAppBar(BuildContext context) {
    return new Text('Academia');
  }
}
