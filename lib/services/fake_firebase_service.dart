import 'package:pigeon_app/models/user_model.dart';
import 'package:pigeon_app/services/auth_base.dart';

class FakeAuthenticationService implements AuthBase {
  String userID = "12321321321312";
  @override
  Future<MyUser> currentUser() async {
    return await Future.value(MyUser(uid: userID, email: "current_user_email"));
  }

  @override
  Future<MyUser> signInAnonymously() async {
    return await Future.delayed(const Duration(seconds: 2),
        () => MyUser(uid: userID, email: "signed_in_user_email"));
  }

  @override
  Future<bool> signOut() {
    return Future.value(true);
  }

  @override
  Future<MyUser?> signInWithGoogle() async {
    return await Future.delayed(const Duration(seconds: 2),
        () => MyUser(uid: "google_user_id", email: "google_user_email"));
  }

  @override
  Future<MyUser?> createUserWithEmailAndPassword(
      String email, String password) async {
    return Future.value(
        MyUser(uid: "created_user_id", email: "created_user_email"));
  }

  @override
  Future<MyUser?> signInWithEmailAndPassword(
      String email, String password) async {
    return await Future.delayed(const Duration(seconds: 2),
        () => MyUser(uid: "sign_in_user_id", email: "sign_in_user_email"));
  }
}
