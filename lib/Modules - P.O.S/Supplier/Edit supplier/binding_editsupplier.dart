import 'package:get/get.dart';
import 'package:qasir_pintar/Modules - P.O.S/Supplier/Edit%20supplier/controller_editsupplier.dart';

class EditSupplierBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(EditSupplierController());
  }
}
