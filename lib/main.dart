import 'package:beanfast_admin/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'views/screens/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.put(AuthController());
    Get.put(AuthController());
    return GetMaterialApp(
      title: 'Flutter Demo',
      getPages: [
        GetPage(
          name: '/',
          page: () {
            return Get.find<AuthController>().logged.value
                ? const Home()
                : Login();
          },
          binding: LoginBindingController(),
        ),
        // GetPage(name: '/', page: () => ImageSlider()),
      ],
      home: Scaffold(
        appBar: AppBar(
          title: const Text('My Widget'),
        ),
        body: 
        StreamBuilder(
          stream: authController.authStateChanges,
          builder: (context, snapshot) {
            // authController.setAuthState(AuthState.authenticated);
            // print(Get.find<AuthController>().authState.value); // authenticated
            print("object");
            // print(Get.find<AuthController>().authState.value); // authenticated
            print(snapshot.connectionState);
            print(snapshot.hasData);
            Future.delayed(const Duration(seconds: 10), () {
              print('delay: ${snapshot.connectionState}');
            });
            if (snapshot.connectionState == ConnectionState.active) {
              switch (snapshot.data) {
                case AuthState.authenticated:
                  print('AuthState.authenticated');
                  return const Home();
                case AuthState.unauthenticated:
                  print('AuthState.unauthenticated');
                  return const UnknownScreen();
                case AuthState.unknown:
                  print('AuthState.unknown');
                  return Login();
                default:
                  return const Text("Lỗi xác định trạng thái");
              }
            } else if (snapshot.hasData) {
              print('snapshot.hasData');
              switch (snapshot.data) {
                case AuthState.authenticated:
                  print('AuthState.authenticated');
                  return const Home();
                case AuthState.unauthenticated:
                  print('AuthState.unauthenticated');
                  return const UnknownScreen();
                case AuthState.unknown:
                  print('AuthState.unknown');
                  return Login();
                default:
                  return const Text("Lỗi xác định trạng thái");
              }
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Simulate an authentication state change
            authController.changeAuthState(AuthState.authenticated);
            
          },
          child: const Icon(Icons.login),
        ),
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SplashScreen'),
      ),
    );
  }
}

class UnknownScreen extends StatelessWidget {
  const UnknownScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trạng thái không xác định'),
      ),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
    );
  }
}
