import 'package:get/get.dart';
import 'package:qasir_pintar/Modules%20-%20P.O.S/Beban/Detail%20beban/controller_detail_beban.dart';

class DetailBebanBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DetailBebanController());
  }
}
