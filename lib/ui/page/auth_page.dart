import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:isk_aps_calc/ui/page/login_page.dart';
import 'package:isk_aps_calc/ui/page/main_tabs_page.dart';
import 'package:isk_aps_calc/ui/page/onboarding_page.dart';

class AuhthenticationPage extends StatefulWidget {
  static String tag = '/auth';

  final String authType;

  AuhthenticationPage({this.authType});

  @override
  _AuhthenticationPageState createState() => _AuhthenticationPageState();
}

class _AuhthenticationPageState extends State<AuhthenticationPage> {
  Future<void> auth() async {
    final _storage = FlutterSecureStorage();
    await _storage.delete(key: 'not_user_first_time');
    String userFirstTime = await _storage.read(key: 'not_user_first_time');
    bool seen = (userFirstTime != null ? true : false);

    if (seen) {
      String userLogged = await _storage.read(key: 'user');
      bool logged = (userLogged != null ? true : false);

      if (logged) {
        Navigator.of(context).pushReplacementNamed(MainTabs.tag);
      } else {
        Navigator.of(context).pushReplacementNamed(LoginPage.tag);
      }
    } else {
      // await _storage.write(key: 'not_user_first_time', value: 'true');
      Navigator.of(context).pushReplacementNamed(OnBoardingPage.tag);
    }
  }

  @override
  void initState() {
    super.initState();
    auth().whenComplete(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
