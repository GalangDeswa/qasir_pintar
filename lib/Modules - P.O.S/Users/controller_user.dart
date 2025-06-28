import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:meta/meta.dart';
import 'package:qasir_pintar/Modules - P.O.S/Region/model_province.dart';
import 'package:qasir_pintar/Services/API.dart';
import 'package:qasir_pintar/Services/Handler.dart';

import '../../Database/DB_helper.dart';
import '../../Widget/widget.dart';
import 'model_user.dart';

class UserController extends GetxController {
  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    print('user view init --------------------->');
    super.onInit();
    uuid.value = await GetStorage().read('uuid');
    await fetchUserLocal(uuid);

    //
    // await GetStorage().read('user_package_id');
    //
    // await GetStorage().read('user_start_date');
    //
    // await GetStorage().read('user_end_date');
    // await GetStorage().read('status');
    //
    // await GetStorage().read('user_logo_url');
    //
    // await GetStorage().read('user_register_date');
    //
    //
    //
    // await GetStorage().read('user_status');
    //
  }

  var id_user = GetStorage().read('user_id');
  var uuid = ''.obs;
  var token = GetStorage().read('token');
  var nama_user = GetStorage().read('user_name');
  var email_user = GetStorage().read('user_email');
  var telepon_user = GetStorage().read('user_phone');
  //var logo = GetStorage().read('user_logo').obs;

  var provinsi = GetStorage().read('user_province_id');
  var kabupaten = GetStorage().read('user_district_id');
  var kecamatan = GetStorage().read('user_regency_id');

  var alamat = GetStorage().read('user_address');

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
  String? jenisvalue;
  String? provincevalue;
  var jenislistlocal = ['Toko', 'CAFE', "JASA"].obs;
  var showpass = true.obs;
  var showkon = true.obs;

  final registerLokasiKey = GlobalKey<FormState>().obs;

  var provinceList = <DataProvince>[].obs;
  var userList = <DataUser>[].obs;

  fetchUserLocal(id) async {
    print('-------------------fetch user local---------------------');

    List<Map<String, Object?>> query = await DBHelper().FETCH('''
    SELECT 
        users.*, 
        provinces.name AS province_name, 
        regencies.name AS regency_name, 
        districts.name AS district_name, 
        jenis_usaha.nama as business_name
    FROM 
        users 
    LEFT JOIN 
        provinces ON users.pilih_provinsi = provinces.id 
    LEFT JOIN 
        regencies ON users.pilih_kabupaten = regencies.id 
    LEFT JOIN 
        districts ON users.pilih_kecamatan = districts.id
    LEFT JOIN 
        jenis_usaha ON users.id_jenis_usaha = jenis_usaha.uuid 
    WHERE 
        users.uuid = "$id"
  ''');
    if (query.isNotEmpty) {
      List<DataUser> data = query.map((e) => DataUser.fromJsondb(e)).toList();
      userList.value = data;
      print(userList.value);
      return data;
    } else {
      print('empty');
      return null;
    }
  }

  getProvice() async {
    print('-------------------fetch province---------------------');

    var response = await API.getProvince(token: token);
    if (response['status'] == true) {
      print('-------------------datajenis---------------');
      var dataprovince = ModelProvince.fromJson(response);

      provinceList.value = dataprovince.data;
      // totalpagejenis.value = dataJenis.meta.pagination.totalPages;
      // totaldatajenis.value = dataJenis.meta.pagination.total;
      // perpagejenis.value = dataJenis.meta.pagination.perPage;
      // currentpagejenis.value = jenis['meta']['pagination']['current_page'];
      // countjenis.value = dataJenis.meta.pagination.count;
      // if (totalpagejenis > 1) {
      //   nextdatajenis = jenis['meta']['pagination']['links']['next'];
      // }
      print('--------------------list province---------------');
      print(provinceList);

      return provinceList;
    } else {
      print(response);
      // String status = response['status'].toString();
      // String errorMessage =
      //     response['errors'] ?? 'An unknown error occurred.';
      toast().showErrorSnackbar(response);
    }

    //return [];
  }

  // Future<void> getUser() async {
  //   Get.dialog(showloading(), barrierDismissible: false);
  //   try {
  //     var checkconn = await check_conn.check();
  //     if (checkconn == true) {
  //       var response = await API.getUser(id: 2, token: token);
  //       if (response != null) {
  //         print(response);
  //         var dataUser = User.fromJson(response);
  //         // await GetStorage().read('token', token);
  //         await GetStorage().read('username', dataUser.data?.name);
  //         print(GetStorage().read('username'));
  //         await GetStorage().read('userid', dataUser.data?.id);
  //         print(GetStorage().read('userid'));
  //         await GetStorage().read('useremail', dataUser.data?.email);
  //         print(GetStorage().read('useremail'));
  //
  //         Get.back(closeOverlays: true);
  //         Get.showSnackbar(
  //             toast().bottom_snackbar_success('Berhasil', 'berhasil login'));
  //       } else {
  //         print(response);
  //         Get.showSnackbar(
  //             toast().bottom_snackbar_error('Error', response.toString()));
  //       }
  //     }
  //   } catch (x) {
  //     print('error catch $x');
  //     print(x.toString());
  //   }
  // }
}
