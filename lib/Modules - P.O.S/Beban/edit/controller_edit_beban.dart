import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../Controllers/CentralController.dart';
import '../../../Database/DB_helper.dart';
import '../../../Services/BoxStorage.dart';
import '../../../Widget/widget.dart';
import '../model_beban.dart';

class EditBebanController extends GetxController {
  StorageService box = Get.find<StorageService>();
  CentralBebanController con = Get.find<CentralBebanController>();
  CentralKaryawanController conKar = Get.find<CentralKaryawanController>();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    con.fetchKategoriBeban();
    nama.value.text = data.namaBeban!;
    kategorivalue.value = data.idKategoriBeban;
    jumlahbeban.value.text = data.jumlahBeban!.toStringAsFixed(0);
    tanggal.value.text = data.tanggalBeban!;
    keterangan.value.text = data.keterangan!;
    karyawanvalue.value = data.idKaryawan;
    isAktif.value = data.aktif == 1 ? true : false;
  }

  var tambahBaru = ''.obs;
  DataBeban data = Get.arguments;
  var isAktif = true.obs;

  Map<String, dynamic> DataEditBeban(
      {nama, kategori, jumlah, tanggal, keterangan, karyawan, aktif}) {
    var map = <String, dynamic>{};

    map['id_kategori_beban'] = kategori;
    map['id_karyawan'] = karyawan;
    map['nama_beban'] = nama;
    map['jumlah_beban'] = jumlah;
    map['tanggal_beban'] = tanggal;
    map['keterangan'] = keterangan;
    map['aktif'] = aktif;

    return map;
  }

  editBebanLocal() async {
    print('-------------------edit  produk local---------------------');

    Get.dialog(const showloading(), barrierDismissible: false);

    var beban = await DBHelper().UPDATE(
        id: data.uuid,
        table: 'beban',
        data: DataEditBeban(
            nama: nama.value.text,
            kategori: kategorivalue.value,
            jumlah: double.parse(jumlahbeban.value.text.replaceAll(',', '')),
            tanggal: tanggal.value.text,
            keterangan: keterangan.value.text,
            aktif: isAktif.value == true ? 1 : 0,
            karyawan: karyawanvalue.value));
    if (beban == 1) {
      await Get.find<CentralBebanController>().fetchBeban();
      Get.back();
      Get.back();
      Get.showSnackbar(
          toast().bottom_snackbar_success('sukses', 'berhasil diedit'));
    } else {
      Get.back(closeOverlays: true);
      Get.showSnackbar(
          toast().bottom_snackbar_error('error', 'gagal edit data local'));
    }
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
  var kategorivalue = RxnString();
  var karyawanvalue = RxnString();
  var bebanvalue = RxnString();

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

  tambahBeban() async {
    print('-------------------tambah beban local---------------------');

    Get.dialog(showloading(), barrierDismissible: false);
    var uuid = Uuid().v4();
    var db = await DBHelper().INSERT(
        'beban',
        DataBeban(
          uuid: uuid,
          idToko: id_toko,
          idKaryawan: karyawanvalue.value,
          aktif: 1,
          keterangan: keterangan.value.text,
          namaBeban: nama.value.text,
          idKategoriBeban: kategorivalue.value,
          jumlahBeban: double.parse(jumlahbeban.value.text.replaceAll(',', '')),
          tanggalBeban: tanggal.value.text,
        ).DB());

    if (db != null) {
      await Get.find<CentralBebanController>().fetchBeban();
      Get.back(closeOverlays: true);
      Get.showSnackbar(toast().bottom_snackbar_success('Sukses', 'Berhasil'));
    } else {
      Get.back();
      Get.showSnackbar(toast().bottom_snackbar_error('error', 'gagal'));
    }
  }
}
