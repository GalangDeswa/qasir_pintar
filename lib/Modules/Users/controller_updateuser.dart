import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:qasir_pintar/Config/config.dart';
import 'package:qasir_pintar/Modules/Base%20menu/controller_basemenu.dart';
import 'package:qasir_pintar/Modules/Region/model_district.dart';
import 'package:qasir_pintar/Modules/Region/model_regency.dart';
import 'package:qasir_pintar/Modules/Users/controller_user.dart';

import '../../Database/DB_helper.dart';
import '../../Services/Handler.dart';
import '../../Widget/widget.dart';
import '../Region/model_province.dart';
import 'model_user.dart';

class UpdateUserController extends GetxController {
  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    //getProvice();
    await getProviceLocal();
    getRegencyLocal(provinceId: data.provinceId);
    getDistrictLocal(provinceId: data.provinceId, regencyId: data.regencyId);
    // getRegency();
    // getDistrict();
    nama.value.text = data.businessName!;
    email.value.text = data.email!;
    telepon.value.text = data.phone!;
    data.address == null ? '' : alamat.value.text = data.address;
    logo.value = data.logo ?? '-';
    print('provinsi --------------->');
    provincevalue = int.parse(data.provinceId);
    regencyvalue = int.parse(data.regencyId);
    districtvalue = int.parse(data.districtId);
    provinceId = int.parse(data.provinceId);
    regencyId = int.parse(data.districtId);
    districtId = int.parse(data.districtId);

    // regencyvalue = data.regencyId;
    // districtvalue = data.districtId;

