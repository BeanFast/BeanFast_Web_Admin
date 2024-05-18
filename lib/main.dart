import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'binding.dart';
import 'contains/theme.dart';
import 'controllers/home_controller.dart';
import 'views/pages/splash_page.dart';

Future<void> main() async {
  await GetStorage.init(); // init local storage
  Get.put(HomeController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BeanFast',
      theme: AppTheme.defaulTheme,
      initialRoute: "/",
      getPages: [
        GetPage(
          name: '/',
          page: () => const SplashView(),
          binding: AuthBindingController(),
          // transition: Transition.fade,
        ),
      ],
    );
  }
}
