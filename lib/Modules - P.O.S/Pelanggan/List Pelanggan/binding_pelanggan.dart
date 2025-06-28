import 'package:get/get.dart';


import 'controller_pelanggan.dart';

class PelangganBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PelangganController());
  }
}
