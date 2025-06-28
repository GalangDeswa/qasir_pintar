import 'package:get/get.dart';
import 'package:qasir_pintar/Modules - P.O.S/Promo/controller_detailpromo.dart';

class DetailPromoBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DetailPromoController());
  }
}
