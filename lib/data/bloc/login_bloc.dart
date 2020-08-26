import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'package:google_sign_in/google_sign_in.dart';

import 'package:isk_aps_calc/data/repository/app_storage.dart';
import 'package:isk_aps_calc/data/dao/user_dao.dart';

import 'package:isk_aps_calc/data/model/login_model.dart';
import 'package:isk_aps_calc/data/model/user_model.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginBloc extends ChangeNotifier {
  GoogleSignIn googleSignIn = new GoogleSignIn();
  String genPass = "1234567";

  Map<String, String> loginMessage;

  googleLogin() async {
    GoogleSignInAccount data;
    try {
      data = await googleSignIn.signIn();
    } catch (e) {
      loginMessage = flash('Login Gagal', 'Coba beberapa saat lagi.');
      return false;
    }

    if (data != null) {
      var user = await UserDao().selectOne(data.email);
      if (user != null) {
        await AppStorage().write(
          key: 'user',
          value: jsonEncode(user.toJson()),
        );
        loginMessage =
            flash('Login Berhasil', 'Selamat datang kembali ${user.name}');
        return true;
      }

      UserModel newUser = UserModel(
        id: data.id,
        name: data.displayName,
        email: data.email,
        password: genPass,
        status: 1,
        updateDateTime: DateTime.now().toString(),
      );
      await UserDao().insert(newUser);
      await AppStorage().write(
        key: 'user',
        value: jsonEncode(newUser.toJson()),
      );

      loginMessage = flash(
        'Login Berhasil',
        '\nBerhasil login dengan Akun Google Anda.\n\nMulai saat ini Email Anda sudah terdaftar dan dapat menggunakan nya untuk login dengan mengisikan Email sebagai username dan password "$genPass".',
      );
      return true;
    }

    loginMessage = flash('Login Gagal', 'Terjadi kesalahan saat login');
    return false;
  }

  appleLogin() async {
    bool isAvailable = await SignInWithApple.isAvailable();
    if (isAvailable) {
      AuthorizationCredentialAppleID data;
      try {
        data = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
        );
      } catch (e) {
        loginMessage = flash('Login Gagal', 'Silahkan login menggunakan google sign in, terima kasih.');
        return false;
      }

      if (data.email != null) {
        var user = await UserDao().selectOne(data.email);
        if (user != null) {
          await AppStorage().write(
            key: 'user',
            value: jsonEncode(user.toJson()),
          );
          loginMessage =
              flash('Login Berhasil', 'Selamat datang kembali ${user.name}');
          return true;
        }

        UserModel newUser = UserModel(
          id: data.email,
          name: '${data.givenName} ${data.familyName}',
          email: data.email,
          password: genPass,
          status: 1,
          updateDateTime: DateTime.now().toString(),
        );
        await UserDao().insert(newUser);
        await AppStorage().write(
          key: 'user',
          value: jsonEncode(newUser.toJson()),
        );

        loginMessage = flash(
          'Login Berhasil',
          '\nBerhasil login dengan Akun Apple Anda.\n\nMulai saat ini Email Anda sudah terdaftar dan dapat menggunakan nya untuk login dengan mengisikan Email sebagai username dan password "$genPass".',
        );
        return true;
      } else if (data.email == null && (data.givenName != null || data.familyName != null)) {
        loginMessage =
            flash('Login Gagal', 'Mohon tidak menyembunyikan email untuk login');
        return false;
      }
    }

    loginMessage = flash('Login Gagal', 'Untuk saat ini, perangkat anda belum dapat sign in menggunakan apple, silahkan gunakan fungsi google sign in atau login dengan akun yang terdaftar');
    return false;
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
      loginMessage = flash('Login Gagal', 'Password anda tidak sesuai!');
      return false;
    }

    loginMessage = flash('Login Gagal', 'Tidak ada email yang cocok!');
    return false;
  }

  flash(String status, String message) {
    return {'status': status, 'message': message};
  }
}
