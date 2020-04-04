import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:isk_aps_calc/constants.dart';
import 'package:isk_aps_calc/data/bloc/login_bloc.dart';

import 'package:isk_aps_calc/ui/page/login_page.dart';
import 'package:isk_aps_calc/ui/page/main_tabs_page.dart';

void main() => runApp(new MyApp());

final routes = <String, WidgetBuilder>{
  // OnBoarding.tag: (context) => OnBoarding(),
  LoginPage.tag: (context) => ChangeNotifierProvider(
    create: (_) => LoginBloc(),
    child: LoginPage(),
  ),
  MainTabs.tag: (context) => MainTabs(),
};

class MyApp extends StatelessWidget {
  @override
  Widget build(context) {
    return MaterialApp(
        initialRoute: LoginPage.tag,
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
                  fontSize: 20),
            ),
          ),
        ),
        routes: routes,
      );
  }
}
