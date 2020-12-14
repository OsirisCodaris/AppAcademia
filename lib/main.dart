import 'package:academia/Issets/SplashScreen.dart';
import 'package:academia/LocalRequest/localDatabase.dart';
import 'package:academia/all_classe_subject.dart';
import 'package:academia/all_subject.dart';
import 'package:flutter/material.dart';
import 'Components/chargement.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Academia',
      theme: new ThemeData(
        brightness: Brightness.light,
        primaryColor: Color(0xff5F8463),
        accentColor: Colors.green,
        iconTheme: IconThemeData(color: Colors.white),
        textTheme: TextTheme(
          subtitle1:
              TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
          subtitle2:
              TextStyle(color: Colors.black, fontStyle: FontStyle.italic),
          headline1: TextStyle(fontSize: 21, color: Color(0xff5F8463)),
          headline2: TextStyle(
              color: Colors.green, fontSize: 21, fontWeight: FontWeight.bold),
        ),
        appBarTheme: AppBarTheme(elevation: 9, centerTitle: true),
        floatingActionButtonTheme:
            FloatingActionButtonThemeData(backgroundColor: Color(0xff5F8463)),
        buttonTheme: ButtonThemeData(
            buttonColor: Color(0xff5F8463), textTheme: ButtonTextTheme.primary),
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.black87,
        ),
        tabBarTheme: TabBarTheme(
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
        ),
        cursorColor: Colors.green,
        indicatorColor: Colors.white,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool userExist = false;
  bool isLoading = true;
  bool userProf = true;
  List<Map<String, dynamic>> queryRows;

  @override
  void initState() {
    super.initState();
    onLoad();
  }

  onLoad() async {
    //On va tester si il y'a un user dans la bdd local
    DatabaseHelper.instance.user().then((queryRows) {
      if (queryRows.length > 0) {
        userExist = true;
        if (queryRows[0]["role"] == "STUDENT") {
          userProf = false;
        }
      }
      setState(() {
        isLoading = false;
      });
    }).catchError((e) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: isLoading
              ? ChargementClass()
              : userExist
                  ? userProf
                      ? AllClasseSubject()
                      : AllSubject()
                  : IntroScreen()),
    );
  }
}
