import 'package:get/get.dart';
import 'package:meta/meta.dart';
import 'package:qasir_pintar/Services/BoxStorage.dart';

import '../../Controllers/CentralController.dart';
import '../../Database/DB_helper.dart';
import '../../Widget/widget.dart';
import 'model_beban.dart';

class BasemenuBebanController extends GetxController {
  StorageService box = Get.find<StorageService>();
  CentralBebanController con = Get.find<CentralBebanController>();
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    con.fetchBeban();
    con.fetchKategoriBeban();
  }

  var id_toko;
  Map<String, dynamic> Datahapusbeban({aktif}) {
    var map = <String, dynamic>{};

    map['aktif'] = aktif;

    return map;
  }

  hapusbeban(uuid) async {
    print('-------------------edit  produk local---------------------');

    Get.dialog(const showloading(), barrierDismissible: false);

    var beban = await DBHelper()
        .UPDATE(id: uuid, table: 'beban', data: Datahapusbeban(aktif: 0));
    if (beban == 1) {
      await Get.find<CentralBebanController>().fetchBeban();
      Get.back();
      Get.back();
      Get.showSnackbar(
          toast().bottom_snackbar_success('sukses', 'berhasil dibatalkan'));
    } else {
      Get.back(closeOverlays: true);
      Get.showSnackbar(
          toast().bottom_snackbar_error('error', 'gagal edit data local'));
    }
  }

  hapusbebanv2(uuid) async {
    print('-------------------edit  produk local---------------------');

    Get.dialog(const showloading(), barrierDismissible: false);

    var beban = await DBHelper().softDelete(table: 'beban', uuid: uuid);
    print('respon softdeleter beban ---->');
    print(beban);
    if (beban == 1) {
      await Get.find<CentralBebanController>().fetchBeban();
      Get.back();
      Get.back();
      Get.showSnackbar(
          toast().bottom_snackbar_success('sukses', 'berhasil dibatalkan'));
    } else {
      Get.back();
      Get.showSnackbar(
          toast().bottom_snackbar_error('error', 'gagal edit data local'));
    }
  }
}
