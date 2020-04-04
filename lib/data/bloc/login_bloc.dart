import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:isk_aps_calc/data/dbhelper.dart';

import 'package:isk_aps_calc/data/model/login_model.dart';
import 'package:isk_aps_calc/data/model/user_model.dart';

class LoginBloc extends ChangeNotifier {

  Map<String, String> loginMessage;

  GoogleSignIn _googleSignIn = new GoogleSignIn();

  googleSignIn() async {
    
    GoogleSignInAccount data = await _googleSignIn.signIn();
    
    var user = await DbHelper().selectOne(data.email);

    if (user.length > 0) {
      loginMessage = flash('Gagal Login', 'Email anda sudah terdaftar');
      return false;
    }

    // _googleSignIn.onCurrentUserChanged
    //     .listen((GoogleSignInAccount account) async {
    //   if (account != null) {
    //     print('logged');
    //   } else {
    //     print('not logged');
    //   }
    // });
    // _googleSignIn.signInSilently().whenComplete(() => print('completed'));

    DbHelper().insert(UserModel(
      id: data.id,
      name: data.displayName,
      email: data.email,
      password: data.email,
      status: 1.toString(),
    ));

    loginMessage = flash('Login Berhasil', 'Berhasil login');
    return true;

  }

  localSignIn(LoginModel data) async {
    var user = await DbHelper().selectOne(data.email);
    if (user.length > 0) {
      if (user['user_password'] == data.password) {
        loginMessage = flash('Login Berhasil', 'Welcome ${data.email.split(' ')[0]} ');
        return true;
      }
      loginMessage = flash('Gagal Login', 'Password anda tidak sesuai');
      return false;
    }
    loginMessage = flash('Gagal Login', 'Tidak ada email yang cocok');
    return false;
  }

  flash(String status, String message) {
    return {
      'status': status,
      'message': message   
    };
  }

}
