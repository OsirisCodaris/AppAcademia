import 'package:academia/HttpRequest/classe.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multiselect/flutter_multiselect.dart';
import 'Components/custom_snack.dart';
import 'HttpRequest/auth.dart';
import 'HttpRequest/matiere.dart';
import 'Components/chargement.dart';
import 'form_log.dart';
import 'dart:convert' as convert;

import 'nonetwork.dart';

// ignore: must_be_immutable
class InscriptionProf extends StatefulWidget {
  String nomComplet;
  String phone;
  String email;
  String password;

  InscriptionProf(this.nomComplet, this.phone, this.email, this.password);

  InscriptionProfState createState() => new InscriptionProfState(
      this.nomComplet, this.phone, this.email, this.password);
}

class InscriptionProfState extends State<InscriptionProf> {
  String nomComplet;
  String phone;
  String email;
  String password;
  String phone2;

  List<Matieres> matieres;
  List<Classes> classes;

  var data; //Pour récupérer les classes à afficher dans le multiSelecte

  var listVille = [
    "Choisir votre ville",
    'Libreville',
    'Akanda',
    'Franceville',
    'Moanda',
    'Port-Gentil',
    'Oyem',
    'Makokou',
    'Koulamoutou',
    'Lastourville',
    'Essassa',
    'Bikélé',
    'Ntoum',
    'Owendo',
    'Lambaréné',
    'Mouila',
    'Tchibanga'
  ];

  String selectedClasseString = '';
  bool isLoading = true;

  Matieres selectedMatiere;

  String selectedVille = "Choisir votre ville";

  final _formKey = GlobalKey<FormState>();

  List _myActivities;
  String _myActivitiesResult;

  InscriptionProfState(this.nomComplet, this.phone, this.email, this.password);

  @override
  void initState() {
    super.initState();
    _myActivities = [];
    _myActivitiesResult = '';
    onLoad();
  }

