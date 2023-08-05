import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pigeon_app/models/user_model.dart';

import 'auth_base.dart';

class FirebaseAuthService implements AuthBase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<MyUser?> currentUser() async {
    try {
      User? user = _firebaseAuth.currentUser;
      return _userFromFirebase(user);
    } catch (e) {
      print("Hata current user: " + e.toString());
      return null;
    }
  }

  MyUser? _userFromFirebase(User? user) {
    if (user == null) {
      return null;
    }
    return MyUser(uid: user.uid);
  }

  @override
  Future<MyUser?> signInAnonymously() async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInAnonymously();
      return _userFromFirebase(userCredential.user!);
    } catch (e) {
      print("Hata sign in anonymously: " + e.toString());
      return null;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      final _googleSignIn = GoogleSignIn();
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<MyUser?> signInWithGoogle() async {
    GoogleSignIn _googleSignIn = GoogleSignIn();
    GoogleSignInAccount? _googleUser = await _googleSignIn.signIn();
    if (_googleUser != null) {
      GoogleSignInAuthentication _googleAuth = await _googleUser.authentication;
      if (_googleAuth.idToken != null && _googleAuth.accessToken != null) {
        UserCredential result = await _firebaseAuth.signInWithCredential(
            GoogleAuthProvider.credential(
                idToken: _googleAuth.idToken,
                accessToken: _googleAuth.accessToken));
        User? _user = result.user;
        return _userFromFirebase(_user);
      } else {
        return null;
      }
    }
  }
}
