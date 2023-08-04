import 'package:pigeon_app/models/user_model.dart';
import 'package:pigeon_app/services/auth_base.dart';

class FakeAuthenticationService implements AuthBase {
  String userID = "12321321321312";
  @override
  Future<UserDT> currentUser() async {
    return await Future.value(UserDT(uid: userID));
  }

  @override
  Future<UserDT> signInAnonymously() async {
    return await Future.delayed(
        const Duration(seconds: 2), () => UserDT(uid: userID));
  }

  @override
  Future<bool> signOut() {
    return Future.value(true);
  }
}
