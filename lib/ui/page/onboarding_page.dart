import 'package:flutter/material.dart';

import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:isk_aps_calc/constants.dart';

import 'package:isk_aps_calc/ui/page/login_page.dart';

class OnBoardingPage extends StatefulWidget {
  static String tag = '/onboarding';

  @override
  OnBoardingPageState createState() => new OnBoardingPageState();
}

class OnBoardingPageState extends State<OnBoardingPage> {
  List<Slide> slides = new List();

  @override
  void initState() {
    super.initState();
    slides.add(
      new Slide(
        pathImage: 'assets/images/onboarding_1.png',
        backgroundColor: Color.fromRGBO(255, 255, 255, 1.0),
        widthImage: 320.0,
        heightImage: 352.0,
      ),
    );
    slides.add(
      new Slide(
        pathImage: 'assets/images/onboarding_2.png',
        backgroundColor: Color.fromRGBO(255, 255, 255, 1.0),
        widthImage: 320.0,
        heightImage: 352.0,
      ),
    );
    slides.add(
      new Slide(
        pathImage: 'assets/images/onboarding_3.png',
        backgroundColor: Color.fromRGBO(255, 255, 255, 1.0),
        widthImage: 320.0,
        heightImage: 352.0,
      ),
    );
  }

  @override
  Widget build(context) {
    return new IntroSlider(
      slides: this.slides,
      onDonePress: () {
        Navigator.of(context).pushReplacementNamed(LoginPage.tag);
      },
      colorSkipBtn: Color.fromRGBO(255, 255, 255, 1.0),
      styleNameSkipBtn: TextStyle(color: Color.fromRGBO(255, 0, 0, 1.0)),
      colorDoneBtn: Color.fromRGBO(255, 0, 0, 1.0),
      styleNameDoneBtn: TextStyle(
        color: Color.fromRGBO(255, 255, 255, 1.0),
      ),
    );
  }
}
