import 'package:flutter/material.dart';
import 'package:isk_aps_calc/ui/page/sign_up_page.dart';

import 'package:provider/provider.dart';

import 'package:isk_aps_calc/data/bloc/login_bloc.dart';
import 'package:isk_aps_calc/data/bloc/simulation_bloc.dart';

import 'package:isk_aps_calc/constants.dart';

import 'package:isk_aps_calc/ui/page/auth_page.dart';
import 'package:isk_aps_calc/ui/page/login_page.dart';
import 'package:isk_aps_calc/ui/page/main_tabs_page.dart';
import 'package:isk_aps_calc/ui/page/onboarding_page.dart';
import 'package:isk_aps_calc/ui/page/simulation/indicator_page.dart';
import 'package:isk_aps_calc/ui/page/simulation/result_page.dart';

void main() async {
  runApp(new MyApp());
}

final routes = {
  AuhthenticationPage.tag: (context) => AuhthenticationPage(),
  OnBoardingPage.tag: (context) => OnBoardingPage(),
  LoginPage.tag: (context) => LoginPage(),
  SignUpPage.tag: (context) => SignUpPage(),
  MainTabs.tag: (context) => MainTabs(),
  IndicatorPage.tag: (context) => IndicatorPage(),
  ResultPage.tag: (context) => ResultPage(),
};

class MyApp extends StatelessWidget {
  @override
  Widget build(context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LoginBloc()),
        ChangeNotifierProvider(create: (context) => SimulationBloc()),
      ],
      child: MaterialApp(
        themeMode: ThemeMode.light,
        initialRoute: AuhthenticationPage.tag,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: "Quicksand",
          appBarTheme: AppBarTheme(
            color: Colors.white,
            iconTheme: IconThemeData(color: Constants.accentColor),
            textTheme: TextTheme(
              title: TextStyle(
                color: Constants.accentColor,
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            ),
          ),
        ),
        routes: routes,
      ),
    );
  }
}
