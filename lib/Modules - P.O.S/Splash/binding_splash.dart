import 'package:get/get.dart';
import 'package:qasir_pintar/Modules - P.O.S/Splash/controller_splash.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashController());
  }
}
