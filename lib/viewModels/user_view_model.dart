import 'package:flutter/material.dart';
import 'package:pigeon_app/locator.dart';
import 'package:pigeon_app/models/user_model.dart';
import 'package:pigeon_app/repository/user_repository.dart';
import 'package:pigeon_app/services/auth_base.dart';
import 'package:provider/provider.dart';

enum ViewState { idle, busy }

class UserViewModel with ChangeNotifier implements AuthBase {
  //Buradan isteklerimizi repository e yollayacağız.
  ViewState state = ViewState.idle;
  UserRepository userRepository = locator<UserRepository>();

  MyUser? user;
  MyUser? get getUser => user;
  ViewState get getState => state;

  String emailErrorMesaj = "";
  String passwordErrorMesaj = "";

  UserViewModel() {
    currentUser();
  }

  set setState(ViewState value) {
    state = value;
    notifyListeners();
  }

  @override
  Future<MyUser?> currentUser() async {
    try {
      setState = ViewState.busy;
      user = await userRepository.currentUser();
      return user;
    } catch (e) {
      debugPrint("View Modeldeki Current Userda Hata: $e");
      return null;
    } finally {
      setState = ViewState.idle;
    }
  }

  @override
  Future<MyUser?> signInAnonymously() async {
    try {
      setState = ViewState.busy;
      user = await userRepository.signInAnonymously();
      return user;
    } catch (e) {
      debugPrint("View Modeldeki Sign In Anonymouslyde Hata: $e");
      return null;
    } finally {
      setState = ViewState.idle;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      setState = ViewState.busy;
      user = null;
      return await userRepository.signOut();
    } catch (e) {
      debugPrint("View Modeldeki Sign Outda Hata: $e");
      return false;
    } finally {
      setState = ViewState.idle;
    }
  }

  @override
  Future<MyUser?> signInWithGoogle() async {
    try {
      setState = ViewState.busy;
      user = await userRepository.signInWithGoogle();
      return user;
    } catch (e) {
      debugPrint("View Modeldeki Sign In Anonymouslyde Hata: $e");
      return null;
    } finally {
      setState = ViewState.idle;
    }
  }

  @override
  Future<MyUser?> createUserWithEmailAndPassword(
      String email, String password) async {
    if (checkEmailAndPassword(email, password)) {
      try {
        setState = ViewState.busy;
        user = await userRepository.createUserWithEmailAndPassword(
            email, password);
      } finally {
        setState = ViewState.idle;
      }
      return user;
    } else {
      return null;
    }
  }

  @override
  Future<MyUser?> signInWithEmailAndPassword(
      String email, String password) async {
    if (checkEmailAndPassword(email, password)) {
      setState = ViewState.busy;
      user = await userRepository.signInWithEmailAndPassword(email, password);
      setState = ViewState.idle;
      return user;
    } else {
      return null;
    }
  }

  bool checkEmailAndPassword(String email, String password) {
    bool check = true;
    if (password.length < 6) {
      passwordErrorMesaj = "Password must be at least 6 characters.";
      check = false;
    } else {
      passwordErrorMesaj = "";
    }
    if (!email.contains("@")) {
      emailErrorMesaj = "Please enter a valid email address.";
      check = false;
    } else {
      emailErrorMesaj = "";
    }
    return check;
  }

  Future<bool> updateUserName(String userID, String newUserName) async {
    var result = await userRepository.upupdateUserName(userID, newUserName);
    if (result) {
      user!.userName = newUserName;
    }
    return result;
  }
}
