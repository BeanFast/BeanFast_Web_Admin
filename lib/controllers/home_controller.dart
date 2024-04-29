import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '/views/pages/deliverer_page.dart';
import '/views/pages/kitchen_manager_page.dart';
import '/services/role_service.dart';
import '/contains/contain.dart';
import '/utils/menu_item.dart';
import '/utils/logger.dart';
import '/views/pages/customer_page.dart';

class HomeController extends GetxController {
  RxBool isNavigationRailSelected = true.obs;
  // index of menuItem
  Rx<Widget> selectedContent = Rx<Widget>(const CustomerView());

  // menu mặc định
  List<MenuItem> menuItems = [
    const MenuItem(title: 'Khách hàng', icon: Iconsax.user),
    const MenuItem(title: 'Người giao hàng', icon: Iconsax.truck),
    const MenuItem(title: 'Quản lý bếp', icon: Iconsax.user_cirlce_add),
    const MenuItem(title: 'Cài đặt', icon: Icons.settings_outlined),
  ];

  // index là vị trí của menuItems
  Widget setSelectedContent(int index) {
    switch (index) {
      case 0:
        return const CustomerView();
      case 1:
        return const DelivererView();
      case 2:
        return const KitchenManagerView();
      case 3:
        return colorGreen();
      default:
        return colorGreen();
    }
  }

  Future getAllRole() async {
    try {
      listRole = await RoleService().getAll();
    } on DioException catch (e) {
      Get.snackbar('Lỗi', e.response!.data['message']);
    }
  }

  void changePage(int index) {
    selectedMenuIndex.value = index;
    selectedContent.value = setSelectedContent(index);
  }

  void toggleNavigation() {
    isNavigationRailSelected.toggle();
  }
}

Widget colorGreen() {
  logger.i('ColorGreen');
  return Scaffold(
    body: Container(
      color: Colors.green,
    ),
  );
}
