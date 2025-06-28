import 'package:get/get.dart';

import 'controller_loginform.dart';

class LoginFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LoginFormController());
  }
}
