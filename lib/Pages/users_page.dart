import 'package:flutter/material.dart';
import 'package:pigeon_app/Pages/message_page.dart';
import 'package:pigeon_app/models/user_model.dart';
import 'package:pigeon_app/viewModels/user_view_model.dart';
import 'package:provider/provider.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    UserViewModel userModel = Provider.of<UserViewModel>(context);
    userModel.getAllUsers;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Users"),
        ),
        body: FutureBuilder<List<MyUser>>(
            future: userModel.getAllUsers(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var allUsers = snapshot.data;
                if (allUsers!.length - 1 > 0) {
                  return ListView.builder(
                      itemCount: allUsers.length,
                      itemBuilder: (context, index) {
                        var currentUser = allUsers[index];
                        if (snapshot.data![index].uid != userModel.user!.uid) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context, rootNavigator: true)
                                  .push(MaterialPageRoute(
                                      builder: (context) => MessagePage(
                                            currentUser: userModel.user,
                                            chatUser: currentUser,
                                          )));
                            },
                            child: ListTile(
                              leading: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(currentUser.profilUrl!)),
                              title: Text(currentUser.userName!),
                              subtitle: Text(currentUser.email),
                            ),
                          );
                        } else {
                          return const SizedBox();
                        }
                      });
                } else {
                  return const Center(child: Text("No user found"));
                }
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }));
  }
}
