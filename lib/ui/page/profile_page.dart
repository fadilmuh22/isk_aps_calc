import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

import 'package:isk_aps_calc/constants.dart';
import 'package:isk_aps_calc/data/app_database.dart';
import 'package:isk_aps_calc/data/app_storage.dart';

import 'package:isk_aps_calc/data/model/user_model.dart';
import 'package:isk_aps_calc/ui/component/custom_appbar.dart';
import 'package:isk_aps_calc/ui/component/custom_rounded_button.dart';
import 'package:isk_aps_calc/ui/page/login_page.dart';
import 'package:isk_aps_calc/util/image_upload_util.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Image image;
  final _formKey = GlobalKey<FormState>();
  String name, institute;

  UserModel user = UserModel(
      name: 'Username', email: 'User Email', institute: 'User Institute');

  @override
  void initState() {
    super.initState();
    loadImageFromPreferences();
    AppStorage().read(key: 'user').then((data) => setState(() {
          user = UserModel.fromJson(jsonDecode(data));
        }));
  }

  pickImageFromGallery(ImageSource source) async {
    File file;
    file = await ImagePicker.pickImage(source: source);
    setState(() {
      image = Image.file(
        file,
        width: 150.0,
        height: 150.0,
      );
    });
  }

  loadImageFromPreferences() {
    ImageUploadUtil.getImageFromPreferences().then((img) {
      if (null == img) {
        return;
      }
      setState(() {
        image = ImageUploadUtil.imageFromBase64String(img);
      });
    });
  }

  onSaveForm() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        user.name = name;
        user.institute = institute;
      });

      int count = await AppDatabase().update(user);
      UserModel userUpdated = await AppDatabase().selectOne(user.email);
      setState(() {
        user = userUpdated;
      });

      await AppStorage().delete(key: 'user');
      await AppStorage().write(
        key: 'user',
        value: jsonEncode(user.toJson()),
      );

      if (count != null && count > 0) {
        showDialog(
          context: context,
          child: AlertDialog(
            title: Text('Success'),
            content: Text('Data Updated Successfuly'),
            actions: [
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      } else {
        showDialog(
          context: context,
          child: AlertDialog(
            title: Text('Failed'),
            content: Text('Data Not Updated'),
            actions: [
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      }
    }
  }

  showModalForm() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      autofocus: false,
                      initialValue: user.name,
                      decoration: InputDecoration(
                        labelText: 'Name',
                      ),
                      onSaved: (value) => name = value,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      autofocus: false,
                      initialValue: user.institute,
                      decoration: InputDecoration(
                        labelText: 'institute',
                      ),
                      onSaved: (value) => institute = value,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      child: Text("Save"),
                      onPressed: onSaveForm,
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  logoutUser() async {
    await AppStorage().delete(key: 'user');
    Navigator.pushReplacementNamed(context, LoginPage.tag);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          Center(
            child: Column(
              children: <Widget>[
                userImage(),
                SizedBox(height: 36.0),
                userDetailProfile(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Column userDetailProfile() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              user.name,
              style: Constants.titleStyle,
            ),
            SizedBox(width: 16.0),
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Constants.accentColor,
              ),
              onPressed: showModalForm,
            ),
          ],
        ),
        SizedBox(
          height: 36.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.email),
            SizedBox(width: 16.0),
            Text(
              user.email,
            ),
          ],
        ),
        SizedBox(
          height: 36.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.account_balance),
            SizedBox(width: 16.0),
            Text(
              user.institute,
            ),
          ],
        ),
        SizedBox(height: 64.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CustomRoundedButton(
              color: Constants.accentColor,
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              items: <Widget>[
                Text('Logout'),
              ],
              onPressed: logoutUser,
            ),
          ],
        ),
      ],
    );
  }

  Widget userImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: loadImageFromPreferences,
          child: ClipOval(
            child: image ?? Container(),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 100.0),
          child: IconButton(
            icon: Icon(
              Icons.photo_camera,
              color: Constants.accentColor,
            ),
            onPressed: () async {
              await pickImageFromGallery(ImageSource.gallery);
            },
          ),
        ),
      ],
    );
  }
}
