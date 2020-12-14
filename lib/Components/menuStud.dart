import 'package:academia/Issets/profil_user.dart';
import 'package:academia/LocalRequest/localDatabase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'chargement.dart';

class MenuStud extends StatefulWidget {
  String userInfo;
  MenuStud(String userInfo) {
    this.userInfo = userInfo;
  }

  @override
  _MenuStudState createState() => _MenuStudState(userInfo);
}

class _MenuStudState extends State<MenuStud> {
  bool isLoading = true;
  List<Map<String, dynamic>> queryRows;
  String userInfo;
  _MenuStudState(String userInfo) {
    this.userInfo = userInfo;
  }

  @override
  void initState() {
    super.initState();
    onLoad();
  }

  onLoad() async {
    queryRows = await DatabaseHelper.instance.user();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
        width: size.width * 0.81,
        child: Drawer(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                margin: EdgeInsets.only(left: 3.0),
                // ignore: missing_required_param
                child: DrawerHeader(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("images/ic_academia.png"),
                          fit: BoxFit.contain)),
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.only(top: 0.0),
              color: Theme.of(context).primaryColor,
              child: Container(
                  color: Colors.white,
                  margin: EdgeInsets.only(bottom: 3.0),
                  child: Column(
                    children: [
                      ListTile(
                        title: isLoading
                            ? ChargementClass()
                            : Text(queryRows[0]["fullname"]),
                        subtitle:
                            isLoading ? ChargementClass() : Text(userInfo),
                      ),
                    ],
                  )),
            ),
            Expanded(
              flex: 2,
              child: ListView(
                padding: EdgeInsets.all(3.0),
                children: <Widget>[
                  ListTile(
                    leading: Icon(
                      Icons.account_circle,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: Text('Mon profil'),
                    onTap: () {
                      Navigator.push(
                          context,
                          PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      new Profil()));
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text.rich(
                    TextSpan(
                      style: TextStyle(),
                      text: 'conçue par', // default text style
                      children: <TextSpan>[
                        TextSpan(
                            text: ' Codaris',
                            style: TextStyle(
                                color: Theme.of(context).accentColor,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        )));
  }
}
