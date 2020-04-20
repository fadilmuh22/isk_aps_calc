import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:isk_aps_calc/data/repository/app_storage.dart';

class ImageUploadUtil {
  static Future<Image> getImage(String user) async {
    var data = await AppStorage().read(key: user);
    if (data != null) {
      return Image.memory(
        base64Decode(data),
        width: 150.0,
        height: 150.0,
        fit: BoxFit.fill,
      );
    }
    return null;
  }

  static deleteImage(String user) async {
    await AppStorage().delete(key: user);
  }

  static saveImage(String user, File file) async {
    var value = base64Encode(file.readAsBytesSync());
    await AppStorage().write(key: user, value: value);
  }
}
