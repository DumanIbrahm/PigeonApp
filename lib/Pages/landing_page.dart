import 'package:flutter/material.dart';
import 'package:pigeon_app/Pages/home_page.dart';
import 'package:pigeon_app/Pages/sign_in_page.dart';
import 'package:pigeon_app/viewModels/user_view_model.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userModel = Provider.of<UserViewModel>(context);

    if (userModel.state == ViewState.idle) {
      if (userModel.user == null) {
        return SignInPage();
      } else {
        return HomePage(
          user: userModel.user,
        );
      }
    } else {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
