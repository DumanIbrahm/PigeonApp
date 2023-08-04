import 'package:flutter/material.dart';
import 'package:pigeon_app/models/user_model.dart';
import 'package:pigeon_app/viewModels/user_view_model.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  final UserDT user;
  const HomePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pigeon App"),
        actions: [
          IconButton(
            onPressed: () {
              () => _signOut(context);
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: Center(
        child: Text("Welcome ${user.uid}"),
      ),
    );
  }

  Future<bool> _signOut(BuildContext context) async {
    final userModel = Provider.of<UserViewModel>(context);
    bool result = await userModel.signOut();
    return result;
  }
}
