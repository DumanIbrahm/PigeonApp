import 'package:pigeon_app/models/user_model.dart';

abstract class AuthBase {
  Future<UserDT> currentUser();
  Future<UserDT> signInAnonymously();
  Future<bool> signOut();
}
