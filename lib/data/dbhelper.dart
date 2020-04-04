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
    var todoDatabase = openDatabase(path, version: 1, onCreate: _createTable);

    //mengembalikan nilai user sebagai hasil dari fungsinya
    return todoDatabase;
  }

    //buat tabel baru dengan nama contact
  void _createTable(Database db, int version) async {
    await db.execute('''
      CREATE TABLE user (
        user_id VARCHAR(255) PRIMARY KEY,
        user_name VARCHAR(255),
        user_email VARCHAR(255),
        user_password TEXT,
        institute VARCHAR(255),
        status INTEGER()
      )
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
    var mapList = await db.query('user', orderBy: 'user_name');
    return mapList;
  }

//create databases
  Future<int> insert(UserModel user) async {
    Database db = await this.database;
    int count = await db.insert('user', user.toMap());
    return count;
  }
//update databases
  Future<int> update(UserModel user) async {
    Database db = await this.database;
    int count = await db.update('user', user.toMap(), 
                                where: 'user_id=?',
                                whereArgs: [user.userId]);
    return count;
  }

//delete databases
  Future<int> delete(int id) async {
    Database db = await this.database;
    int count = await db.delete('contact', 
                                where: 'id=?', 
                                whereArgs: [id]);
    return count;
  }

}