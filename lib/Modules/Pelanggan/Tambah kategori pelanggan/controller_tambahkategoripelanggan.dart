import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image/image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:qasir_pintar/Config/config.dart';
import 'package:qasir_pintar/Modules/Pelanggan/List%20kategori%20pelanggan/controller_kategoripelanggan.dart';
import 'package:uuid/uuid.dart';

import '../../../Database/DB_helper.dart';
import '../../../Widget/widget.dart';
import '../../Region/model_district.dart';
import '../../Region/model_province.dart';
import '../../Region/model_regency.dart';
import '../../Users/model_user.dart';
import '../List Pelanggan/controller_pelanggan.dart';
import '../List Pelanggan/model_pelanggan.dart';
import '../List kategori pelanggan/model_kategoriPelanggan.dart';

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;

import '../Tambah Pelanggan/controller_tambahpelanggan.dart'; // For image manipulation

class TambahKategoriPelangganController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  var nama = TextEditingController().obs;
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

  var provinceList = <DataProvince>[].obs;
  String? provincevalue;
  var regencyList = <DataRegency>[].obs;
  String? regencyvalue;
  var districtList = <DataDistrict>[].obs;
  String? districtvalue;
  var provinceId;
  var provinceListLocal = <DataProvince>[].obs;

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

  // Method to open a list of FaIcons
  void pilihIcon(BuildContext context) {
    final List<String> icons = [
      'assets/icons/adduser.svg',
      'assets/icons/camera.svg',
      'assets/icons/cart.svg',
      'assets/icons/cashier.svg',
      'assets/icons/coffe1.svg',
      'assets/icons/coffe2.svg',
      'assets/icons/disk.svg',
      'assets/icons/dress.svg',
      'assets/icons/dumbell.svg',
      'assets/icons/guitar.svg',
      'assets/icons/history.svg',
      'assets/icons/laporan.svg',
      'assets/icons/money.svg',
      'assets/icons/moneybag.svg',
      'assets/icons/monitor.svg',
      'assets/icons/phone.svg',
      'assets/icons/produk.svg',
      'assets/icons/shoes.svg',
      'assets/icons/sportshirt.svg',
      'assets/icons/star.svg',
      'assets/icons/think.svg',
      'assets/icons/tshirt.svg',
      'assets/icons/wallet.svg',
      'assets/icons/watch.svg',
    ];

    Get.dialog(
      AlertDialog(
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
    // final String svgString = await rootBundle.loadString(assetPath);
    //
    // return base64Encode(utf8.encode(svgString));

    final String svgString = await rootBundle.loadString(assetPath);
    return base64Encode(utf8.encode(svgString));
  }

// Method to convert an icon to base64
  convertIconToBase64(IconData icon) async {
    // Create an image from the icon
    final img.Image qwe = img.Image(width: 100, height: 100);

    //img.drawIcon(qwe, icon, 0, 0, 0xFF000000); // Draw the icon on the image

    // Convert the image to bytes
    final Uint8List bytes = encodePng(qwe);

    // Convert the bytes to base64
    final String base64Image = base64Encode(bytes);
    image64 = base64Image;
    // Use the base64 image (e.g., save it or display it)
    print('icon to img------------>');
    print('Base64 Image: $base64Image');
    // You can now use `base64Image` as needed
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
          imageQuality: 85,
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
      pickedIconPath.value = '';
      print(image64);
      Get.back();
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  var tanggal = TextEditingController().obs;
  DateFormat dateFormat = DateFormat("dd-MM-yyyy");
  stringdate() {
    var ff = dateFormat.format(datedata.first!);
    tanggal.value.text = ff;
  }

  tambahKategoriPelangganLocal() async {
    print(
        '-------------------tambah kategori pelanggan local---------------------');

    Get.dialog(showloading(), barrierDismissible: false);
    var uuid = Uuid().v4();
    var db = await DBHelper().INSERT(
        'kategori_pelanggan',
        DataKategoriPelanggan(
                uuid: uuid,
                id_toko: id_toko,
                ikon: image64,
                kategori: nama.value.text,
                status: 1)
            .DB());

    if (db != null) {
      print(db);
      await Get.find<KategoriPelangganController>()
          .fetchKategoriPelangganLocal(id_toko);
      await Get.find<TambahPelangganController>()
          .fetchKategoriPelangganLocal(id_toko);

      // Get the first controller
      final firstController = Get.find<TambahPelangganController>();

      // Set the new UUID as the selected value
      firstController.kategorivalue = uuid;
      Get.back(closeOverlays: true);
      Get.showSnackbar(toast().bottom_snackbar_success('Sukses', 'Berhasil'));
    } else {
      Get.back();
      Get.showSnackbar(toast().bottom_snackbar_error('error', 'gagal'));
    }

    // if (add == 1) {
    //
    // } else {
    //   Get.back(closeOverlays: true);
    //   Get.showSnackbar(
    //       toast().bottom_snackbar_error('error', 'gagal tambah data local'));
    // }
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
}
