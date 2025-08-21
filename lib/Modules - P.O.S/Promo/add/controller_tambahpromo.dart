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

import 'package:permission_handler/permission_handler.dart';
import 'package:qasir_pintar/Config/config.dart';
import 'package:qasir_pintar/Controllers/CentralController.dart';
import 'package:qasir_pintar/Modules - P.O.S/Promo/controller_promo.dart';
import 'package:qasir_pintar/Modules - P.O.S/Promo/model_promo.dart';
import 'package:uuid/uuid.dart';

import '../../../Database/DB_helper.dart';
import '../../../Widget/widget.dart';

import '../../Pelanggan/List kategori pelanggan/model_kategoriPelanggan.dart';

import '../../Users/model_user.dart';

class TambahPromoController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    opsidiskon[0];

    selecteddiskon.value = 'Rp.';
  }

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

  var usertemp = <DataUser>[].obs;

  pilihsourcefoto() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        contentPadding: const EdgeInsets.all(20),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
        ),
        content: Builder(
          builder: (context) {
            return Container(
              width: context.res_height / 2.6,
              height: context.res_height / 2.6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Pilih Sumber Foto",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: AppPading.customBottomPadding(),
                    child: button_solid_custom(
                        onPressed: () {
                          pickImageGallery();
                        },
                        child: Text(
                          'Galeri',
                          style: AppFont.regular_white_bold(),
                        ),
                        width: context.res_width),
                  ),
                  Padding(
                    padding: AppPading.customBottomPadding(),
                    child: button_solid_custom(
                        onPressed: () {
                          pickImageCamera();
                        },
                        child:
                            Text('Kamera', style: AppFont.regular_white_bold()),
                        width: context.res_width),
                  ),
                  Padding(
                    padding: AppPading.customBottomPadding(),
                    child: button_border_custom(
                        onPressed: () {
                          pilihIcon(context);
                        },
                        child: Text('Ikon', style: AppFont.regular_bold()),
                        width: context.res_width),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  var image64;
  File? pickedImageFile;
  var pikedImagePath = ''.obs;
  final ImagePicker picker = ImagePicker();
  List<XFile> images = [];
  List<String> listimagepath = [];
  var selectedfilecount = 0.obs;
  Future pickImageGallery() async {
    try {
      final image = await ImagePicker().pickImage(
          source: ImageSource.gallery,
          imageQuality: 100,
          maxHeight: 300,
          maxWidth: 300);
      if (image == null) return;
      pickedImageFile = File(image.path);
      final bytes = File(image!.path).readAsBytesSync();
      String base64Image = base64Encode(bytes);
      image64 = base64Image;
      pikedImagePath.value = pickedImageFile!.path;
      pickedIconPath.value = '';
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
          imageQuality: 100,
          maxHeight: 300,
          maxWidth: 300);
      if (image == null) return;
      pickedImageFile = File(image.path);
      final bytes = File(image!.path).readAsBytesSync();
      String base64Image = base64Encode(bytes);
      image64 = base64Image;
      //  final temppath = File(image!.path);
      pikedImagePath.value = pickedImageFile!.path;
      pickedIconPath.value = '';
      print(image64);
      Get.back();
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  pilihIcon(BuildContext context) {
    final List<String> icons = [
      'assets/icons/user1.svg',
      'assets/icons/user2.svg',
      'assets/icons/user3.svg',
      'assets/icons/user4.svg',
      'assets/icons/user5.svg',
      'assets/icons/user6.svg',
      'assets/icons/user7.svg',
      'assets/icons/user8.svg',
      'assets/icons/user9.svg',
    ];

    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        contentPadding: const EdgeInsets.all(10),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12.0),
          ),
        ),
        content: Container(
          width: context.res_height / 2,
          height: context.res_height / 2,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // 3 icons per row
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            itemCount: icons.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  // Handle icon selection
                  _onIconSelected(icons[index]);
                  Get.back(); // Close the dialog
                },
                child: Card(
                  color: Colors.white,
                  elevation: 5,
                  margin: EdgeInsets.all(1),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(
                      icons[index],
                      width: 30, // Adjust size as needed
                      height: 30,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _onIconSelected(String iconPath) async {
    // Handle the selected icon
    pikedImagePath.value = '';
    pickedIconPath.value = iconPath;
    final String base64Svg = await svgToBase64(iconPath);
    image64 = base64Svg;
    print('Base64 SVG: $base64Svg');
    Get.back();

    // You can store the icon path in a variable or database
  }

  var pickedIconPath = ''.obs;

  Future<String> svgToBase64(String assetPath) async {
    final String svgString = await rootBundle.loadString(assetPath);
    return base64Encode(utf8.encode(svgString));
  }

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
    print('-------------------tambah promo local---------------------');

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
          // promoNominal: diskonnominal.value,
          // promoPersen: diskonpersen.value,
          promoNominal: diskonnominal.value,
          promoPersen: diskonpersen.value,
          tglMulai: date1,
          tglSelesai: date2,
        ).DB());

    if (db != null) {
      await Get.find<CentralPromoController>().fetchPromo(id_toko: id_toko);
      Get.back(closeOverlays: true);
      Get.showSnackbar(toast().bottom_snackbar_success('Sukses', 'Berhasil'));
    } else {
      Get.back();
      Get.showSnackbar(toast().bottom_snackbar_error('error', 'gagal'));
    }
  }
}
