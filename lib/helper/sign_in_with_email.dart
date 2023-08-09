import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pigeon_app/Widgets/social_button.dart';
import 'package:pigeon_app/helper/alert_dialog_platform_sensitive.dart';
import 'package:pigeon_app/helper/exception_handler.dart';
import 'package:pigeon_app/palette.dart';
import 'package:pigeon_app/viewModels/user_view_model.dart';
import 'package:provider/provider.dart';

enum FormType { register, logIn }

class SignInWithEmailAndPassword extends StatefulWidget {
  const SignInWithEmailAndPassword({super.key});

  @override
  State<SignInWithEmailAndPassword> createState() =>
      _SignInWithEmailAndPasswordState();
}

class _SignInWithEmailAndPasswordState
    extends State<SignInWithEmailAndPassword> {
  String email = "";
  String password = "";
  String password2 = "";
  String buttonText = "";
  String linkText = "";
  var formType = FormType.logIn;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    buttonText = formType == FormType.logIn ? "Log In" : "Create Account";
    linkText = formType == FormType.logIn
        ? "Don't have an account? Sign in."
        : "Have an account? Log in.";

    final userModel = Provider.of<UserViewModel>(context);
    if (userModel.user != null) {
      Future.delayed(const Duration(milliseconds: 10))
          .then((value) => Navigator.of(context).pop());
    }

    return Scaffold(
      backgroundColor: Pallete.backgroundColor,
      appBar: AppBar(
        backgroundColor: Pallete.appBarColor,
        title: Text(
          "Log In",
          style: TextStyle(color: Pallete.backgroundColor),
        ),
      ),
      body: userModel.state == ViewState.idle
          ? Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Image.asset("images/icon.png", width: 150, height: 150),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            errorText: userModel.emailErrorMesaj != ""
                                ? userModel.emailErrorMesaj
                                : null,
                            prefixIcon: const Icon(Icons.email),
                            labelText: "Email",
                            hintText: "Enter your email",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          onChanged: (value) => email = value,
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                            errorText: userModel.passwordErrorMesaj != ""
                                ? userModel.passwordErrorMesaj
                                : null,
                            prefixIcon: const Icon(Icons.lock),
                            labelText: "Password",
                            hintText: "Enter your password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          onChanged: (value) => password = value,
                        ),
                        const SizedBox(height: 8),
                        formType == FormType.register
                            ? TextFormField(
                                obscureText: true,
                                decoration: InputDecoration(
                                  errorText: password == password2
                                      ? null
                                      : "Passwords do not match",
                                  prefixIcon: const Icon(Icons.lock),
                                  labelText: "Password",
                                  hintText: "Enter your password again",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                                onChanged: (value) => password2 = value,
                              )
                            : const SizedBox(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SocialLoginButton(
                            buttonText: buttonText,
                            butonColor: Theme.of(context).primaryColor,
                            buttonIcon: const Icon(Icons.login),
                            onPressed: () => _formSubmit(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextButton(
                            onPressed: () => _change(), child: Text(linkText))
                      ],
                    ),
                  ),
                ),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  void _formSubmit() async {
    _formKey.currentState!.save();
    final userModel = Provider.of<UserViewModel>(context, listen: false);

    if (formType == FormType.logIn) {
      try {
        await userModel.signInWithEmailAndPassword(email, password);
      } on PlatformException catch (e) {
        String mesaj = ExceptionHandler.getErrorMessage(e.code.toString());
        AlertDialogPlatformSesitive(
                title: "Error", content: mesaj, defaultActionText: "OK")
            .show(context);
      }
    } else {
      try {
        await userModel.createUserWithEmailAndPassword(email, password);
      } on PlatformException catch (e) {
        String mesaj = ExceptionHandler.getErrorMessage(e.code.toString());
        AlertDialogPlatformSesitive(
                title: "Error", content: mesaj, defaultActionText: "OK")
            .show(context);
      }
    }
  }

  void _change() {
    setState(() {
      formType =
          formType == FormType.logIn ? FormType.register : FormType.logIn;
    });
  }
}
