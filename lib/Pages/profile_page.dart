import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pigeon_app/Widgets/social_button.dart';
import 'package:pigeon_app/helper/alert_dialog_platform_sensitive.dart';
import 'package:pigeon_app/palette.dart';
import 'package:pigeon_app/viewModels/user_view_model.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController _userNameController;
  XFile? profilPhoto;

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
        backgroundColor: Pallete.backgroundColor,
        appBar: AppBar(
          backgroundColor: Pallete.appBarColor,
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
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return SizedBox(
                            height: 160,
                            child: Column(
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.camera),
                                  title: const Text("Take a photo from camera"),
                                  onTap: () {
                                    _takePhotoFromCamera();
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.image),
                                  title:
                                      const Text("Select a photo from gallery"),
                                  onTap: () {
                                    _selectPhotoFromGallery();
                                  },
                                ),
                              ],
                            ),
                          );
                        });
                  },
                  child: CircleAvatar(
                    radius: 75,
                    backgroundImage: profilPhoto == null
                        ? NetworkImage(userViewModel.getUser!.profilUrl!)
                        : FileImage(File(profilPhoto!.path)) as ImageProvider,
                    backgroundColor: Colors.transparent,
                  ),
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
                      updatePhoto(context);
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
    }
  }

  void _takePhotoFromCamera() async {
    var newProfilPhoto =
        await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      profilPhoto = newProfilPhoto;
      Navigator.of(context).pop();
    });
  }

  void _selectPhotoFromGallery() async {
    var newProfilPhoto =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      profilPhoto = newProfilPhoto;
      Navigator.of(context).pop();
    });
  }

  void updatePhoto(context) async {
    final userModel = Provider.of<UserViewModel>(context, listen: false);
    if (profilPhoto != null) {
      var url = await userModel.uploadFile(
          userModel.user!.uid, "profil_photo", File(profilPhoto!.path));
      if (url != "") {
        const AlertDialogPlatformSesitive(
                title: "Success!",
                content: "Photo Changed",
                defaultActionText: "OK")
            .show(context);
      }
    }
  }
}
