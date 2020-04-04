import 'package:flutter/material.dart';

import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';

import 'package:isk_aps_calc/ui/page/login_page.dart';

class OnBoarding extends StatefulWidget {
  static String tag = '/onboarding';

  OnBoarding({Key key}) : super(key: key);

  @override
  OnBoardingState createState() => new OnBoardingState();
}

//------------------ Default config ------------------
class OnBoardingState extends State<OnBoarding> {
  List<Slide> slides = new List();

  @override
  void initState() {
    super.initState();

    slides.add(
      new Slide(
        title: 'Ini Test',
        description: '',
        styleTitle: TextStyle(
            color: Color.fromRGBO(0, 0, 0, 1.0),
            fontSize: 24,
            fontWeight: FontWeight.w500
        ),
        styleDescription: TextStyle(
            color: Color.fromRGBO(0, 0, 0, 1.0),
            fontSize: 18,
        ),
        pathImage: '',
        backgroundColor: Color.fromRGBO(255, 255, 255, 1.0),
      ),
    );
    slides.add(
      new Slide(
        title: 'Ini Juga Test',
        description: '',
        styleTitle: TextStyle(
            color: Color.fromRGBO(0, 0, 0, 1.0),
            fontSize: 24,
            fontWeight: FontWeight.w500
        ),
        styleDescription: TextStyle(
            color: Color.fromRGBO(0, 0, 0, 1.0),
            fontSize: 18,
        ),
        pathImage: '',
        backgroundColor: Color.fromRGBO(255, 255, 255, 1.0),
      ),
    );
    slides.add(
      new Slide(
        title: 'Ini Yang Terakhir',
        description:
        '',
        styleTitle: TextStyle(
            color: Color.fromRGBO(0, 0, 0, 1.0),
            fontSize: 24,
            fontWeight: FontWeight.w500
        ),
        styleDescription: TextStyle(
            color: Color.fromRGBO(0, 0, 0, 1.0),
            fontSize: 18,
        ),
        pathImage: '',
        backgroundColor: Color.fromRGBO(255, 255, 255, 1.0),
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
      styleNameSkipBtn: TextStyle(
          color: Color.fromRGBO(255, 0, 0, 1.0)
      ),
      colorDoneBtn: Color.fromRGBO(255, 0, 0, 1.0),
      styleNameDoneBtn: TextStyle(
        color: Color.fromRGBO(255, 255, 255, 1.0),
      ),
    );
  }
}
