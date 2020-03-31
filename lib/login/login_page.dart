import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:isk_aps_calc/home/home_page.dart';
import 'package:isk_aps_calc/contants.dart';

class LoginPage extends StatefulWidget {
  
  static String tag = 'login-page';
  
  const LoginPage({
    Key key,
  }) : super(key: key);


  @override
  _LoginPageState createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  _LoginPageState();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool _pwIsHidden = false;

  void _toggleVisible(){
    setState(() {
      _pwIsHidden = !_pwIsHidden;
    });
  }

  @override
  Widget build(BuildContext context) {

    final txtAppTitle = Text(
      Constants.APP_NAME,
      style: TextStyle(
        color: Constants.ACCENT_COLOR,
        fontSize: 22,
        fontWeight: FontWeight.w500
      ),
    );

    Theme txtFormField({
      prefixIcon,
      suffixIcon,
      hintText   
    }) => Theme(
      child: TextFormField(
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          hintText: hintText,
          contentPadding: EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0, bottom: 10.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4)
          )
        ),
      ),
      data: Theme.of(context).copyWith(
        primaryColor: Constants.ACCENT_COLOR
      )
    );

    final tffUsername = txtFormField(
      prefixIcon: Icon(Icons.person),
      suffixIcon: Icon(Icons.mode_edit),
      hintText: "Username"
    );

    final tffPassword = txtFormField(
      prefixIcon: Icon(Icons.lock_outline),
      suffixIcon: IconButton(
        icon: Icon(
          _pwIsHidden ? Icons.visibility_off : Icons.visibility
        ),
        onPressed: () {
          _toggleVisible();
        },
      ),
      hintText: "Password"
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          Navigator.of(context).pushReplacementNamed(HomePage.tag);
        },
        padding: EdgeInsets.all(12),
        color: Constants.ACCENT_COLOR,
        child: Text('LOGIN',
          style: TextStyle(
              color: Colors.white,
              fontSize: 16
          )
        ),
      )
    );
          
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: ListView(
          padding: EdgeInsets.only(left: 24.0, right: 24.0, top: 48.0, bottom: 48.0),
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                txtAppTitle,
              ],
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(height: 86),
            SizedBox(height: 48.0),
            tffUsername,
            SizedBox(height: 8.0),
            tffPassword,
            SizedBox(height: 24.0),
            loginButton,
          ],
        ),
      )
    );

  }
}
