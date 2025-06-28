import 'package:get/get.dart';
import 'package:qasir_pintar/Modules - P.O.S/Supplier/Tambah%20supplier/controller_tambahsupllier.dart';

class TambahSupplierBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(TambahSupplierController());
  }
}
