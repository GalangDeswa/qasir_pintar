import 'package:get/get.dart';

import 'controller_loginpin.dart';

class LoginPinBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LoginPinController());
  }
}
