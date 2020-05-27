import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/services.dart';

import 'package:path/path.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

class AppDatabase {
  static Database _db;

  static final AppDatabase _instance = AppDatabase.internal();

  factory AppDatabase() => _instance;

  AppDatabase.internal();

  Future<Database> get db async {
    if (_db == null) {
      _db = await initDb();
    }
    return _db;
  }

  Future initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'isk_aps.db');

    bool exists = await databaseExists(path);

    if (!exists) {
      print("Creating new copy from asset");
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      ByteData data =
          await rootBundle.load(join('assets', 'data', 'isk_aps.db'));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }

    return await openDatabase(
      path,
      version: 1,
      password: 'isk_aps31415',
    );
  }
}
