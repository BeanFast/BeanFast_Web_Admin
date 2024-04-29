import 'package:get/get.dart';

import '/services/api_service.dart';
import '/controllers/auth_controller.dart';
import '/controllers/home_controller.dart';

class AuthBindingController extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController(), permanent: true);
    Get.lazyPut<ApiService>(() => ApiService());
     Get.lazyPut<HomeController>(() => HomeController());
  }
}

class HomeBindingController extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
