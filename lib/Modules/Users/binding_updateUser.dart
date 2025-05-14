import 'package:get/get.dart';

import 'controller_updateuser.dart';

class UpdateUserBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(UpdateUserController());
  }
}
