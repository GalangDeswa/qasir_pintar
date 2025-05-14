import 'package:get/get.dart';
import 'package:qasir_pintar/Modules/Supplier/controller_supplier.dart';

class SupplierBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SupplierController());
  }
}
