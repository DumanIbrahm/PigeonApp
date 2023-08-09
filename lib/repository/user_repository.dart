import 'dart:io';
import 'package:pigeon_app/locator.dart';
import 'package:pigeon_app/models/message_model.dart';
import 'package:pigeon_app/models/user_model.dart';
import 'package:pigeon_app/services/auth_base.dart';
import 'package:pigeon_app/services/fake_firebase_service.dart';
import 'package:pigeon_app/services/firebase_auth_service.dart';
import 'package:pigeon_app/services/firebase_storage_service.dart';
import 'package:pigeon_app/services/firestore_db_service.dart';

enum AppMode { debug, release }

class UserRepository implements AuthBase {
  FirebaseAuthService firebaseAuthService = locator<FirebaseAuthService>();
  FakeAuthenticationService fakeAuthenticationService =
      locator<FakeAuthenticationService>();
  FirestoreDbService firestoreDbService = locator<FirestoreDbService>();
  FirebaseStorageService firebaseStorageService =
      locator<FirebaseStorageService>();

  AppMode appMode = AppMode.release;

  @override
  Future<MyUser?> currentUser() async {
    if (appMode == AppMode.debug) {
      return await fakeAuthenticationService.currentUser();
    } else {
      MyUser? user = await firebaseAuthService.currentUser();
      return await firestoreDbService.readUser(user!.uid);
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
        return await firestoreDbService.readUser(user.uid);
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
        return await firestoreDbService.readUser(user.uid);
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
      MyUser? user =
          await firebaseAuthService.signInWithEmailAndPassword(email, password);
      return await firestoreDbService.readUser(user!.uid);
    }
  }

  Future<bool> updateUserName(String userID, String newUserName) async {
    if (appMode == AppMode.debug) {
      return false;
    } else {
      return await firestoreDbService.updateUserName(userID, newUserName);
    }
  }

  Future<String> updateFile(String uid, String fileType, File file) async {
    if (appMode == AppMode.debug) {
      return "File Update Url";
    } else {
      var url = await firebaseStorageService.uploadFile(uid, fileType, file);
      await firestoreDbService.updatePhoto(uid, url);
      return url;
    }
  }

  Future<List<MyUser>?> getAllUsers() {
    if (appMode == AppMode.debug) {
      return Future.value([]);
    } else {
      return firestoreDbService.getAllUsers();
    }
  }

  Stream<List<MessageModel>>? getMessages(
      String currentUserID, String chatUserID) {
    if (appMode == AppMode.debug) {
      return null;
    } else {
      return firestoreDbService.getMessages(currentUserID, chatUserID);
    }
  }

  Future<bool> saveMessage(MessageModel messageModel) async {
    if (appMode == AppMode.debug) {
      return true;
    } else {
      return firestoreDbService.saveMessage(messageModel);
    }
  }
}
