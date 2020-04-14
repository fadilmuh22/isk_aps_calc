import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'package:dbcrypt/dbcrypt.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:isk_aps_calc/data/dao/user_dao.dart';

import 'package:isk_aps_calc/data/repository/app_storage.dart';

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
      print('$e');
    }

    if (data != null) {
      var user = await UserDao().selectOne(data.email);
      if (user != null) {
        loginMessage = flash('Login Gagal', 'Email anda sudah terdaftar');
        return false;
      }

      await UserDao().insert(UserModel(
        id: data.id,
        name: data.displayName,
        email: data.email,
        password: DBCrypt().hashpw('12345', new DBCrypt().gensalt()),
        status: 1.toString(),
      ));
      await AppStorage().write(
        key: 'user',
        value: jsonEncode(user.toJson()),
      );

      loginMessage = flash(
        'Login Berhasil',
        'Berhasil login dengan google\nSilahkan Lanjutkan Login Dengan Email Google Yang Sudah Terdaftar',
      );
      return true;
    }

    loginMessage = flash('Login Gagal', 'Terjadi kesalahan saat login');
    return false;
  }

  localLogin(LoginModel data) async {
    UserModel user = await UserDao().selectOne(data.email);
    if (user != null) {
      // bool isCorrect = DBCrypt().checkpw(data.password, user.password);
      bool isCorrect = true;
      if (isCorrect) {
        await AppStorage().write(
          key: 'user',
          value: jsonEncode(user.toJson()),
        );
        loginMessage = flash('Login Berhasil', 'Selamat Datang ${user.name} ');
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
