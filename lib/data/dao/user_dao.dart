import 'package:isk_aps_calc/data/repository/app_database.dart';
import 'package:isk_aps_calc/data/model/user_model.dart';

class UserDao {
  String table = 'users';

  Future<List<UserModel>> select() async {
    var mapList = await AppDatabase().db.query(
          table,
          orderBy: 'user_name',
        );
    return mapList.map<UserModel>((user) => UserModel.fromJson(user)).toList();
  }

  Future<UserModel> selectOne(String username) async {
    var mapList = await AppDatabase().db.query(
          table,
          where: 'user_email=? OR user_name=?',
          whereArgs: [username, username],
          limit: 1,
        );
    if (mapList.isNotEmpty) {
      return UserModel.fromJson(mapList[0]);
    }

    return null;
  }

  Future<int> insert(UserModel user) async {
    int count = await AppDatabase().db.insert(
          table,
          user.toJson(),
        );
    return count;
  }

  Future<int> update(UserModel user) async {
    int count = await AppDatabase().db.update(
      table,
      user.toJson(),
      where: 'user_id=?',
      whereArgs: [user.id],
    );
    return count;
  }

  Future<int> delete(String id) async {
    int count = await AppDatabase().db.delete(
      table,
      where: 'user_id=?',
      whereArgs: [id],
    );
    return count;
  }
}
