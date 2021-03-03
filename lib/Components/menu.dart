import 'package:academia/layout/Documentation/documentation.dart';
import 'package:academia/layout/Forum/forum.dart';
import 'package:academia/layout/Profile/profil_user.dart';
import 'package:academia/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Menu extends StatefulWidget {
  User user;
  String moduleName;
  Menu(this.user, this.moduleName);

  @override
  _MenuState createState() => _MenuState(user, moduleName);
}

class _MenuState extends State<Menu> {
  User currentUser;
  bool isLoading;
  List<Map<String, dynamic>> queryRows;
  String moduleName;
  _MenuState(this.currentUser, this.moduleName);

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
                        title: Text(currentUser.fullname),
                        subtitle: Text(moduleName),
                      ),
                    ],
                  )),
            ),
            ListTile(
              leading: Icon(
                Icons.book,
                color: Theme.of(context).primaryColor,
              ),
              title: Text('Documentation'),
              onTap: () {
                Navigator.push(
                    context,
                    PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            new Documentation()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.chat_bubble,
                color: Theme.of(context).primaryColor,
              ),
              title: Text('Forum'),
              onTap: () {
                Navigator.push(
                    context,
                    PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            new Forum()));
              },
            ),
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
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            new Profil()));
              },
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