    // print(nama_user);
    // print(email_user);
    // print(telepon_user);
    // print(alamat_user);
    // print('uuid----->');
    // print(uuid);
  }

  final dropdown = GlobalKey<FormState>().obs;
  var logo = ''.obs;
  DataUser data = Get.arguments;

  get() {
    var x = provinceList.where((x) => x.id.toString() == data.provinceId).first;
    print(x);
  }

  var compresimagepath = ''.obs;
  var compresimagesize = ''.obs;
  var namaFile = ''.obs;
  File? pickedImageFile;
  var image64;

  var pikedImagePath = ''.obs;
  final ImagePicker picker = ImagePicker();
  List<XFile> images = [];
  List<String> listimagepath = [];
  var selectedfilecount = 0.obs;

  Future pickImageGallery() async {
    try {
      final image = await ImagePicker().pickImage(
          source: ImageSource.gallery,
          imageQuality: 85,
          maxHeight: 300,
          maxWidth: 300);
      if (image == null) return;
      pickedImageFile = File(image.path);
      final bytes = File(image!.path).readAsBytesSync();
      String base64Image = base64Encode(bytes);
      image64 = base64Image;
      pikedImagePath.value = pickedImageFile!.path;
      print(pikedImagePath);
      Get.back();
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future pickImageCamera() async {
    try {
      final image = await ImagePicker().pickImage(
          source: ImageSource.camera,
          imageQuality: 85,
          maxHeight: 300,
          maxWidth: 300);
      if (image == null) return;
      pickedImageFile = File(image.path);
      final bytes = File(image!.path).readAsBytesSync();
      String base64Image = base64Encode(bytes);
      image64 = base64Image;
      //  final temppath = File(image!.path);
      pikedImagePath.value = pickedImageFile!.path;
      print(image64);
      Get.back();
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  pilihsourcefoto() {
    Get.dialog(AlertDialog(
      contentPadding: const EdgeInsets.all(10),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12.0),
        ),
      ),
      content: Builder(
        builder: (context) {
          return Container(
              width: context.res_height / 2.6,
              height: context.res_height / 2.6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "pilih sumber foto",
                  ),
                  TextButton(
                    onPressed: () {
                      pickImageGallery();
                    },
                    child: Text(
                      'Galery',
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      pickImageCamera();
                    },
                    child: Text(
                      'Kamera',
                    ),
                  )
                ],
              ));
        },
      ),
    ));
  }

  var id_user = GetStorage().read('user_id');
  var token = GetStorage().read('token');
  var nama_user = GetStorage().read('user_name');
  var email_user = GetStorage().read('user_email');
  var telepon_user = GetStorage().read('user_phone');
  var uuid = GetStorage().read('uuid');

  var provinsi = GetStorage().read('user_province_id');
  var kabupaten = GetStorage().read('user_district_id');
  var kecamatan = GetStorage().read('user_regency_id');

  var alamat_user = GetStorage().read('user_address');

  // var id_user = 0.obs;
  // var token = ''.obs;
  // var nama_user = ''.obs;
  // var email_user = ''.obs;
  // var telepon_user = ''.obs;
  // var alamat = ''.obs;
  // var provinsi = ''.obs;
  // var kabupaten = ''.obs;
  // var kecamatan = ''.obs;

  var nama = TextEditingController().obs;
  var email = TextEditingController().obs;
  var password = TextEditingController().obs;
  var telepon = TextEditingController().obs;
  var kodeRef = TextEditingController().obs;
  var konpass = TextEditingController().obs;
  var alamat = TextEditingController().obs;
  String? jenisvalue;

  var jenislistlocal = ['Toko', 'CAFE', "JASA"].obs;
  var showpass = true.obs;
  var showkon = true.obs;

  final registerLokasiKey = GlobalKey<FormState>().obs;

  var provinceList = <DataProvince>[].obs;
  var provincevalue;
  //late var provincevalue = data.provinceId.toString().obs;
  var regencyList = <DataRegency>[].obs;
  var regencyvalue;
  String? r2;
  var districtList = <DataDistrict>[].obs;
  var districtvalue;
  String? d2;
  var provinceId;
  var regencyId;
  var districtId;
  var provinceListLocal = <DataProvince>[].obs;

  getProvice() async {
    print('-------------------fetch province---------------------');
    var response = await API.getProvince(token: token);
    if (response['status'] == true) {
      var dataprovince = ModelProvince.fromJson(response);
      provinceList.value = dataprovince.data;
      print('--------------------list province---------------');
      print(provinceList);
      return provinceList;
    } else {
      print(response);
      toast().showErrorSnackbar(response);
    }

    //return [];
  }

  getProviceLocal() async {
    print('-------------------fetch PROVINCE local---------------------');
    // succ.value = false;
    List<Map<String, Object?>> query =
        await DBHelper().FETCH('SELECT * FROM provinces');
    List<DataProvince> province = query.isNotEmpty
        ? query.map((e) => DataProvince.fromJson(e)).toList()
        : [];
    provinceList.value = province;
    print(province);
    // print('fect produk local --->' + produk.toList().toString());
    //succ.value = true;
    return province;
  }

  getRegencyLocal({provinceId}) async {
    print('-------------------fetch Regency local---------------------');
    // succ.value = false;
    List<Map<String, Object?>> query = await DBHelper()
        .FETCH('SELECT * FROM regencies WHERE province_id = $provinceId');
    List<DataRegency> regencies = query.isNotEmpty
        ? query.map((e) => DataRegency.fromJson(e)).toList()
        : [];
    regencyList.value = regencies;
    // print('fect produk local --->' + produk.toList().toString());
    //succ.value = true;
    return regencies;
  }

  getDistrictLocal({provinceId, regencyId}) async {
    print('-------------------fetch Regency local---------------------');
    // succ.value = false;
    // Prepare the SQL query with both conditions

    print(' province : $provinceId     regency : $regencyId');
    List<Map<String, Object?>> query = await DBHelper().FETCHV2(
        'SELECT * FROM districts WHERE province_id = ? AND regency_id = ?', [
      provinceId,
      regencyId
    ] // Use parameterized queries to prevent SQL injection
        );

    List<DataDistrict> district = query.isNotEmpty
        ? query.map((e) => DataDistrict.fromJson(e)).toList()
        : [];
    districtList.value = district;
    // print('fect produk local --->' + produk.toList().toString());
    //succ.value = true;
    return district;
  }

  getRegency({required provinceId}) async {
    print('-------------------fetch Regency---------------------');
    var response = await API.getRegency(token: token, province: provinceId);
    if (response['status'] == true) {
      var dataregency = ModelRegency.fromJson(response);
      regencyList.value = dataregency.data;
      print('--------------------list Regency---------------');
      print(regencyList);
      return regencyList;
    } else {
      print(response);
      toast().showErrorSnackbar(response);
    }
  }

  getDistrict({provinceId, regencyId}) async {
    print('-------------------fetch district---------------------');
    var response = await API.getDistrict(
        token: token, province: provinceId, regency: regencyId);
    if (response['status'] == true) {
      var data = ModelDistrict.fromJson(response);
      districtList.value = data.data;
      print('--------------------list district---------------');
      print(districtList);
      return districtList;
    } else {
      print(response);
      toast().showErrorSnackbar(response);
    }
  }

  Map<String, dynamic> dataedit(
      {nama_usaha,
      email,
      telp,
      alamat,
      pilih_provinsi,
      pilih_kabupaten,
      pilih_kecamatan,
      logo}) {
    var map = <String, dynamic>{};

    map['nama_usaha'] = nama_usaha;
    map['email'] = email;
    map['telp'] = telp;
    map['alamat'] = alamat;
    map['pilih_provinsi'] = pilih_provinsi;
    map['pilih_kabupaten'] = pilih_kabupaten;
    map['pilih_kecamatan'] = pilih_kecamatan;
    map['logo'] = logo;

    return map;
  }

  void deleteImage() {
    // Reset the picked image file
    pickedImageFile = null;

    // Reset the image path
    pikedImagePath.value = '';

    //  pickedIconPath.value = '';
    // Reset the base64-encoded image string
    image64 = null;

    logo.value = '-';

    // Optionally, you can also reset the logo if it's part of the same state
    // logo.value = ''; // Uncomment if you want to reset the logo as well

    print('Image deleted successfully');
  }

  editUserLocal() async {
    print('-------------------edit user local---------------------');

    Get.dialog(const showloading(), barrierDismissible: false);

    var query = await DBHelper().UPDATE(
        table: 'users',
        data: dataedit(
          nama_usaha: nama.value.text,
          email: email.value.text,
          alamat: alamat.value.text,
          telp: telepon.value.text,
          pilih_provinsi: provincevalue,
          pilih_kabupaten: regencyvalue,
          pilih_kecamatan: districtvalue,
          logo: pikedImagePath.value != '' ? image64 : logo.value,
        ),
        id: uuid);

    print(query);
    if (query == 1) {
      //print('edit user local berhasil------------------------------------->');
      await Get.find<UserController>().fetchUserLocal(uuid);
      await Get.find<BasemenuController>().fetchUserLocal(uuid);
      Get.back(closeOverlays: true);
      Get.showSnackbar(
          toast().bottom_snackbar_success('sukses', 'user berhasil diedit'));
    } else {
      Get.back(closeOverlays: true);
      Get.showSnackbar(
          toast().bottom_snackbar_error('error', 'gagal edit data local'));
    }
  }
}
