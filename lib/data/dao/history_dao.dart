import 'package:isk_aps_calc/data/model/history_model.dart';
import 'package:isk_aps_calc/data/repository/app_database.dart';
import 'package:sqflite/sqflite.dart';

class HistoryDao {
  String table = 'history';

  Future<int> insert(
    HistoryModel history,
  ) async {
    Database db = await AppDatabase().db;
    int count = await db.insert(
      table,
      history.toJson(),
    );
    return count;
  }

  Future<List<HistoryModel>> select(String userId) async {
    Database db = await AppDatabase().db;
    var mapList =
        await db.query(table, where: 'user_id=?', whereArgs: [userId]);
    return mapList
        .map<HistoryModel>((history) => HistoryModel.fromJson(history))
        .toList();
  }

  Future<HistoryModel> selectOne(int id) async {
    Database db = await AppDatabase().db;
    var mapList = await db.query(
      table,
      where: 'history_id=?',
      whereArgs: [id],
      limit: 1,
    );
    if (mapList.isNotEmpty) {
      return HistoryModel.fromJson(mapList[0]);
    }

    return null;
  }

  Future<int> update(HistoryModel history) async {
    Database db = await AppDatabase().db;
    int count = await db.update(
      table,
      history.toJson(),
      where: 'history_id=?',
      whereArgs: [history.id],
    );
    return count;
  }

  Future<int> delete(int id) async {
    Database db = await AppDatabase().db;
    int count = await db.delete(
      table,
      where: 'history_id=?',
      whereArgs: [id],
    );
    return count;
  }
}
