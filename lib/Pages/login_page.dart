import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pigeon_app/Widgets/social_button.dart';
import 'package:firebase_core/firebase_core.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        body: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                "Sign In",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
              ),
              const SizedBox(
                height: 8,
              ),
              SocialLoginButton(
                buttonText: "Sign In with Google",
                butonColor: Colors.white,
                textColor: Colors.black87,
                buttonIcon: Image.asset(
                  "images/Google-logo.png",
                  width: 30,
                  height: 30,
                ),
                onPressed: () {},
              ),
              SocialLoginButton(
                buttonText: "Sign In with Facebook",
                butonColor: Colors.blue,
                textColor: Colors.white,
                buttonIcon: Image.asset(
                  "images/facebook-logo.png",
                  width: 30,
                  height: 30,
                ),
                onPressed: () {},
              ),
              SocialLoginButton(
                buttonText: "Sign In with Email and Password",
                butonColor: const Color(0xFF334092),
                textColor: Colors.white,
                buttonIcon: const Icon(
                  Icons.mail,
                  color: Colors.white,
                  size: 32,
                ),
                onPressed: () {},
              ),
              SocialLoginButton(
                buttonText: "Anonymous Sign In",
                butonColor: Colors.teal,
                textColor: Colors.white,
                buttonIcon: const Icon(
                  Icons.supervised_user_circle,
                  color: Colors.white,
                  size: 32,
                ),
                onPressed: anonymousSignIn,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void anonymousSignIn() async {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInAnonymously();
    User user = userCredential.user!;

    print('Signed in anonymously with User ID: ${user.uid}');
  }
}
