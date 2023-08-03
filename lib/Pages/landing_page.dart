import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pigeon_app/Pages/home_page.dart';
import 'package:pigeon_app/Pages/sign_in_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  late User? _user;

  @override
  void initState() {
    _user = FirebaseAuth.instance.currentUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Kullanıcı girişi var ise direk ana sayfaya yönlendiriyorum.
    if (_user == null) {
      return SignInPage(onSignIn: (user) {
        _updateUser(user);
      });
    } else {
      return HomePage(
          user: _user!,
          onSignOut: () {
            _updateUser(null);
          });
    }
  }

  //Useri update ediyorum.
  void _updateUser(User? user) {
    setState(() {
      _user = user;
    });
  }
}
