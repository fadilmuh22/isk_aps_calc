import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:isk_aps_calc/data/bloc/login_bloc.dart';

import 'package:isk_aps_calc/constants.dart';

import 'package:isk_aps_calc/data/model/login_model.dart';

import 'package:isk_aps_calc/ui/component/custom_rounded_button.dart';

import 'package:isk_aps_calc/ui/page/main_tabs_page.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginPage extends StatefulWidget {
  static String tag = '/login';

  @override
  _LoginPageState createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String email, password;
  bool _pwIsHidden = true;
  bool isLoading = false;

  setIsLoading(bool status) {
    setState(() {
      isLoading = status;
    });
  }

  void _toggleVisible() {
    setState(() {
      _pwIsHidden = !_pwIsHidden;
    });
  }

  void handleLocalLogin() async {
    await setIsLoading(true);
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      bool succeed = await Provider.of<LoginBloc>(context, listen: false)
          .localLogin(LoginModel(
              email: email, password: email != 'admin' ? password : password));

      setIsLoading(false);

      loginDialog(
        succeed,
        Provider.of<LoginBloc>(context, listen: false).loginMessage['status'],
        Provider.of<LoginBloc>(context, listen: false).loginMessage['message'],
      );
    }

    setIsLoading(false);
  }

  void handleGoogleLogin() async {
    await setIsLoading(true);

    bool succeed =
        await Provider.of<LoginBloc>(context, listen: false).googleLogin();

    setIsLoading(false);

    loginDialog(
      succeed,
      Provider.of<LoginBloc>(context, listen: false).loginMessage['status'],
      Provider.of<LoginBloc>(context, listen: false).loginMessage['message'],
    );
  }

  void handleAppleLogin() async {
    await setIsLoading(true);

    final succeed =
        await Provider.of<LoginBloc>(context, listen: false).appleLogin();

    setIsLoading(false);

    loginDialog(
      succeed,
      Provider.of<LoginBloc>(context, listen: false).loginMessage['status'],
      Provider.of<LoginBloc>(context, listen: false).loginMessage['message'],
    );
  }

  @override
  Widget build(context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/login_bg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: isLoading ? loading() : buildListView(),
      ),
    );
  }

  loginDialog(bool succeed, String title, String message) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                if (succeed) {
                  Navigator.of(context).pushReplacementNamed(MainTabs.tag);
                }
              },
            ),
          ],
        ),
      ).then((data) {
        if (succeed) {
          Navigator.of(context).pushReplacementNamed(MainTabs.tag);
        }
      });

  Widget loading() {
    return Center(
      child: CircularProgressIndicator(
        backgroundColor: Color(0xffC82247),
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xffffffff)),
      ),
    );
  }

  ListView buildListView() {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 36.0, vertical: 48.0),
      children: [
        Column(
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
            SizedBox(height: 60.0),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  usernameField(),
                  SizedBox(height: 10.0),
                  passwordField(),
                ],
              ),
            ),
            SizedBox(height: 24.0),
            Flex(
              direction: Axis.horizontal,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                loginButton(),
              ],
            ),
            SizedBox(height: 1.0),
            forNewUserText(),
            SizedBox(height: 8.0),
            Flex(
              direction: Axis.horizontal,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                oauthButton(),
              ],
            ),
            SizedBox(height: 8.0),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 45.0),
              child: SignInWithAppleButton(
                onPressed: handleAppleLogin,
                style: SignInWithAppleButtonStyle.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget appTitle() => Flexible(
        child: Text(
          Constants.appName,
          style: TextStyle(
            color: Constants.accentColor,
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
      );

  Widget usernameField() => Theme(
        child: TextFormField(
          keyboardType: TextInputType.text,
          autofocus: false,
          onSaved: (value) => email = value,
          validator: (value) {
            if (value.isEmpty) {
              return 'Usernam/Email must be filled';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: 'Username',
            prefixIcon: Icon(Icons.person),
            suffixIcon: Icon(Icons.mode_edit),
            border: new UnderlineInputBorder(
              borderSide:
                  new BorderSide(color: Colors.white, style: BorderStyle.solid),
            ),
            contentPadding: EdgeInsets.only(
              left: 20.0,
              top: 10.0,
              right: 20.0,
              bottom: 10.0,
            ),
          ),
        ),
        data: Theme.of(context).copyWith(primaryColor: Constants.accentColor),
      );

  Widget passwordField() => Theme(
        child: TextFormField(
          keyboardType: TextInputType.text,
          autofocus: false,
          obscureText: _pwIsHidden,
          onSaved: (value) => password = value,
          validator: (value) {
            if (value.isEmpty) {
              password = '1234';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: 'Password',
            border: new UnderlineInputBorder(
              borderSide:
                  new BorderSide(color: Colors.white, style: BorderStyle.solid),
            ),
            contentPadding: EdgeInsets.only(
              left: 20.0,
              top: 10.0,
              right: 20.0,
              bottom: 10.0,
            ),
            prefixIcon: Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(_pwIsHidden ? Icons.visibility_off : Icons.visibility),
              onPressed: () {
                _toggleVisible();
              },
            ),
          ),
        ),
        data: Theme.of(context).copyWith(primaryColor: Constants.accentColor),
      );

  Widget loginButton() => Container(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: CustomRoundedButton(
            align: MainAxisAlignment.center,
            onPressed: handleLocalLogin,
            items: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 36.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'LOGIN',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Widget forNewUserText() => Text(
        Constants.forNewUser,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      );

  Widget oauthButton() => CustomRoundedButton(
        color: Colors.blueAccent,
        padding: EdgeInsets.all(1.0),
        onPressed: handleGoogleLogin,
        items: <Widget>[
          Container(
            width: 70.0,
            height: 50.0,
            margin: EdgeInsets.all(1.0),
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(8.0),
                  bottomLeft: const Radius.circular(8.0),
                )),
            child: Image.asset('assets/images/google_logo.png'),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Google Sign In",
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
            ),
          ),
          Container()
        ],
      );
}
