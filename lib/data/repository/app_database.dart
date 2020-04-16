import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/services.dart';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static Database _db;

  static final AppDatabase _instance = AppDatabase.internal();

  factory AppDatabase() => _instance;

  AppDatabase.internal();

  Database get db {
    return _db;
  }

  Future initDb() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'isk_aps.db';

    await deleteDatabase(path);

    var exists = await databaseExists(path);

    if (!exists) {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      ByteData data =
          await rootBundle.load(join('assets', 'data', 'isk_aps.db'));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await File(path).writeAsBytes(bytes, flush: true);
    }

    _db = await openDatabase(
      path,
      version: 1,
    );
  }
}
