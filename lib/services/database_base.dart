import 'package:pigeon_app/models/user_model.dart';

abstract class DBBase {
  Future<bool> saveUser(MyUser user);
}
