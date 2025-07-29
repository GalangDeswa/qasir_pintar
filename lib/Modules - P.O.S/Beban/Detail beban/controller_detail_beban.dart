import 'package:get/get.dart';
import 'package:meta/meta.dart';
import 'package:qasir_pintar/Modules%20-%20P.O.S/Beban/model_beban.dart';
import 'package:qasir_pintar/Services/BoxStorage.dart';

class DetailBebanController extends GetxController {
  StorageService box = Get.find<StorageService>();
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  DataBeban data = Get.arguments;
}
