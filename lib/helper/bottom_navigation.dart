import 'package:flutter/cupertino.dart';
import 'package:pigeon_app/helper/tab_items.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation(
      {super.key,
      required this.currentTab,
      required this.onSelectTab,
      required this.createPage,
      required this.navigatorKeys});

  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;
  final Map<TabItem, Widget> createPage;
  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys;

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(items: [
          createNavItem(TabItem.users),
          createNavItem(TabItem.profil),
        ], onTap: (index) => onSelectTab(TabItem.values[index])),
        tabBuilder: (context, index) {
          final showItem = TabItem.values[index];
          return CupertinoTabView(
            navigatorKey: navigatorKeys[showItem],
            builder: (context) {
              return CupertinoTabView(builder: (context) {
                return createPage[showItem]!;
              });
            },
          );
        });
  }

  BottomNavigationBarItem createNavItem(TabItem tabItem) {
    final currentTab = TabItemData.allTabs[tabItem];
    return BottomNavigationBarItem(
      icon: Icon(currentTab!.icon),
      label: currentTab.title,
    );
  }
}
