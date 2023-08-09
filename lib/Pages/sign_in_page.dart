import 'package:flutter/material.dart';
import 'package:pigeon_app/Widgets/social_button.dart';
import 'package:pigeon_app/helper/sign_in_with_email.dart';
import 'package:pigeon_app/viewModels/user_view_model.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // const Text(
              //   "Sign In",
              //   textAlign: TextAlign.center,
              //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
              // ),
              // const SizedBox(
              //   height: 8,
              // ),
              const Image(
                width: 200,
                height: 200,
                image: NetworkImage(
                    "https://cdn.shopify.com/s/files/1/0231/9450/1197/files/Morning-Bird-Animated-Bird-4.15.20-White.gif?v=1586988077"),
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
                onPressed: () => _googleSignIn(context),
              ),
              // SocialLoginButton(
              //   buttonText: "Sign In with Facebook",
              //   butonColor: Colors.blue,
              //   textColor: Colors.white,
              //   buttonIcon: Image.asset(
              //     "images/facebook-logo.png",
              //     width: 30,
              //     height: 30,
              //   ),
              //   onPressed: () {},
              // ),
              SocialLoginButton(
                buttonText: "Sign In with Email and Password",
                butonColor: const Color(0xFF334092),
                textColor: Colors.white,
                buttonIcon: const Icon(
                  Icons.mail,
                  color: Colors.white,
                  size: 32,
                ),
                onPressed: () => _signInWithEmailAndPassword(context),
              ),
              // SocialLoginButton(
              //   buttonText: "Anonymous Sign In",
              //   butonColor: Colors.teal,
              //   textColor: Colors.white,
              //   buttonIcon: const Icon(
              //     Icons.supervised_user_circle,
              //     color: Colors.white,
              //     size: 32,
              //   ),
              //   onPressed: (() => anonymousSignIn(context)),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  // void anonymousSignIn(BuildContext context) async {
  //   final user = Provider.of<UserViewModel>(context, listen: false);
  //   await user.signInAnonymously();
  // }

  void _googleSignIn(BuildContext context) async {
    final user = Provider.of<UserViewModel>(context, listen: false);
    await user.signInWithGoogle();
  }

  void _signInWithEmailAndPassword(BuildContext context) async {
    Navigator.of(context).push(MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => const SignInWithEmailAndPassword()));
  }
}
