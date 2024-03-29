import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import 'package:isk_aps_calc/data/repository/app_storage.dart';

import 'package:isk_aps_calc/data/bloc/login_bloc.dart';

import 'package:isk_aps_calc/constants.dart';
import 'package:isk_aps_calc/util/image_upload_util.dart';

import 'package:isk_aps_calc/data/dao/user_dao.dart';

import 'package:isk_aps_calc/data/model/user_model.dart';

import 'package:isk_aps_calc/ui/component/custom_appbar.dart';
import 'package:isk_aps_calc/ui/component/custom_rounded_button.dart';

import 'package:isk_aps_calc/ui/page/login_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Image imageProfile;
  final _formKey = GlobalKey<FormState>();
  String name, institute;

  UserModel user = UserModel(
    name: 'Username',
    email: 'User Email',
    institute: 'User Institute',
  );

  @override
  void initState() {
    super.initState();
    AppStorage().read(key: 'user').then((data) => setState(() {
          user = UserModel.fromJson(jsonDecode(data));
          user.institute = user.institute ?? 'Nama Institute Anda';
          loadImageFromPreferences();
        }));
  }

  pickImageFromGallery(ImageSource source) async {
    File file;
    file = await ImagePicker.pickImage(source: source);
    if (file != null) {
      setState(() {
        imageProfile = Image.file(
          file,
          width: 150.0,
          height: 150.0,
          fit: BoxFit.fill,
        );
      });
      await ImageUploadUtil.saveImage(user.email, file);
    }
  }

  loadImageFromPreferences() {
    ImageUploadUtil.getImage(user.email).then((img) {
      if (null == img) {
        return;
      }
      setState(() {
        imageProfile = img;
      });
    });
  }

  deleteImage() async {
    await ImageUploadUtil.deleteImage(user.email);
    setState(() {
      imageProfile = imagePlaceHolder();
    });
  }

  onSaveForm() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        user.name = name;
        user.institute = institute;
      });

      int count = await UserDao().update(user);
      UserModel userUpdated = await UserDao().selectOne(user.email);
      setState(() {
        user = userUpdated;
      });

      await AppStorage().delete(key: 'user');
      await AppStorage().write(
        key: 'user',
        value: jsonEncode(userUpdated.toJson()),
      );

      if (count != null && count > 0) {
        showDialog(
          context: context,
          child: AlertDialog(
            title: Text('Berhasil'),
            content: Text('Data Berhasil Diupdate'),
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
            title: Text('Gagal'),
            content: Text('Data Gagal Diupdate'),
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
                        labelText: 'Nama',
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
                        labelText: 'Institusi',
                      ),
                      onSaved: (value) => institute = value,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: RaisedButton(
                      child: Text("Simpan"),
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
    Provider.of<LoginBloc>(context, listen: false).googleSignIn.disconnect();
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

  Widget userImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          child: Stack(
            children: <Widget>[
              GestureDetector(
                onLongPress: deleteImage,
                onTap: loadImageFromPreferences,
                child: ClipOval(
                  child: imageProfile ?? imagePlaceHolder(),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 118.0, left: 100.0),
                child: IconButton(
                  icon: Icon(
                    Icons.photo_camera,
                    color: Constants.accentColor,
                    size: 30,
                  ),
                  onPressed: () async {
                    await pickImageFromGallery(ImageSource.gallery);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget userDetailProfile() {
    return Center(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  user.name,
                  style: Constants.titleStyle,
                ),
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Constants.accentColor,
                  ),
                  onPressed: showModalForm,
                ),
              ],
            ),
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
          SizedBox(height: 20.0),
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
          SizedBox(height: 60.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CustomRoundedButton(
                color: Constants.accentColor,
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                items: <Widget>[
                  Text(
                    'Logout',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
                onPressed: logoutUser,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Image imagePlaceHolder() => Image.asset(
        'assets/images/profile_placeholder.png',
        width: 150.0,
        height: 150.0,
        fit: BoxFit.fill,
      );
}
