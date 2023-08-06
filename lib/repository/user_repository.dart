import 'package:pigeon_app/locator.dart';
import 'package:pigeon_app/models/user_model.dart';
import 'package:pigeon_app/services/auth_base.dart';
import 'package:pigeon_app/services/fake_firebase_service.dart';
import 'package:pigeon_app/services/firebase_auth_service.dart';
import 'package:pigeon_app/services/firestore_db_service.dart';

enum AppMode { debug, release }

class UserRepository implements AuthBase {
  FirebaseAuthService firebaseAuthService = locator<FirebaseAuthService>();
  FakeAuthenticationService fakeAuthenticationService =
      locator<FakeAuthenticationService>();
  FirestoreDbService firestoreDbService = locator<FirestoreDbService>();

  AppMode appMode = AppMode.release;

  @override
  Future<MyUser?> currentUser() async {
    if (appMode == AppMode.debug) {
      return await fakeAuthenticationService.currentUser();
    } else {
      return await firebaseAuthService.currentUser();
    }
  }

  @override
  Future<MyUser?> signInAnonymously() async {
    if (appMode == AppMode.debug) {
      return await fakeAuthenticationService.signInAnonymously();
    } else {
      return await firebaseAuthService.signInAnonymously();
    }
  }

  @override
  Future<bool> signOut() async {
    if (appMode == AppMode.debug) {
      return await fakeAuthenticationService.signOut();
    } else {
      return await firebaseAuthService.signOut();
    }
  }

  @override
  Future<MyUser?> signInWithGoogle() async {
    if (appMode == AppMode.debug) {
      return await fakeAuthenticationService.signInWithGoogle();
    } else {
      MyUser? user = await firebaseAuthService.signInWithGoogle();
      bool result = await firestoreDbService.saveUser(user!);
      if (result) {
        return user;
      } else {
        return null;
      }
    }
  }

  @override
  Future<MyUser?> createUserWithEmailAndPassword(
      String email, String password) async {
    if (appMode == AppMode.debug) {
      return await fakeAuthenticationService.createUserWithEmailAndPassword(
          email, password);
    } else {
      MyUser? user = await firebaseAuthService.createUserWithEmailAndPassword(
          email, password);
      bool result = await firestoreDbService.saveUser(user!);
      if (result) {
        return user;
      } else {
        return null;
      }
    }
  }

  @override
  Future<MyUser?> signInWithEmailAndPassword(
      String email, String password) async {
    if (appMode == AppMode.debug) {
      return await fakeAuthenticationService.signInWithEmailAndPassword(
          email, password);
    } else {
      return await firebaseAuthService.signInWithEmailAndPassword(
          email, password);
    }
  }
}
