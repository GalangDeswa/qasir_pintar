import 'package:get/get.dart';
import 'package:qasir_pintar/Modules%20-%20Distributor/Base%20Menu/controller_basemenu_distributor.dart';

class BindingBasemenuDistributorBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BaseMenuDistributorController());
  }
}
