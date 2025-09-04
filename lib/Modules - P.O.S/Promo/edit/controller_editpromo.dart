import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qasir_pintar/Config/config.dart';
import 'package:uuid/uuid.dart';

import '../../../Controllers/CentralController.dart';
import '../../../Database/DB_helper.dart';
import '../../../Widget/widget.dart';
import '../../Pelanggan/List kategori pelanggan/model_kategoriPelanggan.dart';
import '../../Users/model_user.dart';
import '../controller_promo.dart';
import '../model_promo.dart';

class EditPromoController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    nama.value.text = data.namaPromo!;
    diskonnominal.value = data.promoNominal!;
    diskonpersen.value = data.promoPersen!;
    keterangan.value.text = data.keterangan!;
    date1 = data.tglMulai!;
    date2 = data.tglSelesai!;
    pickdate.value.text = date1 + ' - ' + date2;
    if (data.promoNominal == 0.0) {
      opsidiskon[1];
      selecteddiskon.value = '%';
    } else {
      opsidiskon[0];
      selecteddiskon.value = 'Rp.';
    }
    isAktif.value = data.aktif == 1 ? true : false;
    promovalue.value.text = data.promoNominal.toString() != '0.0'
        ? AppFormat().numFormat(data.promoNominal)
        : AppFormat().numFormat(data.promoPersen);
  }

  DataPromo data = Get.arguments;
  Future<void> selectContact() async {
    try {
      final contact = await FlutterContacts.openExternalPick();
      if (contact != null) {
        // Update your controllers
        nama.value.text = contact.displayName;

        if (contact.emails.isNotEmpty) {
          email.value.text = contact.emails.first.address;
        }

        if (contact.phones.isNotEmpty) {
          telepon.value.text = contact.phones.first.number;
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal memilih kontak: $e');
    }
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
  var id_toko = GetStorage().read('uuid');
  var telepon = TextEditingController().obs;
  var kodeRef = TextEditingController().obs;
  var konpass = TextEditingController().obs;
  var alamat = TextEditingController().obs;
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

  var kategoripelangganList = <DataKategoriPelanggan>[].obs;
  var kategorivalue;
  var isAktif = true.obs;
  var usertemp = <DataUser>[].obs;

  var tanggal = TextEditingController().obs;
  DateFormat dateFormat = DateFormat("dd-MM-yyyy");
  stringdate() {
    var ff = dateFormat.format(datedata.first!);
    tanggal.value.text = ff;
  }

  fetchKategoriPelangganLocal(id_toko) async {
    print(
        '-------------------fetch kategori pelanggan local---------------------');

    List<Map<String, Object?>> query = await DBHelper().FETCH(
        'SELECT * FROM kategori_pelanggan WHERE id_toko = "$id_toko" AND aktif = 1');
    if (query.isNotEmpty) {
      List<DataKategoriPelanggan> data =
          query.map((e) => DataKategoriPelanggan.fromJsondb(e)).toList();
      kategoripelangganList.value = data;

      return data;
    } else {
      print('empty');
      return null;
    }
  }

  tambahPromo() async {
    print('-------------------tambah pelanggan local---------------------');

    Get.dialog(showloading(), barrierDismissible: false);
    var uuid = Uuid().v4();
    var db = await DBHelper().INSERT(
        'promo',
        DataPromo(
          uuid: uuid,
          idToko: id_toko,
          aktif: 1,
          keterangan: keterangan.value.text,
          namaPromo: nama.value.text,
          promoNominal: diskonnominal.value,
          promoPersen: diskonpersen.value,
          tglMulai: date1,
          tglSelesai: date2,
        ).DB());

    if (db != null) {
      await Get.find<PromoController>().fetchPromo(id_toko: id_toko);
      Get.back(closeOverlays: true);
      Get.showSnackbar(toast().bottom_snackbar_success('Sukses', 'Berhasil'));
    } else {
      Get.back();
      Get.showSnackbar(toast().bottom_snackbar_error('error', 'gagal'));
    }
  }

  Map<String, dynamic> dataedit(
      {nama, diskonnominal, diskonpersen, keterangan, date1, date2, aktif}) {
    var map = <String, dynamic>{};

    map['nama_promo'] = nama;
    map['promo_persen'] = diskonpersen;
    map['promo_nominal'] = diskonnominal;
    map['tgl_mulai'] = date1;
    map['tgl_selesai'] = date2;
    map['keterangan'] = keterangan;
    map['aktif'] = aktif;

    return map;
  }

  editPromoLocal() async {
    print('-------------------edit promo local---------------------');

    Get.dialog(const showloading(), barrierDismissible: false);

    var query = await DBHelper().UPDATE(
        table: 'promo',
        data: dataedit(
          keterangan: keterangan.value.text,
          nama: nama.value.text,
          date1: date1,
          date2: date2,
          diskonnominal: diskonnominal.value,
          diskonpersen: diskonpersen.value,
          aktif: isAktif.value == true ? 1 : 0,
        ),
        id: data.uuid);

    print(query);
    if (query == 1) {
      await Get.find<CentralPromoController>().fetchPromo(id_toko: id_toko);
      Get.back(closeOverlays: true);
      Get.showSnackbar(
          toast().bottom_snackbar_success('sukses', 'Promo berhasil diedit'));
    } else {
      Get.back(closeOverlays: true);
      Get.showSnackbar(
          toast().bottom_snackbar_error('error', 'gagal edit data local'));
    }
  }
}
