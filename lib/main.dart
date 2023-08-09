import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pigeon_app/Pages/landing_page.dart';
import 'package:pigeon_app/locator.dart';
import 'package:pigeon_app/palette.dart';
import 'package:pigeon_app/viewModels/user_view_model.dart';
import 'package:provider/provider.dart';

void main() async {
  setUpLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance
      .activate(webRecaptchaSiteKey: 'your-recaptcha-site-key');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserViewModel(),
      child: MaterialApp(
          title: 'Pigeon App',
          theme: ThemeData(
            primaryColor: Pallete.appBarColor,
          ),
          debugShowCheckedModeBanner: false,
          home: const LandingPage()),
    );
  }
}
