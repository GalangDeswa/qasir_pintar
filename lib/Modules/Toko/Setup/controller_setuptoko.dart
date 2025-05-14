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
import 'package:qasir_pintar/Modules/Toko/Setup/model_kategori_toko.dart';
import 'package:uuid/uuid.dart';

import '../../../Database/DB_helper.dart';
import '../../../Widget/widget.dart';
import '../../Base menu/controller_basemenu.dart';
import '../../Users/model_user.dart';

class SetupTokoController extends GetxController {
  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    print('SETUP TOKO CON INIt--------------------------------->');
    await getKategoriTokoLocal();
  }

  getKategoriTokoLocal() async {
    print('-------------------fetch kategori toko local---------------------');
    // succ.value = false;
    List<Map<String, Object?>> query =
        await DBHelper().FETCH('SELECT * FROM jenis_usaha');
    List<DataKategoriToko> kategoriToko = query.isNotEmpty
        ? query.map((e) => DataKategoriToko.fromJsondb(e)).toList()
        : [];
    jenislistlocal.value = kategoriToko;
    print(jenislistlocal);
    // print('fect produk local --->' + produk.toList().toString());
    //succ.value = true;
    return jenislistlocal;
  }

  final registerlocalKey = GlobalKey<FormState>().obs;

  String stringGenerator(int len) {
    var random = Random.secure();
    var values = List<int>.generate(len, (i) => random.nextInt(255));

    var uniqueId = base64UrlEncode(values);
    print(uniqueId);
    return uniqueId;
  }

  String getTodayDateISO() {
    // Get the current date
    DateTime now = DateTime.now();

    // Format the date as "YYYY-MM-DD"
    String formattedDate =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    return formattedDate;
  }

  registerUserLocal() async {
    print('-------------------tambah user local---------------------');

    Get.dialog(showloading(), barrierDismissible: false);
    var uuid = Uuid().v4();
    var db = await DBHelper().INSERT(
        'users',
        DataUser(
                uuid: uuid,
                name: data.name,
                phone: data.phone,
                email: data.email,
                password: data.password,
                referralCode: data.referralCode,
                businessName: namausaha.value.text,
                logo: image64,
                businessTypeId: jenisvalue,
                provinceId: data.provinceId,
                districtId: data.districtId,
                regencyId: data.regencyId,
                address: data.address,
                referralCodeget: stringGenerator(10),
                registerDate: getTodayDateISO(),
                statusUser: 1)
            .DB());

    if (db != null) {
      await GetStorage().write('uuid', uuid);
      //await Get.find<BasemenuController>().fetchUserLocal(uuid);
      Get.back(closeOverlays: true);
      Get.offAndToNamed('/basemenu');
      Get.showSnackbar(
          toast().bottom_snackbar_success('Sukses', 'Berhasil registrasi'));
    } else {
      Get.back(closeOverlays: true);
      Get.showSnackbar(
          toast().bottom_snackbar_error('error', 'gagal registrasi'));
    }
  }

  void deleteImage() {
    // Reset the picked image file
    pickedImageFile = null;

    // Reset the image path
    pikedImagePath.value = '';

    // Reset the base64-encoded image string
    image64 = null;

    // logo.value = '-';

    // Optionally, you can also reset the logo if it's part of the same state
    // logo.value = ''; // Uncomment if you want to reset the logo as well

    print('Image deleted successfully');
  }

  DataUser data = Get.arguments;
  var namausaha = TextEditingController().obs;
  var emailController = TextEditingController().obs;
  var passwordController = TextEditingController().obs;

  var email = ''.obs;
  var password = ''.obs;
  var jenisvalue;
  var jenislistlocal = <DataKategoriToko>[].obs;

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

  var compresimagepath = ''.obs;
  var compresimagesize = ''.obs;
  var namaFile = ''.obs;
  File? pickedImageFile;
  var image64;

  var check = false.obs;
  var checkfoto = false.obs;
  var checkbarcode = false.obs;

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
}
