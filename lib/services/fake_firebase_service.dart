import 'package:pigeon_app/models/user_model.dart';
import 'package:pigeon_app/services/auth_base.dart';

class FakeAuthenticationService implements AuthBase {
  String userID = "12321321321312";
  @override
  Future<MyUser> currentUser() async {
    return await Future.value(MyUser(uid: userID));
  }

  @override
  Future<MyUser> signInAnonymously() async {
    return await Future.delayed(
        const Duration(seconds: 2), () => MyUser(uid: userID));
  }

  @override
  Future<bool> signOut() {
    return Future.value(true);
  }
}
