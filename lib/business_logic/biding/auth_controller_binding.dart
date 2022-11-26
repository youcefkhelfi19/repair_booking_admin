import 'package:get/get.dart';

import '../controllers/auth_controller.dart';

class AuthControllerBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(AuthController());
  }

}