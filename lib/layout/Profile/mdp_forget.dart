import 'dart:convert';

import 'package:academia/Components/custom_snack.dart';
import 'package:academia/Components/handleError.dart';
import 'package:academia/HttpRequest/profilerequest.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class MdpForget extends StatefulWidget {
  MdpForgetState createState() => new MdpForgetState();
}

class MdpForgetState extends State<MdpForget> {
  final _keyForm = GlobalKey<FormState>();
  String _email = ' ';
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: new Text('Mot de passe oublié'),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return new Center(
            child: SingleChildScrollView(
              child: Form(
                key: _keyForm,
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new Container(
                        child: Image(
                      image: AssetImage('images/ic_academia.png'),
                      width: 210,
                      height: 120,
                    )),
                    Card(
                      color: Theme.of(context).primaryColor,
                      child: Container(
                        margin: EdgeInsets.only(top: 3.0),
                        color: Colors.white,
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 3.0, bottom: 6.0),
                              child: Text(
                                "Nous vous enverrons un lien de modification par mail.",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 3.0, bottom: 6.0),
                              child: new TextFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Entrez votre mail...",
                                  prefixIcon: Icon(Icons.mail),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator: (val) =>
                                    EmailValidator.validate(_email) != true
                                        ? 'Mail invalide'
                                        : null,
                                onChanged: (val) => _email = val,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RaisedButton(
                            onPressed: () {
                              if (_keyForm.currentState.validate()) {
                                connexionClick(context, _email);
                              }
                            },
                            child: Row(
                              children: [
                                Text(
                                  "Recevoir le lien",
                                ),
                              ],
                            )),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> connexionClick(BuildContext context, String email) async {
    try {
      var response = await Profile.resetpassword(email);
      var jsonResponse = jsonDecode(response.toString());
      var custom = new CustomSnack(jsonResponse['message'], "success");
      Scaffold.of(context).showSnackBar(new SnackBar(
        content: custom.getText(),
      ));
    } catch (e) {
      HandleError.buildError(context, e, _scaffoldKey);
    }
  }
}
