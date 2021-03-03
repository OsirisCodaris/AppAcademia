import 'package:academia/Components/chargement.dart';
import 'package:academia/Components/handleError.dart';
import 'package:academia/Components/transitionLeft.dart';
import 'package:academia/HttpRequest/notificationrequest.dart';
import 'package:academia/HttpRequest/profilerequest.dart';
import 'package:academia/LocalRequest/localDatabase.dart';

import 'package:academia/layout/log_sign.dart';
import 'package:academia/models/user.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:flutter/src/widgets/text.dart';

class Profil extends StatefulWidget {
  ProfilState createState() => new ProfilState();
}

class ProfilState extends State<Profil> {
  bool isLoading = true;
  User user;
  String _nomComplet;
  String _phone;
  String _email;
  String _btnModification = 'Activer modification';
  bool userProf = true;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
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
      user = User.fromJson(queryRows[0]);
      setState(() {
        isLoading = false;
        _nomComplet = user.fullname;
        _phone = user.phone;
        _email = user.email;
        if (user.role == "STUDENT") {
          userProf = false;
        }
      });
    } catch (e) {}
  }

  final _keyForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
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
                        await NotificationRequest.destroy();
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
                                hintText: user.fullname,
                                prefixIcon: Icon(Icons.perm_identity),
                              ),
                              initialValue: user.fullname,
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
                                hintText: user.phone,
                                prefixIcon: Icon(Icons.phone_android),
                              ),
                              initialValue: user.phone,
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
                                hintText: user.email,
                                prefixIcon: Icon(Icons.mail_outline),
                              ),
                              initialValue: user.email,
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
      var type = user.role == "STUDENT" ? 'students' : 'teachers';
      await Profile.update(user.idusers, name, phone, email, type);
      user.fullname = name;
      user.phone = phone;
      user.email = email;
      await DatabaseHelper.instance.updateUser(user);
      Scaffold.of(context).showSnackBar(new SnackBar(
          content:
              new Text("modification effectuée", textAlign: TextAlign.center)));
    } catch (e) {
      HandleError.buildError(context, e, _scaffoldKey);
    }
  }
}
