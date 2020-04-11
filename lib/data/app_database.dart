import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/services.dart';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:dbcrypt/dbcrypt.dart';

import 'package:isk_aps_calc/data/model/user_model.dart';

class AppDatabase {
  static Database _db;

  static final AppDatabase _instance = AppDatabase.internal();

  factory AppDatabase() => _instance;

  AppDatabase.internal();

  get db {
    return _db;
  }

  final initScript = [
    '''
      CREATE TABLE user (
        user_id VARCHAR(255) PRIMARY KEY,
        user_name VARCHAR(255),
        user_email VARCHAR(255),
        user_password TEXT,
        institute VARCHAR(255),
        status INTEGER,
        update_dtm DATETIME 
      );
    ''',
    '''
      INSERT INTO user(
        user_id, 
        user_name, 
        user_email, 
        user_password,
        institute, 
        status
      ) VALUES(
        'admin',
        'admin',
        'admin',
        '${DBCrypt().hashpw('adminspmtelu', new DBCrypt().gensalt())}',
        'Admin SPM Telkom University',
        1
      );
    ''',
    '''
    create table indicator
    (
      indicator_id bigint auto_increment,
      indicator_category varchar not null,
      indicator_subcategory varchar not null,
      indicator_name varchar null,
      indicator_variable varchar(20) null,
      indicator_type int default 1 not null,
      default_value varchar null
    );

    create index indicator_indicator_category_index
      on indicator (indicator_category);

    create unique index indicator_indicator_id_uindex
      on indicator (indicator_id);

    create index indicator_indicator_subcategory_index
      on indicator (indicator_subcategory);

    alter table indicator
      add constraint indicator_pk
        primary key (indicator_id);
    ''',
  ];

  Future initDb() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'isk_aps.db';

    var exists = await databaseExists(path);

    if (!exists) {
      // Should happen only the first time you launch your application
      print("Creating new copy from asset");

      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", "isk_aps.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      // await deleteDatabase(path);
      print("Opening existing database");
    }

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        initScript.forEach((script) async => await db.execute(script));
      },
    );
  }

  Future<List<UserModel>> select() async {
    var mapList = await db.query(
      'user',
      orderBy: 'user_name',
    );
    return mapList.map<UserModel>((user) => UserModel.fromJson(user)).toList();
  }

  Future<UserModel> selectOne(String username) async {
    var mapList = await db.query(
      'user',
      where: 'user_email=? OR user_name=?',
      whereArgs: [username, username],
      limit: 1,
    );
    if (mapList.isNotEmpty) {
      return UserModel.fromJson(mapList[0]);
    }
  }

  Future<int> insert(UserModel user) async {
    int count = await db.insert(
      'user',
      user.toJson(),
    );
    return count;
  }

  Future<int> update(UserModel user) async {
    int count = await db.update(
      'user',
      user.toJson(),
      where: 'user_id=?',
      whereArgs: [user.id],
    );
    return count;
  }

  Future<int> delete(String id) async {
    int count = await db.delete(
      'user',
      where: 'user_id=?',
      whereArgs: [id],
    );
    return count;
  }
}
