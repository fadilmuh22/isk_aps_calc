import 'package:flutter/foundation.dart';

import 'package:password/password.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:isk_aps_calc/data/dbhelper.dart'; 
import 'package:isk_aps_calc/data/model/login_model.dart';
import 'package:isk_aps_calc/data/model/user_model.dart';

class LoginBloc extends ChangeNotifier {

  Map<String, String> loginMessage;

  GoogleSignIn _googleSignIn = new GoogleSignIn();

  googleLogin() async {
    
    GoogleSignInAccount data = await _googleSignIn.signIn();

    if ( data != null) {
      var user = await DbHelper().selectOne(data.email);

      if (user != null) {
        loginMessage = flash('Login Gagal', 'Email anda sudah terdaftar');
        return false;
      }

      _googleSignIn.onCurrentUserChanged
          .listen((GoogleSignInAccount account) async {
        if (account != null) {
          print('logged');
        } else {
          print('not logged');
        }
      });
      _googleSignIn.signInSilently().whenComplete(() => print('completed'));

      DbHelper().insert(UserModel(
        id: data.id,
        name: data.displayName,
        email: data.email,
        password: Password.hash('12345', new PBKDF2()),
        status: 1.toString(),
      ));

      loginMessage = flash('Login Berhasil', 'Berhasil login dengan google');
      return true;
    }

    loginMessage = flash('Login Gagal', 'Terjadi kesalahan saat login');
    return false;

  }

  localLogin(LoginModel data) async {
    var user = await DbHelper().selectOne(data.email);
    if (user != null) {
      if (user['user_password'] == data.password) { ////Password.verify(data.password, user['user_password'])
        loginMessage = flash('Login Berhasil', 'Welcome ${user['user_name']} ');
        return true;
      }
      loginMessage = flash('Login Gagal', 'Password anda tidak sesuai');
      return false;
    }
    loginMessage = flash('Login Gagal', 'Tidak ada email yang cocok');
    return false;
  }

  flash(String status, String message) {
    return {
      'status': status,
      'message': message   
    };
  }

}
