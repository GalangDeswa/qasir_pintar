import 'package:get/get.dart';
import 'package:qasir_pintar/Modules/Promo/edit/controller_editpromo.dart';

class EditPromoBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(EditPromoController());
  }
}
