import 'package:get/get.dart';
import 'package:qasir_pintar/Modules - P.O.S/OTP/controller_otp.dart';

class OTPBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(OTPController());
  }
}
