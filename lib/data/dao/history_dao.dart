import 'package:isk_aps_calc/data/model/history_model.dart';
import 'package:isk_aps_calc/data/repository/app_database.dart';

class HistoryDao {
  String table = 'history';

  Future<int> insert(
    HistoryModel history,
  ) async {
    int count = await AppDatabase().db.insert(
          table,
          history.toJson(),
        );
    return count;
  }

  Future<List<HistoryModel>> select() async {
    var mapList = await AppDatabase().db.query(
          table,
        );
    print(mapList);
    return mapList
        .map<HistoryModel>((history) => HistoryModel.fromJson(history))
        .toList();
  }

  Future<HistoryModel> selectOne(int id) async {
    var mapList = await AppDatabase().db.query(
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
    int count = await AppDatabase().db.update(
      table,
      history.toJson(),
      where: 'history_id=?',
      whereArgs: [history.id],
    );
    return count;
  }

  Future<int> delete(String id) async {
    int count = await AppDatabase().db.delete(
      table,
      where: 'history_id=?',
      whereArgs: [id],
    );
    return count;
  }
}
