import 'package:rxdart/rxdart.dart';

import '../../common/utilites/logger.dart';
import '../../model/user_data.dart';
import '../data_base/db_manager.dart';

class UserDataStore {
  final DBManager _dbManager;
  UserData? _user;

  BehaviorSubject<void> _permissionChanged = BehaviorSubject();
  Stream<void> get permissionChanged => _permissionChanged;
  UserDataStore(this._dbManager);

  Future<UserData?> getUser() async {
    final user = await _dbManager.queryAllRows<UserData>();

    if (user.isNotEmpty) {
      Map<String, dynamic> userMap = Map.from(user.first);

      _user = UserData.fromJson(userMap);
      return _user;
    } else {
      return null;
    }
  }

  Future<int> insert(UserData u) async {
    printLog("APPLOG", "Insert message");
    await _dbManager.delete<UserData>();
    final userJson = u.toJson();

    return _dbManager.insert<UserData>(userJson);
  }
  Future<int> update(UserData u) async {
    printLog("APPLOG", "Insert message");
    await _dbManager.delete<UserData>();
    final userJson = u.toJson();
    return _dbManager.update<UserData>(userJson);
  }


  Future<int> deleteUser() async {
    _user = null;

    return _dbManager.delete<UserData>();
  }


}