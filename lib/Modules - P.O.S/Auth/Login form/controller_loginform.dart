import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:qasir_pintar/Database/DB_helper.dart';
import 'package:uuid/uuid.dart';

import '../../../Services/BoxStorage.dart';
import '../../../Services/Handler.dart';
import '../../../Widget/widget.dart';
import '../../Users/model_user.dart';

class LoginFormController extends GetxController {
  final StorageService box = Get.find<StorageService>();
  var email = TextEditingController().obs;
  var password = TextEditingController().obs;
  //
  // var email = ''.obs;
  // var password = ''.obs;
  final loginKey = GlobalKey<FormState>().obs;
  var showpass = true.obs;
  var token;
  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  stringdate(date) {
    if (date != null) {
      return DateTime.parse(date);
    } else {
      return null;
    }
  }

  // var x = '999999';
  // var y = 'qweqwe';
  var datauser = <DataUser>[].obs;

  loginLocal({required hp, required pass}) async {
    Get.dialog(showloading(), barrierDismissible: false);
    try {
      print('-------------------login user local---------------------');

      List<Map<String, Object?>> query = await DBHelper()
          .FETCH('SELECT * FROM users WHERE telp = "$hp" AND psw = "$pass"');
      // List<DataUser> user =
      //     query.isNotEmpty ? query.map((e) => DataUser.fromJson(e)).toList() : [];
      //query.isNotEmpty ? query.map((e) => DataUser.fromJson(e)).toList() : null;
      print('check user0----------------->');
      print(query);

      if (query.isNotEmpty) {
        datauser.value = query.map((e) => DataUser.fromJson(e)).toList();
        await box.write('user_id', datauser.first.id);
        await box.write('uuid', datauser.first.uuid);
        await box.write('user_name', datauser.first.name);
        await box.write('user_email', datauser.first.email);
        await box.write('user_phone', datauser.first.phone);

        await box.write('user_ref_code', datauser.first.referralCode);
        await box.write('user_business_name', datauser.first.businessName);
        await box.write('user_pin', datauser.first.pin);
        await box.write('user_logo', datauser.first.logo);
        await box.write('user_business_type_id', datauser.first.businessTypeId);
        await box.write('user_province_id', datauser.first.provinceId);
        await box.write('user_district_id', datauser.first.districtId);
        await box.write('user_regency_id', datauser.first.regencyId);

        await box.write('user_address', datauser.first.address);

        await box.write('user_package_id', datauser.first.packageId);

        await box.write('user_start_date', datauser.first.startDate);

        await box.write('user_end_date', datauser.first.endDate);
        await box.write('status', datauser.first.status);

        await box.write('user_logo_url', datauser.first.logoUrl);

        await box.write('user_register_date', datauser.first.registerDate);

        await box.write('user_status', datauser.first.statusUser);
        Get.back(closeOverlays: true);
        Get.offAndToNamed('/basemenu');
        Get.showSnackbar(
            toast().bottom_snackbar_success('Berhasil', 'berhasil login'));
      } else {
        Get.back();
        Get.showSnackbar(toast().bottom_snackbar_error('Error', 'Gagal login'));
      }
    } catch (x, stackTrace) {
      print('error catch $x');
      print(stackTrace);
      print(x.toString());
    }
  }

