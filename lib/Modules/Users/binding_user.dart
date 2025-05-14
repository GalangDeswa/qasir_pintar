import 'package:get/get.dart';
import 'package:qasir_pintar/Modules/Users/controller_updateuser.dart';
import 'package:qasir_pintar/Modules/Users/controller_user.dart';

class UserBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(UserController());
  }
}
