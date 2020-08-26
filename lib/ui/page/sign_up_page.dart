import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:isk_aps_calc/constants.dart';
import 'package:isk_aps_calc/data/bloc/login_bloc.dart';
import 'package:isk_aps_calc/data/dao/user_dao.dart';
import 'package:isk_aps_calc/data/model/user_model.dart';
import 'package:isk_aps_calc/data/repository/app_storage.dart';
import 'package:isk_aps_calc/ui/component/custom_rounded_button.dart';
import 'package:isk_aps_calc/ui/page/login_page.dart';
import 'package:isk_aps_calc/ui/page/main_tabs_page.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  static String tag = '/sign-up';

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  String name, email, institute, password;
  bool _pwIsHidden = true;
  bool isLoading = false;

  void setIsLoading(bool status) {
    setState(() {
      isLoading = status;
    });
  }

  void _toggleVisible() {
    setState(() {
      _pwIsHidden = !_pwIsHidden;
    });
  }

  onSaveForm() async {
    setIsLoading(true);
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      final UserModel newUser = UserModel(
        id: this.email,
        name: this.name,
        email: this.email,
        institute: this.institute,
        password: '1234567',
        status: 1,
        updateDateTime: DateTime.now().toString(),
      );

      bool succeed =
          await Provider.of<LoginBloc>(context, listen: false).signUp(newUser);

      setIsLoading(false);

      loginDialog(
        succeed,
        Provider.of<LoginBloc>(context, listen: false).loginMessage['status'],
        Provider.of<LoginBloc>(context, listen: false).loginMessage['message'],
      );
    }

    setIsLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sign Up',
          style: TextStyle(color: Constants.accentColor),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 36.0, vertical: 48.0),
        children: <Widget>[
          isLoading ? loading() : signUpForm(),
        ],
      ),
    );
  }

  Widget loading() {
    return Center(
      child: CircularProgressIndicator(
        backgroundColor: Color(0xffC82247),
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xffffffff)),
      ),
    );
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
                Navigator.of(context).pop();
                if (succeed) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      MainTabs.tag, (route) => route is LoginPage);
                }
              },
            ),
          ],
        ),
      ).then((data) {
        if (succeed) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              MainTabs.tag, (route) => route is LoginPage);
        }
      });

  Widget signUpForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          usernameField(),
          SizedBox(height: 10.0),
          emailField(),
          SizedBox(height: 10.0),
          institueField(),
          SizedBox(height: 10.0),
          signUpButton(),
        ],
      ),
    );
  }

  Widget usernameField() => Theme(
        child: TextFormField(
          keyboardType: TextInputType.text,
          autofocus: false,
          onSaved: (value) => name = value.trim(),
          validator: (value) {
            if (value.isEmpty) {
              return 'Username must be filled';
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

  Widget emailField() => Theme(
        child: TextFormField(
          keyboardType: TextInputType.emailAddress,
          autofocus: false,
          onSaved: (value) => email = value.trim(),
          validator: (value) {
            if (value.isEmpty) {
              return 'Email must be filled';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: 'Email',
            prefixIcon: Icon(Icons.email),
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

  Widget institueField() => Theme(
        child: TextFormField(
          keyboardType: TextInputType.text,
          autofocus: false,
          onSaved: (value) => institute = value.trim(),
          validator: (value) {
            if (value.isEmpty) {
              return 'Institute must be filled';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: 'Instute',
            prefixIcon: Icon(Icons.account_balance),
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

  Widget signUpButton() => Container(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: CustomRoundedButton(
            align: MainAxisAlignment.center,
            onPressed: onSaveForm,
            items: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 36.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Sign Up',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
