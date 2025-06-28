import 'package:get/get.dart';
import 'package:qasir_pintar/Modules - P.O.S/Promo/add/controller_tambahpromo.dart';

class TambahPromoBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(TambahPromoController());
  }
}
