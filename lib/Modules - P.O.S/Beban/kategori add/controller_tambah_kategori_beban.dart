import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qasir_pintar/Modules%20-%20P.O.S/Beban/add/controller_tambah_beban.dart';
import 'package:uuid/uuid.dart';

import '../../../Controllers/CentralController.dart';
import '../../../Database/DB_helper.dart';
import '../../../Services/BoxStorage.dart';
import '../../../Widget/widget.dart';
import '../model_beban.dart';

class TambahKategoriBebanController extends GetxController {
  StorageService box = Get.find<StorageService>();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    print('tambah kategori beban init------------>');
    id_toko = box.read('uuid', fallback: 'null');
  }

  checkContactPermission() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    if (androidInfo.version.sdkInt >= 33) {
      var status = await Permission.contacts.status;
      print(status);
      if (!status.isGranted) {
        await Permission.contacts.request();
      }
    } else {
      var status = await Permission.contacts.status;
      print(status);
      if (!status.isGranted) {
        await Permission.contacts.request();
      }
    }
    return true;
  }

  Future<void> showPermissionDeniedDialog() async {
    await Get.dialog(
      AlertDialog(
        title: Text('Izin Kontak Diperlukan'),
        content: Text(
          'Aplikasi memerlukan akses ke kontak Anda untuk memilih pelanggan. '
          'Silakan aktifkan izin kontak di pengaturan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              await openAppSettings();
            },
            child: Text('Buka Pengaturan'),
          ),
        ],
      ),
    );
  }

  List<DateTime?> dates = [];
  var pickdate = TextEditingController().obs;
  final dateformat = DateFormat('dd-MM-yyyy');
  var date1;
  var date2;
  var opsidiskon = ['Rp.', '%'].obs;
  var selecteddiskon = ''.obs;
  var diskonnominal = 0.0.obs;
  var diskonpersen = 0.0.obs;
  var nama = TextEditingController().obs;
  var keterangan = TextEditingController().obs;
  var promovalue = TextEditingController().obs;
  var email = TextEditingController().obs;
  var id_toko;
  var telepon = TextEditingController().obs;
  var kodeRef = TextEditingController().obs;
  var konpass = TextEditingController().obs;
  var alamat = TextEditingController().obs;
  var jumlahbeban = TextEditingController().obs;
  final registerKey = GlobalKey<FormState>().obs;
  final registerLokasiKey = GlobalKey<FormState>().obs;
  var id;
  var showpass = true.obs;
  var showkon = true.obs;
  List<DateTime?> datedata = [
    //DateTime.now(),
  ];
  String? jenisvalue;
  var jenislistlocal = ['Toko', 'CAFE', "JASA"].obs;

  var kategorilist = <DataKategoriBeban>[].obs;
  var kategorivalue;

  var image64;
  File? pickedImageFile;
  var pikedImagePath = ''.obs;
  final ImagePicker picker = ImagePicker();
  List<XFile> images = [];
  List<String> listimagepath = [];
  var selectedfilecount = 0.obs;

  var tanggal = TextEditingController().obs;
  DateFormat dateFormat = DateFormat("dd-MM-yyyy");
  stringdate() {
    var ff = dateFormat.format(datedata.first!);
    tanggal.value.text = ff;
  }

  tambahKategoriBeban() async {
    print('-------------------tambah beban local---------------------');

    Get.dialog(showloading(), barrierDismissible: false);
    var uuid = Uuid().v4();
    var db = await DBHelper().INSERT(
        'kategori_beban',
        DataKategoriBeban(
                uuid: uuid,
                idToko: id_toko,
                aktif: 1,
                namaKategoriBeban: nama.value.text)
            .DB());

    if (db != null) {
      await Get.find<CentralBebanController>().fetchKategoriBeban();
      var con = Get.find<TambahBebanController>();
      con.kategorivalue.value = uuid;
      Get.back(closeOverlays: true);
      Get.showSnackbar(toast().bottom_snackbar_success('Sukses', 'Berhasil'));
    } else {
      Get.back();
      Get.showSnackbar(toast().bottom_snackbar_error('error', 'gagal'));
    }
  }
}
