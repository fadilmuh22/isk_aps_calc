import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';

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
        centerWidget: SvgPicture.asset(
          'assets/images/onboarding1.svg',
          width: 320.0,
          height: 352.0,
        ),
        backgroundColor: Color.fromRGBO(255, 255, 255, 1.0),
      ),
    );
    slides.add(
      new Slide(
        centerWidget: SvgPicture.asset(
          'assets/images/onboarding2.svg',
          width: 320.0,
          height: 352.0,
        ),
        backgroundColor: Color.fromRGBO(255, 255, 255, 1.0),
      ),
    );
    slides.add(
      new Slide(
        centerWidget: SvgPicture.asset(
          'assets/images/onboarding3.svg',
          width: 320.0,
          height: 352.0,
        ),
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
      styleNameSkipBtn: TextStyle(color: Color(0xffC82247)),
      colorDoneBtn: Color(0xffC82247),
      styleNameDoneBtn: TextStyle(
        color: Color.fromRGBO(255, 255, 255, 1.0),
      ),
      colorDot: Color(0xffDEDEDE),
      colorActiveDot: Color(0xffC82247),
      sizeDot: 8.0,
    );
  }
}
