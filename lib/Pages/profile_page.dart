import 'package:flutter/material.dart';
import 'package:pigeon_app/Widgets/social_button.dart';
import 'package:pigeon_app/helper/alert_dialog_platform_sensitive.dart';
import 'package:pigeon_app/viewModels/user_view_model.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController _userNameController;

  @override
  void initState() {
    _userNameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _userNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserViewModel userViewModel = Provider.of<UserViewModel>(context);
    _userNameController.text = userViewModel.getUser!.userName!;

    return Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
              onPressed: () => checkForSignOut(context),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
              child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 75,
                  backgroundImage:
                      NetworkImage(userViewModel.getUser!.profilUrl!),
                  backgroundColor: Colors.transparent,
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _userNameController,
                    decoration: const InputDecoration(
                      labelText: "User Name",
                      border: OutlineInputBorder(),
                    ),
                  )),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: userViewModel.getUser!.email,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SocialLoginButton(
                    buttonText: "Change",
                    butonColor: Theme.of(context).primaryColor,
                    buttonIcon: null,
                    onPressed: () {
                      updateUserName(context);
                    }),
              )
            ],
          )),
        ));
  }

  Future<bool> _signOut(BuildContext context) async {
    return await Provider.of<UserViewModel>(context, listen: false).signOut();
  }

  Future checkForSignOut(context) async {
    final result = await const AlertDialogPlatformSesitive(
      title: "Are you sure?",
      content: "Do you want to sign out?",
      defaultActionText: "Sign Out",
      cancelActionText: "Cancel",
    ).show(context);

    if (result == true) {
      _signOut(context);
    }
  }

  void updateUserName(context) async {
    final userModel = Provider.of<UserViewModel>(context, listen: false);
    if (userModel.getUser!.userName != _userNameController.text) {
      var updateResult = await userModel.updateUserName(
          userModel.user!.uid, _userNameController.text);
      if (updateResult) {
        const AlertDialogPlatformSesitive(
                title: "User Name Changed!",
                content: "User name changed successfully",
                defaultActionText: "OK")
            .show(context);
      } else {
        _userNameController.text = userModel.getUser!.userName!;
        const AlertDialogPlatformSesitive(
                title: "User Name Not Changed!",
                content: "Please enter a different user name",
                defaultActionText: "OK")
            .show(context);
      }
    } else {
      const AlertDialogPlatformSesitive(
              title: "User Name Not Changed!",
              content: "Please enter a different user name",
              defaultActionText: "OK")
          .show(context);
    }
  }
}
