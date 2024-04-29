import 'package:beanfast_admin/views/pages/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../contains/contain.dart';
import '/controllers/home_controller.dart';
// import '/views/pages/widget/drawer_wdget.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin page'),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            controller.toggleNavigation();
          },
        ),
      ),
      body: LoadingView(
        future: controller.getAllRole,
        child: Obx(() {
          return controller.isNavigationRailSelected.value
              ? navigaView()
              : drawerView();
        }),
      ),
    );
  }

  Widget navigaView() {
    return Obx(
      () => Row(
        children: [
          NavigationRail(
            minWidth: 64,
            // selectedIndex: widget.currentIndex,
            selectedIndex: selectedMenuIndex.value,
            destinations: [
              ...controller.menuItems.map(
                (e) => NavigationRailDestination(
                  icon: Icon(e.icon),
                  label: Text(e.title),
                ),
              ),
            ],
            onDestinationSelected: (destination) {
              controller.changePage(destination);
            },
          ),
          VerticalDivider(
            width: 1,
            thickness: 1,
            color: Colors.grey[300],
          ),
          Expanded(
            child: controller.selectedContent.value,
          ),
        ],
      ),
    );
  }

  Widget drawerView() {
    return Obx(
      () => Row(
        children: [
          Drawer(
            width: 200,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const DrawerHeader(
                    child: Center(
                      child: Text('Menu'),
                    ),
                  ),
                  for (int i = 0; i < controller.menuItems.length; i++)
                    ListTile(
                      leading: Icon(controller.menuItems[i].icon),
                      title: Text(controller.menuItems[i].title),
                      selected: selectedMenuIndex.value == i,
                      onTap: () {
                        selectedMenuIndex.value = i;
                        controller.changePage(i);
                        // controller.selectedContent.value =
                        //     controller.setSelectedContent(i);
                      },
                    ),
                ],
              ),
            ),
          ),
          Expanded(
            child: controller.selectedContent.value,
          ),
        ],
      ),
    );
  }
}
