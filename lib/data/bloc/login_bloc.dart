import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:password/password.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:isk_aps_calc/data/app_database.dart';
import 'package:isk_aps_calc/data/model/login_model.dart';
import 'package:isk_aps_calc/data/model/user_model.dart';

class LoginBloc extends ChangeNotifier {
  GoogleSignIn _googleSignIn = new GoogleSignIn();
  final _storage = FlutterSecureStorage();

  Map<String, String> loginMessage;

  googleLogin() async {
    GoogleSignInAccount data = await _googleSignIn.signIn();

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
        password: Password.hash('12345', new PBKDF2()),
        status: 1.toString(),
      ));
      await _storage.write(
        key: 'user',
        value: json.encode(user.toMap().toString()),
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
      if (user.password == data.password) {
        await _storage.write(
          key: 'user',
          value: json.encode(user.toMap().toString()),
        );
        loginMessage = flash('Login Berhasil', 'Welcome ${user.name} ');
        return true;
      }
      loginMessage = flash('Login Gagal', 'Password anda tidak sesuai');
      return false;
    }
    loginMessage = flash('Login Gagal', 'Tidak ada email yang cocok');
    return false;
  }

  flash(String status, String message) {
    return {'status': status, 'message': message};
  }
}
