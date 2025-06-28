import 'package:get/get.dart';
import 'package:qasir_pintar/Modules - P.O.S/Base%20menu/controller_basemenu.dart';

import 'controller_setuptoko.dart';

class SetupTokoBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SetupTokoController());
    // Get.lazyPut<BasemenuController>(() => BasemenuController());
  }
}
