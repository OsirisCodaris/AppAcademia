import 'package:academia/Components/custom_snack.dart';
import 'package:academia/HttpRequest/auth.dart';
import 'package:academia/LocalRequest/localDatabase.dart';
import 'package:academia/all_classe_subject.dart';
import 'package:academia/all_subject.dart';
import 'package:academia/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Components/chargement.dart';
import 'Issets/mdp_forget.dart';
import 'dart:convert' as convert;

import 'log_sign.dart';

class Connexion extends StatefulWidget {
  ConnexionState createState() => new ConnexionState();
}

class ConnexionState extends State<Connexion> {
  String _UserIdentite;
  String _password;
  bool isloading = false;
  bool _showPassword = false;

  final _keyForm = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => Navigator.push(context,
            new MaterialPageRoute(builder: (context) => new ChoixLog())),
        child: Scaffold(
          appBar: AppBar(
            title: new Text('Connexion'),
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
                          width: 210,
                          height: 150,
                        )),
                        Container(
                          margin: EdgeInsets.all(12.0),
                          constraints:
                              BoxConstraints.tight(const Size(300, 50)),
                          child: new TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "M@il ou Nom complet",
                              prefixIcon: Icon(Icons.perm_identity),
                            ),
                            keyboardType: TextInputType.text,
                            onChanged: (string) {
                              setState(() {
                                _UserIdentite = string;
                              });
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(12.0),
                          constraints:
                              BoxConstraints.tight(const Size(300, 50)),
                          child: new TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Mot de passe",
                              prefixIcon: Icon(Icons.lock),
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
                            onChanged: (string) {
                              setState(() {
                                _password = string;
                              });
                            },
                          ),
                        ),
                        RaisedButton(
                          onPressed: () {
                            if (_UserIdentite == null || _password == null) {
                              champVide(context);
                            } else {
                              connexionClick(context, _UserIdentite, _password);
                            }
                          },
                          child: new Text(
                            "Se connecter",
                          ),
                        ),
                        new Container(
                          margin: EdgeInsets.only(left: 111, right: 111),
                          child:
                              isloading ? new LinearProgressIndicator() : null,
                        ),
                        new Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              new Container(
                                  margin: EdgeInsets.only(right: 6.0),
                                  child: FlatButton(
                                    child: Text(
                                      'Mot de passe oublié ?',
                                      style: new TextStyle(fontSize: 12),
                                    ),
                                    padding: EdgeInsets.all(2),
                                    textColor: Colors.red[400],
                                    color: Colors.white,
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          new PageRouteBuilder(
                                              pageBuilder: (context, animation,
                                                      secondaryAnimation) =>
                                                  new MdpForget()));
                                    },
                                  )),
                            ]),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ));
  }

  Future<void> connexionClick(
      BuildContext context, String userIdentite, String password) async {
    String form =
        '{"fullname": "' + userIdentite + '","password": "' + password + '"}';
    try {
      setState(() {
        isloading = true;
      });
      var response =
          await Authentification.authentifier(userIdentite, password);

      var jsonResponse = convert.jsonDecode(response.toString());

      //Création du user local
      var user = User(
        idusers: jsonResponse["idusers"],
        fullname: jsonResponse["fullname"],
        phone: jsonResponse["phone"],
        email: jsonResponse["email"],
        module: jsonResponse["module"],
        role: jsonResponse["role"],
        token: jsonResponse["token"],
        refreshToken: jsonResponse["refreshToken"],
      );

      //On va tester si il y'a un user dans la bdd local
      List<Map<String, dynamic>> queryRows =
          await DatabaseHelper.instance.user();

      if (queryRows.length > 0) {
        //On delete le user existant pour enregistrer le nouveau
        await DatabaseHelper.instance.deleteUser();

        //On enregistre le nouveau
        await DatabaseHelper.instance.insertUser(user);

        if (jsonResponse["role"] == "STUDENT") {
          Navigator.push(
              context,
              new PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      new AllSubject()));
        } else {
          Navigator.push(
              context,
              new PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      new AllClasseSubject()));
        }
      } else {
        //On enregistre le nouveau
        await DatabaseHelper.instance.insertUser(user);

        if (jsonResponse["role"] == "STUDENT") {
          Navigator.push(
              context,
              new PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      new AllSubject()));
        } else {
          Navigator.push(
              context,
              new PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      new AllClasseSubject()));
        }
      }
    } catch (e) {
      setState(() {
        isloading = false;
      });
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
            content: new Text(jsonResponse['message'],
                textAlign: TextAlign.center)));
      }
    }
  }

  void champVide(BuildContext context) {
    var custom =
        new CustomSnack("Veuillez remplir tous les champs !", "warning");
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: custom.getText(),
    ));
  }
}
