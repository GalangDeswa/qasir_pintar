import 'package:get/get.dart';
import 'package:qasir_pintar/Modules/Home/controller_home.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeController());
  }
}
