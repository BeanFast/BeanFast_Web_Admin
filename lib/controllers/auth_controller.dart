import 'package:beanfast_admin/contains/contain.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '/services/auth_service.dart';
import '/utils/logger.dart';
import '/enums/auth_state_enum.dart';

class AuthController extends GetxController with CacheManager {
  Rx<AuthState> authState = AuthState.unauthenticated.obs;
  final isPasswordHidden = true.obs;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void changeAuthState(AuthState newState) {
    authState.value = newState;
  }

  void checkLoginStatus() {
    final String? token = getToken();
    logger.e('token - ${token != null}');
    if (token != null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      final expiryTimestamp = decodedToken["exp"];
      final currentTime = DateTime.now().millisecondsSinceEpoch;
      if (expiryTimestamp < currentTime) {
        changeAuthState(AuthState.authenticated);
        return;
      }
    }
    logOut();
  }

  Future login() async {
    // emailController.text = 'admin01.beanfast@gmail.com';
    // passwordController.text = '12345678';

    if (!formKey.currentState!.validate()) {
      Get.snackbar('Thất bại', 'Thông tin không hợp lệ');
      return;
    }
    try {
      var response = await AuthService()
          .login(emailController.text, passwordController.text);
      if (response.statusCode == 200) {
        changeAuthState(AuthState.authenticated);
        await saveToken(response.data['data']['accessToken']); //Token is cached
      }
    } on DioException catch (e) {
      if (e.response!.statusCode == 400) {
        Get.snackbar('Thất bại', 'Tài khoản hoặc mật khẩu không đúng');
      }
    }
  }

  void logOut() {
    currentUser.value = null;
    changeAuthState(AuthState.unauthenticated);
    removeToken();
  }
}

mixin CacheManager {
  Future<bool> saveToken(String? token) async {
    final box = GetStorage();
    await box.write(CacheManagerKey.ADMINTOKEN.toString(), token);
    return true;
  }

  String? getToken() {
    final box = GetStorage();
    return box.read(CacheManagerKey.ADMINTOKEN.toString());
  }

  Future<void> removeToken() async {
    final box = GetStorage();
    await box.remove(CacheManagerKey.ADMINTOKEN.toString());
  }
}

// ignore: constant_identifier_names
enum CacheManagerKey { ADMINTOKEN }
