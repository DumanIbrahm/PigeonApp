import 'package:flutter/material.dart';
import 'package:pigeon_app/locator.dart';
import 'package:pigeon_app/models/user_model.dart';
import 'package:pigeon_app/repository/user_repository.dart';
import 'package:pigeon_app/services/auth_base.dart';

enum ViewState { idle, busy }

class UserViewModel with ChangeNotifier implements AuthBase {
  //Buradan isteklerimizi repository e yollayacağız.
  ViewState state = ViewState.idle;
  UserRepository userRepository = locator<UserRepository>();

  MyUser? user;
  MyUser? get getUser => user;
  ViewState get getState => state;

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
}
