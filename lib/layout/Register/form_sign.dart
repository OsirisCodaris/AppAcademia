import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'choix_user.dart';

class Inscription extends StatefulWidget {
  InscriptionState createState() => new InscriptionState();
}

class InscriptionState extends State<Inscription> {
  String _nomComplet;
  String _phone;
  String _email;
  String _password;
  String _confirmePassword;

  bool _showPassword = false;
  bool _showConfPassword = false;

  final _keyForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: new Text('Inscription 1/3'),
        ),
        body: Builder(
          builder: (BuildContext context) {
            return new Center(
                child: SingleChildScrollView(
              child: Form(
                key: _keyForm,
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
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Ecrire votre Nom et Prénom",
                          prefixIcon: Icon(Icons.perm_identity),
                        ),
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
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Ecrire votre numéro de téléphone",
                          prefixIcon: Icon(Icons.phone_android),
                        ),
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
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Ecrire votre adresse m@il",
                          prefixIcon: Icon(Icons.mail_outline),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) =>
                            EmailValidator.validate(_email) != true
                                ? 'Mail invalide'
                                : null,
                        onChanged: (val) => _email = val,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(12.0),
                      child: new TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Ecrire un mot de passe",
                          prefixIcon: Icon(Icons.lock_open),
                          suffixIcon: IconButton(
                            icon: Icon(
                              this._showPassword
                                  ? Icons.remove_red_eye
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() =>
                                  this._showPassword = !this._showPassword);
                            },
                          ),
                        ),
                        obscureText: !this._showPassword,
                        validator: (val) => val.length < 8
                            ? 'Minimum 8 caractères pour le Mot de passe'
                            : null,
                        onChanged: (val) => _password = val,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(12.0),
                      child: new TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Confirmer le mot de passe",
                          prefixIcon: Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              this._showConfPassword
                                  ? Icons.remove_red_eye
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() => this._showConfPassword =
                                  !this._showConfPassword);
                            },
                          ),
                        ),
                        obscureText: !this._showConfPassword,
                        onChanged: (val) => _confirmePassword = val,
                        validator: (val) => _confirmePassword != _password
                            ? 'Confirmation incorrecte'
                            : null,
                      ),
                    ),
                    new Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          new Container(
                            margin: EdgeInsets.only(right: 6.0),
                            child: new RaisedButton(
                              padding: EdgeInsets.only(right: 0, left: 12),
                              onPressed: () {
                                if (_keyForm.currentState.validate()) {
                                  Navigator.push(
                                      context,
                                      new PageRouteBuilder(
                                          pageBuilder: (context, animation,
                                                  secondaryAnimation) =>
                                              new InscriptionSuiv(_nomComplet,
                                                  _phone, _email, _password)));
                                }
                              },
                              child: Row(
                                // Replace with a Row for horizontal icon + text
                                children: <Widget>[
                                  Text(
                                    "Continuer",
                                    style: new TextStyle(fontSize: 12.0),
                                  ),
                                  Icon(Icons.navigate_next,
                                      color: Colors.yellow, size: 36),
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
}
