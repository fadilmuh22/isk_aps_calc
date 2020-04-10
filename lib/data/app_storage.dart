import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppStorage {
  final storage = FlutterSecureStorage();

  read({String key}) async {
    return jsonDecode(await storage.read(key: key));
  }

  write({String key, value}) async {
    await storage.write(key: key, value: jsonEncode(value));
  }

  delete({String key}) async {
    await storage.delete(key: key);
  }
}
