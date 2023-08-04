import 'package:firebase_auth/firebase_auth.dart';
import 'package:pigeon_app/models/user_model.dart';

import 'auth_base.dart';

class FirebaseAuthService implements AuthBase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<UserDT> currentUser() async {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user != null) {
        return _userFromFirebase(user);
      } else {
        return null!;
      }
    } catch (e) {
      print("Hata Current User: " + e.toString());
      return null!;
    }
  }

  UserDT _userFromFirebase(User user) {
    return UserDT(uid: user.uid);
  }

  @override
  Future<UserDT> signInAnonymously() async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInAnonymously();
      return _userFromFirebase(userCredential.user!);
    } catch (e) {
      print("Hata Sign In Anonymously: " + e.toString());
      return null!;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      print("Hata Sign Out: " + e.toString());
      return false;
    }
  }
}
