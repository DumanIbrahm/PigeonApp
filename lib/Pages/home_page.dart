import 'package:flutter/material.dart';
import 'package:pigeon_app/Pages/profile_page.dart';
import 'package:pigeon_app/Pages/users_page.dart';
import 'package:pigeon_app/helper/bottom_navigation.dart';
import 'package:pigeon_app/helper/tab_items.dart';
import 'package:pigeon_app/models/user_model.dart';

class HomePage extends StatefulWidget {
  final MyUser user;
  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem currentTab = TabItem.users;
  Map<TabItem, Widget> allPages() {
    return {
      TabItem.users: const UsersPage(),
      TabItem.profil: const ProfilePage(),
    };
  }

  Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.users: GlobalKey<NavigatorState>(),
    TabItem.profil: GlobalKey<NavigatorState>(),
  };

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      //geri butonuna basıldığında stack de sayfa varsa onu kapatır yoksa uygulamadan çıkar
      //IOS de böyle bir sorun yok bu androide özgü bir sorun.
      onWillPop: () async =>
          !await navigatorKeys[currentTab]!.currentState!.maybePop(),
      child: BottomNavigation(
          navigatorKeys: navigatorKeys,
          currentTab: currentTab,
          onSelectTab: (tab) {
            if (tab == currentTab) {
              //pop ilk route
              navigatorKeys[tab]!
                  .currentState!
                  .popUntil((route) => route.isFirst);
            } else {
              setState(() {
                currentTab = tab;
              });
            }
          },
          createPage: allPages()),
    );
  }
}
