import 'package:get/get.dart';
import 'package:qasir_pintar/Modules%20-%20Distributor/Home%20-%20distributor/controller_home_distributor.dart';

class HomeDistributorBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeDistributorController());
  }
}