  onLoad() async {
    try {
      matieres = await Matieres.getMatiere();
      selectedMatiere = matieres[0];
      classes = await Classes.getClasses();
      data = classes.map((user) => user.toJson()).toList();
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

  List<Widget> createRadioListMatieres() {
    List<Widget> widgets = [];

    widgets.add(new Card(
        color: Theme.of(context).primaryColor,
        margin: EdgeInsets.all(12.0),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 9, vertical: 3),
          margin: EdgeInsets.only(top: 3.0),
          color: Colors.white,
          width: 300,
          child: DropdownButtonHideUnderline(
            child: new DropdownButton<Matieres>(
              isExpanded: true,
              value: selectedMatiere,
              isDense: true,
              icon: Icon(
                Icons.arrow_drop_down,
                color: Theme.of(context).primaryColor,
              ),
              iconSize: 36,
              elevation: 16,
              style: TextStyle(color: Colors.black, fontSize: 18),
              dropdownColor: Colors.white,
              onChanged: (Matieres newValue) {
                setState(() {
                  selectedMatiere = newValue;
                });
              },
              items: matieres.map((Matieres map) {
                return new DropdownMenuItem<Matieres>(
                  value: map,
                  child: new Text(map.name),
                );
              }).toList(),
            ),
          ),
        )));

    widgets.add(new Card(
        color: Theme.of(context).primaryColor,
        margin: EdgeInsets.all(12.0),
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 9, vertical: 3),
            margin: EdgeInsets.only(top: 3.0),
            color: Colors.white,
            width: 300,
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedVille,
              icon: Icon(
                Icons.arrow_drop_down,
                color: Theme.of(context).primaryColor,
              ),
              iconSize: 36,
              elevation: 16,
              style: Theme.of(context).textTheme.bodyText1,
              dropdownColor: Colors.white,
              onChanged: (String newValue) {
                setState(() {
                  selectedVille = newValue;
                });
              },
              items: listVille.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ))));

    widgets.add(
      Container(
        margin: EdgeInsets.all(12.0),
        constraints: BoxConstraints.tight(const Size(300, 50)),
        child: new TextFormField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Tapez un deuxième numéro",
          ),
          keyboardType: TextInputType.number,
          onChanged: (string) {
            setState(() {
              phone2 = string;
            });
          },
          validator: (value) {
            if (value.isEmpty) {
              return 'Vous n\'avez rien écrit !';
            }
            return null;
          },
        ),
      ),
    );

    widgets.add(new Card(
        color: Theme.of(context).primaryColor,
        margin: EdgeInsets.all(12.0),
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 9, vertical: 3),
            margin: EdgeInsets.only(top: 3.0),
            color: Colors.white,
            width: 300,
            child: MultiSelect(
              autovalidate: true,
              titleText: 'Classes enseignées',
              // maxLength: 5, // optional
              validator: (dynamic value) {
                if (value == null) {
                  return 'Vous n\'avez choisi aucune classe';
                }
                return null;
              },
              errorText: 'Veuillez choisir...',
              dataSource: data,
              textField: 'display',
              valueField: 'value',
              filterable: true,
              required: true,
              searchBoxHintText: 'Ecrire une classe ici...',
              selectIcon: Icons.arrow_drop_down,

              errorBorderColor: Colors.transparent,
              enabledBorderColor: Colors.green,

              saveButtonColor: Theme.of(context).primaryColor,
              saveButtonText: 'OK',
              saveButtonIcon: Icons.check_circle,

              cancelButtonText: 'Sortir',
              cancelButtonTextColor: Colors.deepOrange,

              clearButtonTextColor: Colors.yellow,
              clearButtonText: '.',
              clearButtonIcon: Icons.refresh,
              clearButtonColor: Colors.white10,

              selectedOptionsInfoText: '',

              hintText: 'Taper ici pour choisir...',

              checkBoxColor: Theme.of(context).primaryColor,

              onSaved: (value) {
                if (value == null) {
                } else {
                  setState(() {
                    _myActivities = value;
                  });
                }
              },
            ))));

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: new Text('Inscription 3/3'),
        ),
        body: Builder(
          builder: (BuildContext context) {
            return new Center(
                child: SingleChildScrollView(
              child: isLoading
                  ? ChargementClass()
                  : new Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          const Text.rich(
                            TextSpan(
                              style: TextStyle(
                                  fontSize: 21, color: Color(0xff5F8463)),
                              text: 'Vous êtes', // default text style
                              children: <TextSpan>[
                                TextSpan(
                                    text: ' Professeur',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          Divider(),
                          const Text.rich(
                            TextSpan(
                              style: TextStyle(
                                fontSize: 18,
                              ),
                              text: 'Choisissez votre', // default text style
                              children: <TextSpan>[
                                TextSpan(
                                    text: ' matière',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          Column(
                            children: createRadioListMatieres(),
                          ),
                          new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              new Container(
                                child: RaisedButton(
                                  onPressed: () {
                                    if (selectedMatiere == null) {
                                      erreurSelection(context);
                                    } else {
                                      _onFormSaved();
                                      _myActivitiesResult =
                                          _myActivities.toString();
                                      enregistreProf(
                                          context,
                                          nomComplet,
                                          phone,
                                          email,
                                          password,
                                          selectedMatiere,
                                          selectedVille,
                                          _myActivitiesResult,
                                          phone2);
                                    }
                                  },
                                  padding: EdgeInsets.only(right: 0, left: 6),
                                  child: Row(
                                    // Replace with a Row for horizontal icon + text
                                    children: <Widget>[
                                      Text(
                                        "Finir ",
                                        style: new TextStyle(fontSize: 15.0),
                                      ),
                                      Icon(Icons.check_circle,
                                          color: Colors.yellow, size: 21),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
            ));
          },
        ));
  }

  void _onFormSaved() {
    final FormState form = _formKey.currentState;
    form.save();
  }

  void erreurSelection(BuildContext context) {
    Scaffold.of(context).showSnackBar(
        new SnackBar(content: new Text("Vous n'avez choisie aucune matière")));
  }

  Future<void> enregistreProf(
      BuildContext context,
      String nomComplet,
      String phone,
      String email,
      String password,
      Matieres selectedMatiere,
      String selectedVille,
      String classesTeach,
      String phone2) async {
    try {
      var response = await Authentification.register(
          nomComplet,
          phone,
          email,
          password,
          selectedMatiere.idsubjects,
          'teachers',
          selectedVille,
          classesTeach,
          phone2);

      Scaffold.of(context)
          .showSnackBar(new SnackBar(content: new Text("done")));
      Navigator.push(context,
          new MaterialPageRoute(builder: (context) => new Connexion()));
    } catch (e) {
      if (e.type == DioErrorType.DEFAULT) {
        var custom = new CustomSnack(
            "Veuillez vérifier votre connexion Internet et réessayer.",
            "danger");
        Scaffold.of(context).showSnackBar(new SnackBar(
          content: custom.getText(),
        ));
      } else {
        var jsonResponse = convert.jsonDecode(e.response.toString());
        Scaffold.of(context).showSnackBar(new SnackBar(
            content:
                new Text(jsonResponse['error'], textAlign: TextAlign.center)));
      }
    }
  }
}
