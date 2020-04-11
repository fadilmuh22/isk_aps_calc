import 'package:flutter/material.dart';

import 'package:isk_aps_calc/data/bloc/login_bloc.dart';
import 'package:isk_aps_calc/data/model/login_model.dart';

import 'package:isk_aps_calc/ui/page/main_tabs_page.dart';
import 'package:isk_aps_calc/constants.dart';

import 'package:isk_aps_calc/ui/component/custom_rounded_button.dart';
import 'package:provider/provider.dart';

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
  bool _pwIsHidden = false;
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

  @override
  void dispose() {
    _formKey.currentState.dispose();
    super.dispose();
  }

  loginDialog(bool succeed, String title, String message) => showDialog(
        context: context,
        child: AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                print('ini berhasil $succeed');
                Navigator.of(context).pop();
                if (succeed)
                  Navigator.of(context).pushReplacementNamed(MainTabs.tag);
              },
            ),
          ],
        ),
      );

  void handleLocalLogin() async {
    await setIsLoading(true);
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      bool succeed = await Provider.of<LoginBloc>(context, listen: false)
          .localLogin(LoginModel(email: email, password: password));

      setIsLoading(false);

      loginDialog(
        succeed,
        Provider.of<LoginBloc>(context, listen: false).loginMessage['status'],
        Provider.of<LoginBloc>(context, listen: false).loginMessage['message'],
      );
    }

    setIsLoading(false);
    // loginDialog(true, 'fadil', 'fadil');
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

  Widget loading() {
    return Center(
      child: CircularProgressIndicator(),
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
            SizedBox(height: 200.0),

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

            SizedBox(height: 36.0),
            Flex(
              direction: Axis.horizontal,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                loginButton(),
              ],
            ),
            SizedBox(height: 5.0),
            // oauthButton(),
            Flex(
              direction: Axis.horizontal,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                oauthButton(),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget appTitle() => Text(
        Constants.appName,
        style: TextStyle(
          color: Constants.accentColor,
          fontSize: 22,
          fontWeight: FontWeight.w500,
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
              return 'Password must be filled';
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
                padding: const EdgeInsets.symmetric(horizontal: 36.0),
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

  Widget oauthButton() => CustomRoundedButton(
        color: Colors.blueAccent,
        padding: EdgeInsets.all(1.0),
        onPressed: handleGoogleLogin,
        items: <Widget>[
          Container(
            margin: EdgeInsets.all(1.0),
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16.0),
                  bottomLeft: const Radius.circular(16.0),
                )),
            child: Image.asset('assets/images/google_logo.png'),
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

  // if (false) {
  //   Center(
  //     child: CircularProgressIndicator(),
  //   )
  // }

}
