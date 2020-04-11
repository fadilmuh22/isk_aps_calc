import 'dart:typed_data';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

class ImageUploadUtil {
  //
  static const String KEY = "IMAGE_KEY";

  static Future<String> getImageFromPreferences() async {
    final _storage = FlutterSecureStorage();
    return _storage.read(key: KEY) ?? null;
  }

  static Future<bool> saveImageToPreferences(String value) async {
    final _storage = FlutterSecureStorage();
    await _storage.write(key: KEY, value: value);
    return true;
  }

  static Image imageFromBase64String(String base64String) {
    return Image.memory(
      base64Decode(base64String),
      width: 150.0,
      height: 150.0,
    );
  }

  static Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  static String base64String(Uint8List data) {
    return base64Encode(data);
  }
}
