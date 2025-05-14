import 'package:get/get.dart';
import 'package:qasir_pintar/Modules/Promo/controller_detailpromo.dart';

class DetailPromoBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DetailPromoController());
  }
}
