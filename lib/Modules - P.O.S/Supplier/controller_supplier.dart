import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:meta/meta.dart';
import 'package:qasir_pintar/Modules - P.O.S/Supplier/model_supplier.dart';

import '../../Database/DB_helper.dart';
import '../../Widget/widget.dart';
import '../Pelanggan/List Pelanggan/controller_pelanggan.dart';
import '../Pelanggan/List Pelanggan/model_pelanggan.dart';

class SupplierController extends GetxController {
  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    await fetchSupplierLocal(id_toko: id_toko);
  }

  deleteSupplier({uuid}) async {
    print('delete supplier local---------------------------------------->');
    Get.dialog(const showloading(), barrierDismissible: false);
    var delete = await DBHelper().DELETE(table: 'Supplier', id: uuid);
    if (delete == 1) {
      final index = supplierList.indexWhere((k) => k.uuid == uuid);
      if (index != -1) {
        supplierList.removeAt(index);
      }
      await Get.find<SupplierController>().fetchSupplierLocal(id_toko: id_toko);

      Get.back();
      Get.back();
      Get.showSnackbar(toast()
          .bottom_snackbar_success('Sukses', 'Supplier berhasil dihapus'));
      print('deleted ' + uuid.toString());
    } else {
      Get.back();
      Get.showSnackbar(
          toast().bottom_snackbar_error('Error', 'gagal menghapus'));
    }
  }

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

  var id_toko = GetStorage().read('uuid');
  var pelangganList = <DataPelanggan>[].obs;
  var supplierList = <DataSupplier>[].obs;
  var search = TextEditingController().obs;

  serachSupplierLocal() async {
    List<Map<String, Object?>> query = await DBHelper().FETCH(
        'SELECT * FROM Supplier WHERE id_toko = "$id_toko" AND Nama_Supplier LIKE "%${search.value.text}%" ');
    List<DataSupplier> jenis = query.isNotEmpty
        ? query.map((e) => DataSupplier.fromJsondb(e)).toList()
        : [];
    supplierList.value = jenis;

    return jenis;
  }

  fetchSupplierLocal({id_toko}) async {
    print('-------------------fetch supplier local---------------------');

    List<Map<String, Object?>> query = await DBHelper()
        .FETCH('SELECT * FROM Supplier WHERE id_toko = "$id_toko"');
    if (query.isNotEmpty) {
      List<DataSupplier> data =
          query.map((e) => DataSupplier.fromJsondb(e)).toList();
      supplierList.value = data;
      //logo.value = userList.value.first.logo!;
      return data;
    } else {
      print('empty');
      return null;
    }
  }
}
