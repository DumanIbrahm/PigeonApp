import 'package:pigeon_app/models/user_model.dart';

abstract class AuthBase {
  Future<MyUser?> currentUser();
  Future<MyUser?> signInAnonymously();
  Future<bool> signOut();
}
