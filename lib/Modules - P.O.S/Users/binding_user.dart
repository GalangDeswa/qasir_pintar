import 'package:get/get.dart';
import 'package:qasir_pintar/Modules - P.O.S/Users/controller_updateuser.dart';
import 'package:qasir_pintar/Modules - P.O.S/Users/controller_user.dart';

class UserBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(UserController());
  }
}
