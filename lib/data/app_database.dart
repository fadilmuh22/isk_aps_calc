import 'dart:io';
import 'dart:async';

import 'package:dbcrypt/dbcrypt.dart';
import 'package:isk_aps_calc/data/model/user_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
//pubspec.yml

//kelass Dbhelper
class AppDatabase {
  static Database _db;

  static final AppDatabase _instance = AppDatabase.internal();

  factory AppDatabase() => _instance;

  AppDatabase.internal();

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
  ]; //'${Password.hash('adminspmtelu', new PBKDF2())}',

  Future<Database> initDb() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'isk_aps.db';

    await deleteDatabase(path);

    var todoDatabase = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        initScript.forEach((script) async => await db.execute(script));
      },
    );

    return todoDatabase;
  }

  Future<Database> get db async {
    if (_db == null) {
      _db = await initDb();
    }

    return _db;
  }

  Future<List<UserModel>> select() async {
    Database db = await this.db;
    var mapList = await db.query(
      'user',
      orderBy: 'user_name',
    );
    return mapList.map<UserModel>((user) => UserModel.fromMap(user)).toList();
  }

  Future<UserModel> selectOne(String username) async {
    Database db = await this.db;
    var mapList = await db.query(
      'user',
      where: 'user_email=? OR user_name=?',
      whereArgs: [username, username],
      limit: 1,
    );
    if (mapList.isNotEmpty) {
      return UserModel.fromMap(mapList[0]);
    }
  }

  //create databases
  Future<int> insert(UserModel user) async {
    Database db = await this.db;
    int count = await db.insert(
      'user',
      user.toMap(),
    );
    return count;
  }

//update databases
  Future<int> update(UserModel user) async {
    Database db = await this.db;
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
    Database db = await this.db;
    int count = await db.delete(
      'user',
      where: 'id=?',
      whereArgs: [id],
    );
    return count;
  }
}
