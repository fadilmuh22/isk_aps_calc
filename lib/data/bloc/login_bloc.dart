import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'package:isk_aps_calc/data/repository/app_storage.dart';
import 'package:isk_aps_calc/data/dao/user_dao.dart';

import 'package:isk_aps_calc/data/model/login_model.dart';
import 'package:isk_aps_calc/data/model/user_model.dart';

class LoginBloc extends ChangeNotifier {
  String genPass = "1234567";

  Map<String, String> loginMessage;

  signUp(UserModel newUser) async {

    var user = await UserDao().selectOne(newUser.email);
    if (user != null) {
      loginMessage =
          flash('Sign Up Gagal', 'Email sudah terdaftar');
      return false;
    }

    await UserDao().insert(newUser);
    await AppStorage().write(
      key: 'user',
      value: jsonEncode(newUser.toJson()),
    );

    loginMessage = flash(
      'Sign Up Berhasil',
      '\nBerhasil Sign Up.\n\nMulai saat ini Email Anda sudah terdaftar dan dapat menggunakan nya untuk login dengan mengisikan Email sebagai username dan password "$genPass".',
    );
    return true;

  }

  localLogin(LoginModel data) async {
    UserModel user = await UserDao().selectOne(data.email);
    if (user != null) {
      bool isCorrect = data.password == user.password;
      if (isCorrect) {
        await AppStorage().write(
          key: 'user',
          value: jsonEncode(user.toJson()),
        );
        loginMessage = flash('Login Berhasil', 'Selamat Datang ${user.name} ');
        return true;
      }
      loginMessage = flash('Login Gagal', 'Password anda tidak sesuai! \nPassword default adalah $genPass');
      return false;
    }

    loginMessage = flash('Login Gagal', 'Tidak ada email yang cocok!');
    return false;
  }

  flash(String status, String message) {
    return {'status': status, 'message': message};
  }
}
