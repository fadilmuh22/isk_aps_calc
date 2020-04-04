import 'dart:io';
import 'dart:async';

import 'package:isk_aps_calc/data/model/user_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
//pubspec.yml

//kelass Dbhelper
class DbHelper {
  static DbHelper _dbHelper;
  static Database _database;

  DbHelper._createObject();

  factory DbHelper() {
    if (_dbHelper == null) {
      _dbHelper = DbHelper._createObject();
    }
    return _dbHelper;
  }

  Future<Database> initDb() async {
    //untuk menentukan nama database dan lokasi yg dibuat
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'isk_aps.db';

    //create, read databases
    var todoDatabase = openDatabase(
      path,
      version: 1,
      onCreate: _createTable,
    );

    //mengembalikan nilai user sebagai hasil dari fungsinya
    return todoDatabase;
  }

  // void seedAdmin() async {
  //   Database db = await this.database;
  //   await db.execute('''
  //     INSERT INTO user(
  //       user_id, 
  //       user_name, 
  //       user_email, 
  //       user_password,
  //       institute, 
  //       status
  //     ) VALUES(
  //       'admin',
  //       'admin',
  //       'admin',
  //       'adminspmtelu',
  //       'Admin SPM Telkom University',
  //       1
  //     )
  //   ''');
  // }

  //buat tabel baru dengan nama contact
  void _createTable(Database db, int version) async {
    await db.execute('''
      CREATE TABLE user (
        user_id VARCHAR(255) PRIMARY KEY,
        user_name VARCHAR(255),
        user_email VARCHAR(255) UNIQUE,
        user_password TEXT,
        institute VARCHAR(255),
        status INTEGER,
        update_dtm DATETIME 
      );
    ''');
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

  Future<Map<String, dynamic>> selectOne(String username) async {
    Database db = await this.database;
    var mapList = await db.query(
      'user',
      where: 'user_email=? OR user_name=?',
      whereArgs: [username, username],
      limit: 1
    );
    return mapList[0];
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