  Future<void> login() async {
    Get.dialog(showloading(), barrierDismissible: false);
    try {
      var checkconn = await check_conn.check();
      if (checkconn == true) {
        var response = await API.login(
            email: email.value.text, password: password.value.text);
        if (response['status'] == true) {
          print('respond--------------------?');
          print(response);
          print('token--------------------?');
          print(response['token']);
          token = response['token'];
          await GetStorage().write('token', token);
          await GetStorage().write('user_id', response['user']['id']);
          await GetStorage().write('user_name', response['user']['name']);
          await GetStorage().write('user_email', response['user']['email']);
          await GetStorage().write('user_phone', response['user']['phone']);

          await GetStorage()
              .write('user_ref_code', response['user']['referral_code']);
          await GetStorage()
              .write('user_business_name', response['user']['business_name']);
          await GetStorage().write('user_pin', response['user']['pin']);
          await GetStorage().write('user_logo', response['user']['logo']);
          await GetStorage().write(
              'user_business_type_id', response['user']['business_type_id']);
          await GetStorage()
              .write('user_province_id', response['user']['province_id']);
          await GetStorage()
              .write('user_district_id', response['user']['district_id']);
          await GetStorage()
              .write('user_regency_id', response['user']['regency_id']);

          await GetStorage().write('user_address', response['user']['address']);

          await GetStorage()
              .write('user_package_id', response['user']['package_id']);

          await GetStorage()
              .write('user_start_date', response['user']['start_date']);

          await GetStorage()
              .write('user_end_date', response['user']['end_date']);
          await GetStorage().write('status', response['user']['status']);

          await GetStorage()
              .write('user_logo_url', response['user']['logo_url']);

          await GetStorage()
              .write('user_register_date', response['user']['register_date']);

          await GetStorage()
              .write('user_status', response['user']['status_user']);

          var check = await fetchUserLocal(response['user']['id']);

          if (check == null) {
            print('Akun belum ada dilocal ------------->');
            var uuid = Uuid().v4();

            var db = await DBHelper().INSERT(
                'users',
                DataUser(
                        id: response['user']['id'],
                        uuid: uuid,
                        name: response['user']['name'],
                        phone: response['user']['phone'],
                        email: response['user']['email'],
                        referralCode: response['user']['referral_code'],
                        businessName: response['user']['business_name'],
                        pin: response['user']['pin'],
                        logo: response['user']['logo'],
                        businessTypeId: response['user']['business_type_id'],
                        provinceId: response['user']['province_id'],
                        districtId: response['user']['district_id'],
                        regencyId: response['user']['regency_id'],
                        address: response['user']['address'],
                        packageId: response['user']['address'],
                        startDate: stringdate(response['user']['start_date']),
                        endDate: stringdate(response['user']['end_date']),
                        status: response['user']['status'],
                        logoUrl: response['user']['logo_url'],
                        registerDate: response['user']['register_date'],
                        statusUser: response['user']['status_user'])
                    .DB());
            if (db == null) {
              Get.back(closeOverlays: true);
              print(db);
              Get.showSnackbar(
                  toast().bottom_snackbar_error('Error', 'SQLITE ERROR'));
              return;
            }
            await GetStorage().write('uuid', uuid);

            Get.back(closeOverlays: true);
            Get.offAndToNamed('/basemenu');
            Get.showSnackbar(
                toast().bottom_snackbar_success('Berhasil', 'berhasil login'));
          } else {
            print(
                'second sudah ada di local check----------------------------->');
            List<DataUser> check = await fetchUserLocal(response['user']['id']);
            print('akun local uuid ------->');
            print(check.first.uuid);
            await GetStorage().write('uuid', check.first.uuid);
            print('Akun sudah ada dilocal ------------->');
            Get.back(closeOverlays: true);
            Get.offAndToNamed('/basemenu');
            Get.showSnackbar(
                toast().bottom_snackbar_success('Berhasil', 'berhasil login'));
          }
        } else {
          Get.back();
          print(response);
          // String status = response['status'].toString();
          // String errorMessage =
          //     response['errors'] ?? 'An unknown error occurred.';
          toast().showErrorSnackbar(response);
        }
      }
    } catch (x, stackTrace) {
      print('error catch $x');
      print(stackTrace);
      print(x.toString());
    }
  }

  fetchUserLocal(id) async {
    print('-------------------fetch user local---------------------');

    List<Map<String, Object?>> query =
        await DBHelper().FETCH('SELECT * FROM users WHERE id = $id');
    // List<DataUser> user =
    //     query.isNotEmpty ? query.map((e) => DataUser.fromJson(e)).toList() : [];
    //query.isNotEmpty ? query.map((e) => DataUser.fromJson(e)).toList() : null;
    print('check user0----------------->');
    print(query);

    if (query.isNotEmpty) {
      return query.map((e) => DataUser.fromJson(e)).toList();
    } else {
      print('empty');
      return null;
    }
  }

  Future<void> getUser() async {
    Get.dialog(showloading(), barrierDismissible: false);
    try {
      var checkconn = await check_conn.check();
      if (checkconn == true) {
        var response = await API.getUser(id: 2, token: token);
        if (response != null) {
          print(response);
          var dataUser = User.fromJson(response);
          // await GetStorage().write('token', token);
          await GetStorage().write('username', dataUser.data?.name);
          print(GetStorage().read('username'));
          await GetStorage().write('userid', dataUser.data?.id);
          print(GetStorage().read('userid'));
          await GetStorage().write('useremail', dataUser.data?.email);
          print(GetStorage().read('useremail'));

          Get.back(closeOverlays: true);
          Get.showSnackbar(
              toast().bottom_snackbar_success('Berhasil', 'berhasil login'));
        } else {
          print(response);
          Get.showSnackbar(
              toast().bottom_snackbar_error('Error', response.toString()));
        }
      }
    } catch (x) {
      print('error catch $x');
      print(x.toString());
    }
  }
}
