import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:meta/meta.dart';
import 'package:qasir_pintar/Modules - P.O.S/Users/model_user.dart';

import '../../../Database/DB_helper.dart';
import '../../../Services/Handler.dart';
import '../../../Widget/widget.dart';
import '../../Region/model_district.dart';
import '../../Region/model_province.dart';
import '../../Region/model_regency.dart';

class RegisterController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getProviceLocal();
  }

  var nama = TextEditingController().obs;
  var email = TextEditingController().obs;
  var password = TextEditingController().obs;
  var telepon = TextEditingController().obs;
  var kodeRef = TextEditingController().obs;
  var konpass = TextEditingController().obs;
  var alamat = TextEditingController().obs;
  final registerKey = GlobalKey<FormState>().obs;
  final registerLokasiKey = GlobalKey<FormState>().obs;
  var id;
  var showpass = true.obs;
  var showkon = true.obs;

  String? jenisvalue;
  var jenislistlocal = ['Toko', 'CAFE', "JASA"].obs;

  var provinceList = <DataProvince>[].obs;
  var provincevalue;
  var regencyList = <DataRegency>[].obs;
  var regencyvalue;
  var districtList = <DataDistrict>[].obs;
  var districtvalue;

  var provinceId;
  var regencyId;
  var districtId;

  var provinceListLocal = <DataProvince>[].obs;

  var usertemp = <DataUser>[].obs;

  addusertemp() {
    print('add user temp ---->');
    usertemp.value.add(DataUser(
      name: nama.value.text,
      email: email.value.text,
      phone: telepon.value.text,
      referralCode: kodeRef.value.text,
      password: password.value.text,
      address: alamat.value.text,
      provinceId: provincevalue,
      regencyId: regencyvalue,
      districtId: districtvalue,
    ));

    print(usertemp);
    Get.toNamed('/setuptoko', arguments: usertemp.value.first);
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

  Future<void> registerUser() async {
    Get.dialog(showloading(), barrierDismissible: false);
    try {
      var checkconn = await check_conn.check();
      if (checkconn == true) {
        var response = await API.registerUser(
            nama: nama.value.text,
            email: email.value.text,
            telepon: telepon.value.text,
            password: password.value.text,
            konPassword: konpass.value.text,
            koderef: kodeRef.value.text);
        if (response['status'] == true) {
          print('respond--------------------?');
          print(response);
          await GetStorage().write('user_id', response['user']['id']);
          await GetStorage().write('user_name', response['user']['name']);
          await GetStorage().write('user_email', response['user']['email']);
          await GetStorage().write('user_phone', response['user']['phone']);
          await GetStorage().write('user_email', response['user']['email']);
          await GetStorage()
              .write('user_ref_code', response['user']['referral_code']);
          await GetStorage().write('user_logo', response['user']['logo_url']);
          await GetStorage()
              .write('user_register_date', response['user']['register_date']);
          await GetStorage()
              .write('user_status', response['user']['status_user']);

          print(response['user']['name']);
          print(response['user']['id']);

          Get.back(closeOverlays: true);
          Get.offAndToNamed('/loginform');
          Get.showSnackbar(
              toast().bottom_snackbar_success('Berhasil', 'berhasil login'));
        } else {
          Get.back(closeOverlays: true);
          print(response);
          String status = response['status'].toString();
          String errorMessage =
              response['message'] ?? 'An unknown error occurred.';
          Get.showSnackbar(toast()
              .bottom_snackbar_error('Error', status + '  -  ' + errorMessage));
        }
      }
    } catch (x) {
      print('error catch $x');
      print(x.toString());
    }
  }
}
