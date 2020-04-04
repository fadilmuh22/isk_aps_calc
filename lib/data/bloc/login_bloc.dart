import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:isk_aps_calc/data/model/login_model.dart';

class LoginBloc extends ChangeNotifier {

  bool loginSuccess = false;

  GoogleSignIn _googleSignIn = new GoogleSignIn();

  googleSignIn() async {
    var data = await _googleSignIn.signIn();
    print(data);
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) async {
      if (account != null) {
        print('logged');
      } else {
        print('not logged');
      }
    });
    _googleSignIn.signInSilently().whenComplete(() => print('completed'));
    return data;
  }

  localSignIn(LoginModel data) {
    loginSuccess = true;
    return data.email;
  }

}