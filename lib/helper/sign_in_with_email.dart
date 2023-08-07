import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pigeon_app/Widgets/social_button.dart';
import 'package:pigeon_app/helper/alert_dialog_platform_sensitive.dart';
import 'package:pigeon_app/helper/exception_handler.dart';
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
      appBar: AppBar(
        title: const Text("Log In"),
      ),
      body: userModel.state == ViewState.idle
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          errorText: userModel.emailErrorMesaj != ""
                              ? userModel.emailErrorMesaj
                              : null,
                          prefixIcon: const Icon(Icons.email),
                          labelText: "Email",
                          hintText: "Enter your email",
                          border: const OutlineInputBorder(),
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
                          border: const OutlineInputBorder(),
                        ),
                        onChanged: (value) => password = value,
                      ),
                      const SizedBox(height: 8),
                      SocialLoginButton(
                        buttonText: buttonText,
                        butonColor: Theme.of(context).primaryColor,
                        buttonIcon: const Icon(Icons.login),
                        onPressed: () => _formSubmit(),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                          onPressed: () => _change(), child: Text(linkText))
                    ],
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
        AlertDialogPlatformSesitive(
                title: "Error",
                content: ExceptionHandler.getErrorMessage(e.code.toString()),
                defaultActionText: "OK")
            .show(context);
      }
    } else {
      try {
        await userModel.createUserWithEmailAndPassword(email, password);
      } on PlatformException catch (e) {
        ExceptionHandler.getErrorMessage(e.code.toString());
        AlertDialogPlatformSesitive(
                title: "Error",
                content: ExceptionHandler.getErrorMessage(e.code.toString()),
                defaultActionText: "OK")
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
