import 'dart:convert';

import 'package:get/get.dart';
import 'package:meta/meta.dart';
import 'package:qasir_pintar/Modules - P.O.S/Pelanggan/List%20Pelanggan/model_pelanggan.dart';

class DetailPelangganController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  DataPelanggan data = Get.arguments;

  bool isBase64Svg(String base64) {
    try {
      // Decode the base64 string to UTF-8
      final String decoded = utf8.decode(base64Decode(base64));
      // Check if the decoded string contains '<svg'
      return decoded.contains('<svg');
    } catch (e) {
      // If decoding fails, it's not an SVG
      return false;
    }
  }
}
