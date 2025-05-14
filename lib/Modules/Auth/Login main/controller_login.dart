import 'package:get/get.dart';
import 'package:meta/meta.dart';

class LoginController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  var current = 0.obs;
  var currenttext = 0.obs;
  final List<String> imgList = [
    'assets/icons/splash.png',
    'assets/images/intro2.png',
    'assets/images/intro3.png',
  ].obs;
  final List<String> textList = [
    'Penjualan dimanapun kapanpun',
    'Fitur lengkap',
    'Transaksi offline dan online',
  ].obs;
}
