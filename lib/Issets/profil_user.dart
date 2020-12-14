import 'dart:convert';

import 'package:academia/Components/chargement.dart';
import 'package:academia/Components/custom_snack.dart';
import 'package:academia/Components/transitionLeft.dart';
import 'package:academia/HttpRequest/profile.dart';
import 'package:academia/LocalRequest/localDatabase.dart';
import 'package:academia/all_classe_subject.dart';
import 'package:academia/all_subject.dart';
import 'package:academia/log_sign.dart';
import 'package:dio/dio.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:flutter/src/widgets/text.dart';

import '../user.dart';

class Profil extends StatefulWidget {
  ProfilState createState() => new ProfilState();
}

class ProfilState extends State<Profil> {
  bool isLoading = true;

  String _nomComplet;
  String _phone;
  String _email;
  String _btnModification = 'Activer modification';
  bool userProf = true;

  bool _modifierProfile = false;
  List<Map<String, dynamic>> queryRows;
  @override
  void initState() {
    super.initState();
    onLoad();
  }

  onLoad() async {
    try {
      queryRows = await DatabaseHelper.instance.user();
      setState(() {
        isLoading = false;
        _nomComplet = queryRows[0]['fullname'];
        _phone = queryRows[0]['phone'];
        _email = queryRows[0]['email'];
        if (queryRows[0]["role"] == "STUDENT") {
          userProf = false;
        }
      });
    } catch (e) {}
  }

  final _keyForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: new Text('Mon Profil'),
            centerTitle: false,
            actions: <Widget>[
              new PopupMenuButton(
                icon: Icon(Icons.more_vert),
                itemBuilder: (_) => <PopupMenuItem<String>>[
                  new PopupMenuItem<String>(
                    child: ListTile(
                      title: Text('Déconnexion',
                          style: TextStyle(color: Colors.grey)),
                      onTap: () async {
                        await DatabaseHelper.instance.deleteUser();
                        Navigator.push(context, ScaleRoute(page: ChoixLog()));
                      },
                    ),
                  )
                ],
              ),
            ]),
        body: isLoading
            ? ChargementClass()
            : Builder(
                builder: (BuildContext context) {
                  return new Center(
                      child: SingleChildScrollView(
                    child: Form(
                      key: _keyForm,
                      onWillPop: () {
                        Navigator.push(
                            context,
                            ScaleRoute(
                                page: userProf
                                    ? AllClasseSubject()
                                    : AllSubject()));
                      },
                      child: new Column(
                        children: <Widget>[
                          new Container(
                              child: Image(
                            image: AssetImage('images/ic_academia.png'),
                            width: 120,
                            height: 120,
                          )),
                          Container(
                            margin: EdgeInsets.all(12.0),
                            child: new TextFormField(
                              readOnly: !this._modifierProfile,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Votre nom complet",
                                hintText: '${queryRows[0]["fullname"]}',
                                prefixIcon: Icon(Icons.perm_identity),
                              ),
                              initialValue: '${queryRows[0]["fullname"]}',
                              keyboardType: TextInputType.name,
                              validator: (val) => val.isEmpty
                                  ? 'Le nom complet ne peut être vide'
                                  : null,
                              onChanged: (val) => _nomComplet = val,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(12.0),
                            child: new TextFormField(
                              readOnly: !this._modifierProfile,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Votre numéro de téléphone",
                                hintText: '${queryRows[0]["phone"]}',
                                prefixIcon: Icon(Icons.phone_android),
                              ),
                              initialValue: '${queryRows[0]["phone"]}',
                              keyboardType: TextInputType.number,
                              validator: (val) => val.isEmpty
                                  ? 'Vous devez entrer un numéro de téléphone'
                                  : null,
                              onChanged: (val) => _phone = val,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(12.0),
                            child: new TextFormField(
                              readOnly: !this._modifierProfile,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Votre adresse mail",
                                hintText: '${queryRows[0]["email"]}',
                                prefixIcon: Icon(Icons.mail_outline),
                              ),
                              initialValue: '${queryRows[0]["email"]}',
                              keyboardType: TextInputType.emailAddress,
                              validator: (val) =>
                                  EmailValidator.validate(_email) != true
                                      ? 'Mail invalide'
                                      : val.isEmpty
                                          ? 'Ecrivez une adresse mail'
                                          : null,
                              onChanged: (val) => _email = val,
                            ),
                          ),
                          new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                OutlineButton(
                                  child: Text(
                                    '$_btnModification',
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      this._modifierProfile =
                                          !this._modifierProfile;
                                      this._modifierProfile
                                          ? this._btnModification =
                                              'Désactiver modification'
                                          : this._btnModification =
                                              'Activer modification';
                                    });
                                  },
                                ),
                                new Container(
                                  child: new RaisedButton(
                                    padding:
                                        EdgeInsets.only(right: 0, left: 12),
                                    onPressed: () {
                                      if (_keyForm.currentState.validate() &&
                                          _modifierProfile) {
                                        updateClick(context, _nomComplet,
                                            _phone, _email);
                                      }
                                    },
                                    child: Row(
                                      // Replace with a Row for horizontal icon + text
                                      children: <Widget>[
                                        Text(
                                          "Valider",
                                          style: new TextStyle(fontSize: 12.0),
                                        ),
                                        Icon(
                                          Icons.check_circle,
                                          color: Colors.yellow,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ]),
                        ],
                      ),
                    ),
                  ));
                },
              ));
  }

  Future<void> updateClick(
      BuildContext context, String name, String phone, String email) async {
    try {
      var type = queryRows[0]["role"] == "STUDENT" ? 'students' : 'teachers';
      await Profile.update(queryRows[0]["id"], name, phone, email, type);
      var user = User(
        idusers: queryRows[0]["id"],
        fullname: name,
        phone: phone,
        email: email,
        module: queryRows[0]["module"],
        role: queryRows[0]["role"],
        token: queryRows[0]["token"],
        refreshToken: queryRows[0]["refreshToken"],
      );
      await DatabaseHelper.instance.updateUser(user);
      Scaffold.of(context).showSnackBar(new SnackBar(
          content:
              new Text("modification effectuée", textAlign: TextAlign.center)));
    } catch (e) {
      if (e.type == DioErrorType.DEFAULT) {
        var custom = new CustomSnack(
            "Veuillez vérifier votre connexion Internet et réessayer.",
            "danger");
        Scaffold.of(context).showSnackBar(new SnackBar(
          content: custom.getText(),
        ));
      } else {
        var jsonResponse = jsonDecode(e.response.toString());
        Scaffold.of(context).showSnackBar(new SnackBar(
            content:
                new Text(jsonResponse['error'], textAlign: TextAlign.center)));
      }
    }
  }
}
