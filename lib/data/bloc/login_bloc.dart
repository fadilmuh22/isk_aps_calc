import 'dart:convert';

import 'package:dbcrypt/dbcrypt.dart';
import 'package:flutter/foundation.dart';
import 'package:isk_aps_calc/data/app_storage.dart';

import 'package:google_sign_in/google_sign_in.dart';

import 'package:isk_aps_calc/data/app_database.dart';
import 'package:isk_aps_calc/data/model/login_model.dart';
import 'package:isk_aps_calc/data/model/user_model.dart';

class LoginBloc extends ChangeNotifier {
  GoogleSignIn _googleSignIn = new GoogleSignIn();

  Map<String, String> loginMessage;

  googleLogin() async {
    GoogleSignInAccount data;
    try {
      data = await _googleSignIn.signIn();
    } catch (e) {
      print('dapet exception nih $e');
    }

    if (data != null) {
      var user = await AppDatabase().selectOne(data.email);

      if (user != null) {
        loginMessage = flash('Login Gagal', 'Email anda sudah terdaftar');
        return false;
      }

      _googleSignIn.onCurrentUserChanged
          .listen((GoogleSignInAccount account) async {
        if (account != null) {
        } else {}
      });
      _googleSignIn.signInSilently().whenComplete(() {});

      AppDatabase().insert(UserModel(
        id: data.id,
        name: data.displayName,
        email: data.email,
        password: DBCrypt().hashpw('12345', new DBCrypt().gensalt()),
        status: 1.toString(),
      ));
      AppStorage().write(
        key: 'user',
        value: jsonEncode(user.toMap()),
      );

      loginMessage = flash('Login Berhasil', 'Berhasil login dengan google');
      return true;
    }

    loginMessage = flash('Login Gagal', 'Terjadi kesalahan saat login');
    return false;
  }

  localLogin(LoginModel data) async {
    UserModel user = await AppDatabase().selectOne(data.email);
    if (user != null) {
      // bool isCorrect = DBCrypt().checkpw(data.password, user.password);
      bool isCorrect = true;
      if (isCorrect) {
        AppStorage().write(
          key: 'user',
          value: jsonEncode(user.toMap()),
        );
        loginMessage = flash('Login Berhasil', 'Welcome ${user.name} ');
        return true;
      }
      loginMessage = flash('Login Gagal', 'Password anda tidak sesuai');
      return false;
    }

    print('selesai');

    loginMessage = flash('Login Gagal', 'Tidak ada email yang cocok');
    return false;
  }

  flash(String status, String message) {
    return {'status': status, 'message': message};
  }
}
