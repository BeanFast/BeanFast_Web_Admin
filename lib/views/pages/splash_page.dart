import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/controllers/auth_controller.dart';
import '/enums/auth_state_enum.dart';
import 'home_page.dart';
import 'login_page.dart';
import '/utils/logger.dart';

class SplashView extends GetView<AuthController> {
  const SplashView({super.key});

  Future<void> initializeSettings() async {
    logger.w('initializeSettings');
    controller.checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initializeSettings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return waitingView();
        } else {
          if (snapshot.hasError) {
            // return ErrorView(errorMessage: snapshot.error.toString());
            logger.e('snapshot.hasError: ${snapshot.error.toString()}');
            return const LoginView();
          } else {
            return Obx(() {
              switch (controller.authState.value) {
                case AuthState.authenticated:
                  return const HomeView();
                case AuthState.unauthenticated:
                  return const LoginView();
                default:
                  logger.e(
                      'Lỗi xác thực đăng nhập: ${snapshot.error.toString()}');
                  return const LoginView();
                // return const ErrorView(
                //     errorMessage: 'Lỗi xác thực đăng nhập'); //
              }
            });
          }
        }
      },
    );
  }

  Scaffold waitingView() {
    return const Scaffold(
      body: Center(
        // child: Column(
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     Padding(
        //       padding: EdgeInsets.all(16.0),
        child: CircularProgressIndicator(),
      ),
      // Text('Loading...'),
      //   ],
      // ),
      // ),
    );
  }
}
