import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:isk_aps_calc/constants.dart';

import 'package:isk_aps_calc/data/bloc/login/index.dart';
import 'package:isk_aps_calc/data/bloc/login/login_bloc.dart';

import 'package:isk_aps_calc/ui/component/custom_form_field.dart';
import 'package:isk_aps_calc/ui/component/rounded_button.dart';
import 'package:isk_aps_calc/ui/page/main_tabs_page.dart';

class LoginPage extends StatefulWidget {
  static String tag = '/login';

  const LoginPage({
    Key key,
  }) : super(key: key);

  @override
  _LoginPageState createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  final loginBloc = LoginBloc();

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _pwIsHidden = false;

  void _toggleVisible() {
    setState(() {
      _pwIsHidden = !_pwIsHidden;
    });
  }

  @override
  void dispose() {
    super.dispose();
    loginBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
        bloc: loginBloc,
        listener: (context, state) {
          if (state is SuccessLoginState) {
            showDialog(
              context: context,
              child: AlertDialog(
                  title: Text(state.data),
                  content: Text('Your submission was a success'),
                  actions: [
                    FlatButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pushReplacementNamed(MainTabs.tag);
                      },
                    ),
                  ]),
            );
          }
        },
        child: buildScaffold());
  }

  Widget appTitle() => Text(
        Constants.appName,
        style: TextStyle(
            color: Constants.accentColor,
            fontSize: 22,
            fontWeight: FontWeight.w500),
      );

  Widget usernameField() => CustomFormField(
      context: context,
      controller: _usernameController,
      prefixIcon: Icon(Icons.person),
      suffixIcon: Icon(Icons.mode_edit),
      hintText: 'Username');

  Widget passwordField() => CustomFormField(
      context: context,
      controller: _passwordController,
      prefixIcon: Icon(Icons.lock_outline),
      suffixIcon: IconButton(
        icon: Icon(_pwIsHidden ? Icons.visibility_off : Icons.visibility),
        onPressed: () {
          _toggleVisible();
        },
      ),
      hintText: 'Password');

  Widget loginButton() => Container(
    child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: RoundedButton(
            align: MainAxisAlignment.center,
            onPressed: () {
              loginBloc.onSubmit({
                'username': _usernameController.text,
                'password': _passwordController.text
              });
            },
            items: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 36.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('LOGIN',
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                  ],
                ),
              ),
            ],
            
        )
    ),
  );

  Widget oauthButton() => RoundedButton(
    color: Colors.blueAccent,
    padding: EdgeInsets.all(1.0),
    onPressed: () {
      loginBloc.onSubmit({
        'username': _usernameController.text,
        'password': _passwordController.text
      });
    },
    items: <Widget>[
      Container(
        margin: EdgeInsets.all(1.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16.0),
              bottomLeft: const Radius.circular(16.0),
            )),
        child: Icon(Icons.ac_unit),
      ),
      Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Google Sign In",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      Container()
    ],
  );

  Scaffold buildScaffold() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: BlocBuilder(
          bloc: loginBloc,
          builder: (BuildContext context, LoginState currentState) {
            if (currentState is LoadingLoginState) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (currentState is InitialLoginState) {}

            return ListView(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 36.0, vertical: 48.0),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          appTitle(),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      SizedBox(height: 200.0),
                      usernameField(),
                      SizedBox(height: 10.0),
                      passwordField(),
                      SizedBox(height: 36.0),
                      Flex(
                        direction: Axis.horizontal,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[loginButton(),],
                      ),
                      SizedBox(height: 5.0),
                      // oauthButton(),
                      Flex(
                        direction: Axis.horizontal,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[oauthButton()],
                      ),
                      
                    ],
                  ),
                  
                ),

              ]
            );

          }

        )

      )

    );

  }

}
