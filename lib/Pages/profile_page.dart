import 'package:flutter/material.dart';
import 'package:pigeon_app/viewModels/user_view_model.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
              onPressed: () => _signOut(context),
            )
          ],
        ),
        body: const Center(
          child: Text("Profile Page"),
        ));
  }

  Future<bool> _signOut(BuildContext context) async {
    return await Provider.of<UserViewModel>(context, listen: false).signOut();
  }
}
