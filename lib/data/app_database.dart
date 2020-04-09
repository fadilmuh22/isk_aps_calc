import 'dart:io';
import 'dart:async';

import 'package:isk_aps_calc/data/model/user_model.dart';
import 'package:password/password.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
//pubspec.yml

//kelass Dbhelper
class AppDatabase {
  static AppDatabase _appDb;
  static Database _database;

  AppDatabase._createObject();

  factory AppDatabase() {
    if (_appDb == null) {
      _appDb = AppDatabase._createObject();
    }
    return _appDb;
  }

  final initScript = [
    '''
      CREATE TABLE user (
        user_id VARCHAR(255) PRIMARY KEY,
        user_name VARCHAR(255),
        user_email VARCHAR(255) UNIQUE,
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
        ${Password.hash('adminspmtelu', new PBKDF2())},
        'Admin SPM Telkom University',
        1
      )
    ''',
  ];

  Future<Database> initDb() async {
    //untuk menentukan nama database dan lokasi yg dibuat
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'isk_aps.db';

    //create, read databases
    var todoDatabase = openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        initScript.forEach((script) async => await db.execute(script));
      },
      // onUpgrade: (Database db, int oldVersion, int newVersion) async {
      //   for (var i = oldVersion - 1; i <= newVersion - 1; i++) {
      //     await db.execute(migrationScripts[i]);
      //   }
      // }
    );

    //mengembalikan nilai user sebagai hasil dari fungsinya
    return todoDatabase;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initDb();
    }
    return _database;
  }

  Future<List<Map<String, dynamic>>> select() async {
    Database db = await this.database;
    var mapList = await db.query(
      'user',
      orderBy: 'user_name',
    );
    return mapList;
  }

  Future<UserModel> selectOne(String username) async {
    Database db = await this.database;
    var mapList = await db.query(
      'user',
      where: 'user_email=? OR user_name=?',
      whereArgs: [username, username],
      limit: 1,
    );
    return UserModel.fromMap(mapList[0]);
  }

//create databases
  Future<int> insert(UserModel user) async {
    Database db = await this.database;
    int count = await db.insert(
      'user',
      user.toMap(),
    );
    return count;
  }

//update databases
  Future<int> update(UserModel user) async {
    Database db = await this.database;
    int count = await db.update(
      'user',
      user.toMap(),
      where: 'user_id=?',
      whereArgs: [user.id],
    );
    return count;
  }

  //delete databases
  Future<int> delete(String id) async {
    Database db = await this.database;
    int count = await db.delete(
      'user',
      where: 'id=?',
      whereArgs: [id],
    );
    return count;
  }
}
