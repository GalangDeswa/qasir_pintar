import 'package:get/get.dart';
import 'package:qasir_pintar/Modules - P.O.S/Home/controller_home.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeController());
  }
}
