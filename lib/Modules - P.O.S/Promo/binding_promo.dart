import 'package:get/get.dart';
import 'package:qasir_pintar/Modules - P.O.S/Promo/controller_promo.dart';

class PromoBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PromoController());
  }
}
