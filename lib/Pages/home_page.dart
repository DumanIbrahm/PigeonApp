import 'package:flutter/material.dart';
import 'package:pigeon_app/models/user_model.dart';
import 'package:pigeon_app/viewModels/user_view_model.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  final MyUser user;
  const HomePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pigeon App"),
        actions: [
          TextButton(
              onPressed: (() => _signOut(context)),
              child: const Text(
                "Log Out",
                style: TextStyle(color: Colors.white),
              ))
          // IconButton(
          //   onPressed: () {
          //     () => _signOut(context);
          //   },
          //   icon: const Icon(Icons.exit_to_app),
          // ),
        ],
      ),
      body: Center(
        child: Text("Welcome ${user.uid}"),
      ),
    );
  }

  Future<bool> _signOut(BuildContext context) async {
    return await Provider.of<UserViewModel>(context, listen: false).signOut();
  }
}
