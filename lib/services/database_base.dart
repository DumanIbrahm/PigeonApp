import 'package:pigeon_app/models/user_model.dart';

abstract class DBBase {
  Future<bool> saveUser(MyUser user);
  Future<MyUser> readUser(String userID);
  Future<bool> updateUserName(String userID, String newUserName);
}
