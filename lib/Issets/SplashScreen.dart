import 'package:flutter/material.dart';
import 'package:academia/log_sign.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/dot_animation_enum.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';

class IntroScreen extends StatefulWidget {
  IntroScreen({Key key}) : super(key: key);

  @override
  IntroScreenState createState() => new IntroScreenState();
}

class IntroScreenState extends State<IntroScreen> {
  List<Slide> slides = new List();

  Function goToTab;

  @override
  void initState() {
    super.initState();

    slides.add(
      new Slide(
        title: "Banque Académique du Gabon",
        styleTitle: TextStyle(
            color: Colors.green,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'RobotoMono'),
        description:
            "Explorez une application riche en ressources pédagogiques",
        styleDescription: TextStyle(
            color: Colors.black,
            fontSize: 20.0,
            fontStyle: FontStyle.italic,
            fontFamily: 'Raleway'),
        pathImage: "images/bank_academia.png",
      ),
    );
    slides.add(
      new Slide(
        title: "De la 3ème en Terminale",
        styleTitle: TextStyle(
            color: Colors.green,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'RobotoMono'),
        description:
            "Découvrez des fiches de cours, sujets d'examen, devoirs de classe, ainsi que leurs corrigés.",
        styleDescription: TextStyle(
            color: Colors.black,
            fontSize: 20.0,
            fontStyle: FontStyle.italic,
            fontFamily: 'Raleway'),
        pathImage: "images/doc_academia.png",
      ),
    );
    slides.add(
      new Slide(
        title: "MBOLO !",
        styleTitle: TextStyle(
            color: Colors.green,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'RobotoMono'),
        description: "Bonne expérience académique !",
        styleDescription: TextStyle(
            color: Colors.black,
            fontSize: 20.0,
            fontStyle: FontStyle.italic,
            fontFamily: 'Raleway'),
        pathImage: "images/logo_slogan.png",
      ),
    );
  }

  void onDonePress() {
    Navigator.push(
        context, new MaterialPageRoute(builder: (context) => new ChoixLog()));
    // Back to the first tab
    //this.goToTab(0);
  }

  void onTabChangeCompleted(index) {
    // Index of current tab is focused
  }

  Widget renderNextBtn() {
    return Icon(
      Icons.navigate_next,
      color: Color(0xff5F8463),
      size: 35.0,
    );
  }

  Widget renderDoneBtn() {
    return Icon(
      Icons.done,
      color: Colors.black,
    );
  }

  Widget renderSkipBtn() {
    return Icon(
      Icons.skip_next,
      color: Colors.white,
    );
  }

  List<Widget> renderListCustomTabs() {
    List<Widget> tabs = new List();
    for (int i = 0; i < slides.length; i++) {
      Slide currentSlide = slides[i];
      tabs.add(Container(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(bottom: 60.0, top: 60.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    child: Text(
                      currentSlide.title,
                      style: currentSlide.styleTitle,
                      textAlign: TextAlign.center,
                    ),
                    margin: EdgeInsets.only(top: 20.0),
                  ),
                  Container(
                    child: Text(
                      currentSlide.description,
                      style: currentSlide.styleDescription,
                      textAlign: TextAlign.center,
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                    ),
                    margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
                  ),
                  GestureDetector(
                      child: Image.asset(
                    currentSlide.pathImage,
                    fit: BoxFit.contain,
                  )),
                ],
              ),
            ),
          )));
    }
    return tabs;
  }

  @override
  Widget build(BuildContext context) {
    return new IntroSlider(
      // List slides
      slides: this.slides,

      // Skip button
      renderSkipBtn: this.renderSkipBtn(),
      colorSkipBtn: Color(0xff5F8463),
      highlightColorSkipBtn: Colors.white,

      // Next button
      renderNextBtn: this.renderNextBtn(),

      // Done button
      renderDoneBtn: this.renderDoneBtn(),
      onDonePress: this.onDonePress,
      colorDoneBtn: Color(0x33ffcc5c),
      highlightColorDoneBtn: Colors.green,

      // Dot indicator
      colorDot: Color(0xff5F8463),
      sizeDot: 13.0,
      typeDotAnimation: dotSliderAnimation.SIZE_TRANSITION,

      // Tabs
      listCustomTabs: this.renderListCustomTabs(),
      backgroundColorAllSlides: Colors.white,
      refFuncGoToTab: (refFunc) {
        this.goToTab = refFunc;
      },

      // Show or hide status bar
      shouldHideStatusBar: true,

      // On tab change completed
      onTabChangeCompleted: this.onTabChangeCompleted,
    );
  }
}
