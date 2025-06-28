import 'package:get/get.dart';
import 'package:qasir_pintar/Modules - P.O.S/Promo/edit/controller_editpromo.dart';

class EditPromoBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(EditPromoController());
  }
}
