import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:isk_aps_calc/data/app_storage.dart';
import 'package:isk_aps_calc/data/model/user_model.dart';
import 'package:isk_aps_calc/ui/component/custom_appbar.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    var data = AppStorage().read(key: 'user');

    return Scaffold(
      appBar: CustomAppBar(),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          Center(
            child: Container(
              width: 150.0,
              height: 150.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(
                      'https://workhound.com/wp-content/uploads/2017/05/placeholder-profile-pic.png'),
                ),
              ),
            ),
          ),
          Center(
            child: FutureBuilder<dynamic>(
              future: data,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                UserModel user;
                if (snapshot.hasData) {
                  user = UserModel.fromMap(jsonDecode(snapshot.data));
                  return Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(Icons.email),
                          SizedBox(width: 16.0),
                          Text(user.email),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Icon(Icons.account_balance),
                          SizedBox(width: 16.0),
                          Text(user.institute),
                        ],
                      ),
                    ],
                  );
                }
                return CircularProgressIndicator();
              },
            ),
          )
        ],
      ),
    );
  }
}
