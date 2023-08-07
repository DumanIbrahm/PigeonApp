import 'package:flutter/material.dart';

enum TabItem { users, profil }

class TabItemData {
  final String title;
  final IconData icon;

  const TabItemData({required this.title, required this.icon});

  static const Map<TabItem, TabItemData> allTabs = {
    TabItem.users: TabItemData(title: "Users", icon: Icons.people),
    TabItem.profil: TabItemData(title: "Profil", icon: Icons.person),
  };
}
