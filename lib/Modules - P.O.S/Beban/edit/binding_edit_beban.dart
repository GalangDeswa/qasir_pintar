import 'package:get/get.dart';
import 'package:qasir_pintar/Modules%20-%20P.O.S/Beban/edit/controller_edit_beban.dart';

class EditBebanBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(EditBebanController());
  }
}
