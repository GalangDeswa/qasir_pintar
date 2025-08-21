import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qasir_pintar/Config/config.dart';
import 'package:qasir_pintar/Controllers/CentralController.dart';
import 'package:smooth_sheets/smooth_sheets.dart';
import 'package:uuid/uuid.dart';

import '../../../../Database/DB_helper.dart';
import '../../../../Widget/popscreen.dart';
import '../../../../Widget/widget.dart';
import '../../Data produk/edit/controller_editisiproduk.dart';
import '../../Data produk/model_produk.dart';
import '../../Kategori/model_subkategoriproduk.dart';
import '../../Produk/model_kategoriproduk.dart';
import '../../controller_basemenuproduk.dart';

class TambahPaketProdukController extends GetxController {
  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    await fetchProdukLocal(id_toko: id_toko);
    await fetchpajak(id_toko: id_toko);
  }

//var uuid_produk = Uuid().v4();
  var jenisproduklist = ['Produk jadi', 'Bahan baku'].obs;
  var jenisvalue;
  var hitungStok = true.obs;
  var pajakdisplay = false.obs;
  var ukurandisplay = false.obs;
  var dimensi = false.obs;
  var tampilkanDiProduk = true.obs;
  var hitung_stock = false.obs;
  var registerKey = GlobalKey<FormState>().obs;
  var registerKey2 = GlobalKey<FormState>().obs;
  var pajakkey = GlobalKey<FormState>().obs;
  var ukurankey = GlobalKey<FormState>().obs;

  var uuid = TextEditingController().obs;
  var idToko = TextEditingController().obs;
  var idKelompokProduk = TextEditingController().obs;
  var idSubKelompokProduk = TextEditingController().obs;
  var kodeProduk = TextEditingController().obs;
  var namaProduk = TextEditingController().obs;

  var namaPaket = TextEditingController().obs;
  var hargaModal = TextEditingController().obs;
  var hargaJualPaket = TextEditingController().obs;

  var serialKey = TextEditingController().obs;
  var imei = TextEditingController().obs;
  var hargaBeli = TextEditingController().obs;
  var hpp = TextEditingController().obs;
  var hargaJualGrosir = TextEditingController().obs;
  var hargaJualEceran = TextEditingController().obs;
  var hargaJualPelanggan = TextEditingController().obs;
  var satuanUtama = TextEditingController().obs;
  var isiDalamSatuan = TextEditingController().obs;
  var pajak = TextEditingController().obs;
  var infostock = TextEditingController().obs;
  var warna = TextEditingController().obs;
  var ukuran = TextEditingController().obs;
  var berat = TextEditingController().obs;
  var volumePanjang = TextEditingController().obs;
  var volumeLebar = TextEditingController().obs;
  var volumeTinggi = TextEditingController().obs;
  var id_toko = GetStorage().read('uuid');

  var hargaJual = TextEditingController().obs;
  var jenistransaksi = TextEditingController().obs;
  var namaSatuan = TextEditingController().obs;
  var isiPerSatuan = TextEditingController().obs;
  var hargaPerSatuan = TextEditingController().obs;
  var namaPajak = TextEditingController().obs;
  var nominalPajak = TextEditingController().obs;
  var ukuranProduk = TextEditingController().obs;

  List<DateTime?> datedata = [
    //DateTime.now(),
  ];

//--------------------------------------------------------------
  var produktemp = <DataProdukTemp>[].obs;
  var paketproduk = <DataPaketProduk>[].obs;
  var kategorivalue;
  var kategorilist = <DataKategoriProduk>[].obs;
  var subKategorivalue;
  var subKategorilist = <DataSubKategoriProduk>[].obs;

  var hargaJualUtamaValue;
  var hargaJualUtamaList = <DataHargaJualProduk>[].obs;

  var satuanUtamaValue;
  var satuanUtamaList = <DataSatuanProduk>[].obs;

  var isiDalamSatuanValue;
  var isiDalamSatuanList = <DataSatuanProduk>[].obs;

  var pajakValue;
  var pajakList = <DataPajakProduk>[].obs;

  var ukuranValue;
  var ukuranList = <DataUkuranProduk>[].obs;

  var selecteddiskon = ''.obs;
  var diskonnominal = 0.0.obs;
  var diskonvalue = 0.0.obs;
  var diskonpersen = 0.0.obs;
  var diskon = TextEditingController().obs;
  var opsidiskon = ['Rp.', '%'].obs;
  var showdiskon = false.obs;

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

//------------------multi

  Future pickImagesGallery() async {
    try {
      final List<XFile>? images = await ImagePicker().pickMultiImage(
        imageQuality: 100,
        maxHeight: 300,
        maxWidth: 300,
      );
      if (images == null) return;
      //
      // pickedImageFiles.clear(); // Clear previous images
      // image64List.clear(); // Clear previous base64 strings
      // pikedImagePaths.clear(); // Clear previous paths

      for (var image in images) {
        pickedImageFiles.add(File(image.path));
        final bytes = await File(image.path).readAsBytes();
        String base64Image = base64Encode(bytes);
        image64List.add(base64Image);
        pikedImagePaths.add(image.path);
      }

      print(pikedImagePaths.length);
      print(image64List.length);
      Get.back();
    } on PlatformException catch (e) {
      print('Failed to pick images: $e');
    }
  }

  Future<void> requestCameraPermission() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      await Permission.camera.request();
    }
  }

  Future pickImagesCamera() async {
    try {
      final XFile? image = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 100,
        maxHeight: 300,
        maxWidth: 300,
      );
      if (image == null) return;

      // pickedImageFiles.clear(); // Clear previous images
      // image64List.clear(); // Clear previous base64 strings
      // pikedImagePaths.clear(); // Clear previous paths

      pickedImageFiles.add(File(image.path));
      final bytes = await File(image.path).readAsBytes();
      String base64Image = base64Encode(bytes);
      image64List.add(base64Image);
      pikedImagePaths.add(image.path);

      print(image64List.length);
      print(pikedImagePaths.length);
      Get.back();
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  void removeImage(file) {
    // Find the index of the file to remove
    final int index = pickedImageFiles.indexOf(file);

    if (index != -1) {
      // Remove from both lists simultaneously
      pickedImageFiles.removeAt(index);
      image64List.removeAt(index);
    }
  }

  void removeIcon(file) {
    // Find the index of the file to remove
    final int index = selectedIconPaths.indexOf(file);

    if (index != -1) {
      // Remove from both lists simultaneously
      selectedIconPaths.removeAt(index);
      image64List.removeAt(index);
    }
  }

  var pickedImageFiles = <File>[].obs; // Observable list for multiple images
  var image64List = <String>[].obs; // Observable list for base64 images
  var pikedImagePaths = <String>[].obs; // Observable list for image paths
  var selectedIconPaths = <String>[].obs;

  pilihIcon(BuildContext context) {
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

  Future<void> _onIconSelectedv2(String iconPath) async {
    // Handle the selected icon
    // pikedImagePath.value = '';
    selectedIconPaths.add(iconPath);
    final String base64Svg = await svgToBase64(iconPath);
    image64List.add(base64Svg);
    print('Base64 SVG: $base64Svg');
    print(image64List.length);
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

  var gambartemp = <DataGambarProduk>[];
  var hargajualtemp = <DataHargaJualProduk>[];
  var satuantemp = <DataSatuanProduk>[];
  var pajaktemp = <DataPajakProduk>[];
  var ukurantemp = <DataUkuranProduk>[];

  fetchpajak({id_toko}) async {
    print('-------------------fetch pajak paket local---------------------');

    List<Map<String, Object?>> query = await DBHelper().FETCH(
        'SELECT * FROM pajak_produk WHERE id_toko = "$id_toko" AND aktif = 1');
    if (query.isNotEmpty) {
      List<DataPajakProduk> data =
          query.map((e) => DataPajakProduk.fromJsondb(e)).toList();
      pajakList.value = data;
      //print(data.first.uuid);
      return data;
    } else {
      print('empty');
      return null;
    }
  }

  fetchukuran({id_toko}) async {
    print('-------------------fetch ukuran local---------------------');

    List<Map<String, Object?>> query = await DBHelper().FETCH(
        'SELECT * FROM ukuran_produk WHERE id_toko = "$id_toko" AND aktif = 1');
    if (query.isNotEmpty) {
      List<DataUkuranProduk> data =
          query.map((e) => DataUkuranProduk.fromJsondb(e)).toList();
      ukuranList.value = data;
      print(data);
      return data;
    } else {
      print('empty');
      return null;
    }
  }

  tambahPajak() async {
    print('-------------------tambah pajak local---------------------');

    Get.dialog(showloading(), barrierDismissible: false);
    var uuid = Uuid().v4();
    var db = await DBHelper().INSERT(
        'pajak_produk',
        DataPajakProduk(
                id_toko: id_toko,
                uuid: uuid,
                aktif: 1,
                nama_pajak: namaPajak.value.text,
                nominal_pajak:
                    double.parse(nominalPajak.value.text.replaceAll(',', '')))
            .DB());

    if (db != null) {
      print(db);
      await Get.find<BaseMenuProdukController>()
          .fetchPajakLocal(id_toko: id_toko);
      await fetchpajak(id_toko: id_toko);

      pajakValue = uuid;
      Get.back(closeOverlays: true);
      Get.showSnackbar(toast().bottom_snackbar_success('Sukses', 'Berhasil'));
    } else {
      Get.back();
      Get.showSnackbar(toast().bottom_snackbar_error('error', 'gagal'));
    }
  }

  tambahPajakDariEdit() async {
    print('-------------------tambah pajak local---------------------');

    Get.dialog(showloading(), barrierDismissible: false);
    var uuid = Uuid().v4();
    var db = await DBHelper().INSERT(
        'pajak_produk',
        DataPajakProduk(
                id_toko: id_toko,
                uuid: uuid,
                aktif: 1,
                nama_pajak: namaPajak.value.text,
                nominal_pajak:
                    double.parse(nominalPajak.value.text.replaceAll(',', '')))
            .DB());

    if (db != null) {
      print(db);
      await Get.find<BaseMenuProdukController>()
          .fetchPajakLocal(id_toko: id_toko);
      await fetchpajak(id_toko: id_toko);
      await Get.find<EditIsiProdukController>().fetchpajak(id_toko: id_toko);
      await Get.find<EditIsiProdukController>().fetchukuran(id_toko: id_toko);
      var x = Get.find<EditIsiProdukController>();
      x.pajakValue = uuid;
      pajakValue = uuid;
      Get.back(closeOverlays: true);
      Get.showSnackbar(toast().bottom_snackbar_success('Sukses', 'Berhasil'));
    } else {
      Get.back();
      Get.showSnackbar(toast().bottom_snackbar_error('error', 'gagal'));
    }
  }

  Map<String, dynamic> dataedit(
      {id_kelompok_produk,
      id_sub_kelompok_produk,
      gambar_produk_utama,
      kode_produk,
      nama_produk,
      serial_key,
      imei,
      hitung_stok,
      tampilkan_di_produk,
      harga_beli,
      hpp,
      harga_jual_grosir,
      harga_jual_eceran,
      pajak,
      info_stok_habis,
      ukuran,
      berat,
      volume_panjang,
      volume_lebar,
      volume_tinggi,
      id_gambar,
      jenisproduk,
      harga_jual_pelanggan}) {
    var map = <String, dynamic>{};

    // Add all fields directly (no null checks)

    map['id_kelompok_produk'] = id_kelompok_produk;
    map['id_sub_kelompok_produk'] = id_sub_kelompok_produk;
    map['gambar_produk_utama'] = gambar_produk_utama;
    map['kode_produk'] = kode_produk;
    map['nama_produk'] = nama_produk;
    map['serial_key'] = serial_key;
    map['imei'] = imei;
    map['hitung_stok'] = hitung_stok;
    map['tampilkan_di_produk'] = tampilkan_di_produk;
    map['harga_beli'] = harga_beli;
    map['hpp'] = hpp;
    map['harga_jual_grosir'] = harga_jual_grosir;
    map['harga_jual_eceran'] = harga_jual_eceran;
    map['harga_jual_pelanggan'] = harga_jual_pelanggan;
    map['jenis_produk'] = jenisproduk;
    map['pajak'] = pajak;
    map['info_stok_habis'] = info_stok_habis;
    map['ukuran'] = ukuran;
    map['berat'] = berat ?? 0;
    map['volume_panjang'] = volume_panjang ?? 0;
    map['volume_lebar'] = volume_lebar ?? 0;
    map['volume_tinggi'] = volume_tinggi ?? 0;
    map['id_gambar'] = id_gambar;
    ;

    return map;
  }

  List<dynamic> insertResults = []; // Track insertion results
  var harga_modal = 0.0.obs;
  var harga_hpp = 0.0.obs;

  tambahPaketProduk() async {
    print('-------------------tambah paket produk local---------------------');

    Get.dialog(showloading(), barrierDismissible: false);
    //var uuid_produk = Uuid().v4();
    //var uuid_gambar = Uuid().v4();
    var uuidPaket = Uuid().v4();

    var uuid_pajak = Uuid().v4();
    var uuid_ukuran = Uuid().v4();

    var paket = await DBHelper().INSERT(
      'paket_produk',
      DataPaketProduk(
        id_toko: id_toko,
        hpp: harga_hpp.value,
        uuid: uuidPaket,
        aktif: 1,
        pajak: pajakValue,
        gambar_utama: image64,
        harga_jual_paket: hargaJualPaket.value.text.isNotEmpty
            ? double.parse(hargaJualPaket.value.text.replaceAll(',', ''))
            : 0,
        nama_paket: namaPaket.value.text,
        harga_modal: harga_modal.value,
        tampilkan_di_paket: tampilkanDiProduk.value == true ? 1 : 0,
        diskon: selecteddiskon.value == 'Rp.'
            ? diskonvalue.value
            : (double.parse(hargaJualPaket.value.text.replaceAll(',', '')) *
                diskonvalue.value /
                100),
        // hitungStock: hitung_stock.value == true ? 1 : 0,
      ).DB(),
    );

    if (paket != null) {
      for (DataProdukTemp produk in produktemp) {
        var uuuidDetauilpaket = Uuid().v4();
        var detail = await DBHelper().INSERT(
            'detail_paket_produk',
            DataDetailPaketProduk(
                    aktif: 1,
                    uuid: uuuidDetauilpaket,
                    hpp: produk.hpp,
                    id_produk: produk.uuid,
                    id_toko: id_toko,
                    harga_modal: produk.harga_beli,
                    id_paket_produk: uuidPaket,
                    qty: produk.qty,
                    sub_harga_modal: produk.harga_beli! * produk.qty,
                    sub_hpp: produk.hpp! * produk.qty)
                .DB());
      }
      await Get.find<CentralPaketController>()
          .fetchPaketLocal(id_toko: id_toko);
      Get.back(closeOverlays: true);
      Get.showSnackbar(toast().bottom_snackbar_success('Sukses', 'Berhasil'));
    } else {
      Get.back();
      Get.showSnackbar(toast().bottom_snackbar_error('error', 'gagal'));
    }
  }

// Future<void> tambahHargaJualProduk() async {
//   print('-------------------tambah supplier local---------------------');
//   var uuid_produk = Uuid().v4();
//   var uuid = Uuid().v4();
//   Get.dialog(showloading(), barrierDismissible: false);
//   var hargaJualInsertResult = await DBHelper().INSERT(
//     'harga_jual_produk',
//     DataHargaJualProduk(
//       uuid: uuid,
//       id_produk: uuid_produk,
//       id_toko: id_toko,
//       aktif: 1,
//       harga_jual: double.parse(hargaJualUtama.value.text),
//       jenis_transaksi: 'qweqwe',
//       // Add other fields as necessary
//     ).DB(),
//   );
// }

  void tambahSatuanProduk() {}

  Future<void> tambahUkuranProdukDariEdit() async {
    print('-------------------tambah ukuran local---------------------');

    Get.dialog(showloading(), barrierDismissible: false);
    var uuid = Uuid().v4();
    var db = await DBHelper().INSERT(
        'ukuran_produk',
        DataUkuranProduk(
                id_toko: id_toko,
                aktif: 1,
                uuid: uuid,
                ukuran: ukuranProduk.value.text)
            .DB());

    if (db != null) {
      print(db);
      await Get.find<BaseMenuProdukController>()
          .fetchUkuranLocal(id_toko: id_toko);
      fetchukuran(id_toko: id_toko);
      await Get.find<EditIsiProdukController>().fetchpajak(id_toko: id_toko);
      await Get.find<EditIsiProdukController>().fetchukuran(id_toko: id_toko);
      var x = Get.find<EditIsiProdukController>();
      x.ukuranValue = uuid;
      ukuranValue = uuid;
      Get.back(closeOverlays: true);
      Get.showSnackbar(toast().bottom_snackbar_success('Sukses', 'Berhasil'));
    } else {
      Get.back();
      Get.showSnackbar(toast().bottom_snackbar_error('error', 'gagal'));
    }
  }

  Future<void> tambahUkuranProduk() async {
    print('-------------------tambah ukuran local---------------------');

    Get.dialog(showloading(), barrierDismissible: false);
    var uuid = Uuid().v4();
    var db = await DBHelper().INSERT(
        'ukuran_produk',
        DataUkuranProduk(
                id_toko: id_toko,
                aktif: 1,
                uuid: uuid,
                ukuran: ukuranProduk.value.text)
            .DB());

    if (db != null) {
      print(db);
      await Get.find<BaseMenuProdukController>()
          .fetchUkuranLocal(id_toko: id_toko);
      fetchukuran(id_toko: id_toko);
      ukuranValue = uuid;
      Get.back(closeOverlays: true);
      Get.showSnackbar(toast().bottom_snackbar_success('Sukses', 'Berhasil'));
    } else {
      Get.back();
      Get.showSnackbar(toast().bottom_snackbar_error('error', 'gagal'));
    }
  }

  deleteKategoriProduk({uuid}) async {
    print(
        'delete kategori produk local---------------------------------------->');
    Get.dialog(const showloading(), barrierDismissible: false);
    var delete = await DBHelper().DELETE(table: 'Kelompok_produk', id: uuid);
    if (delete == 1) {
      // await Get.find<PelangganController>()
      //     .fetchPelangganLocal(id_toko: id_toko);
      //await fetchKategoriProdukLocal(id_toko: id_toko);
      Get.back();
      Get.back();
      Get.showSnackbar(toast()
          .bottom_snackbar_success('Sukses', 'kategori berhasil dihapus'));
      print('deleted ' + uuid.toString());
    } else {
      Get.back();
      Get.showSnackbar(toast()
          .bottom_snackbar_error('Error', 'gagal menghapus kategori beban'));
    }

    // var select = kategoripelangganList.where((x) => x.uuid == uuid).first;
    // var delete = await DBHelper().UPDATE(
    //   id: select.idLocal,
    //   table: 'beban_local',
    //   data: DataBeban(
    //       aktif: 'N',
    //       sync: 'N',
    //       id: select.id,
    //       idLocal: select.idLocal,
    //       idToko: select.idToko,
    //       jumlah: select.jumlah,
    //       tgl: select.tgl,
    //       keterangan: select.keterangan,
    //       nama: select.nama,
    //       idKtrBeban: select.idKtrBeban,
    //       idUser: select.idUser,
    //       namaKtrBeban: select.namaKtrBeban)
    //       .toMapForDb(),
    // );

    // var query = await DBHelper().DELETE('produk_local', id);
    // if (delete == 1) {
    //   await fetchBebanlocal(id_toko);
    //   await Get.find<dashboardController>().loadbebanhariini();
    //   await Get.find<dashboardController>().loadpendapatanhariini();
    //   await Get.find<dashboardController>().loadpendapatantotal();
    //   Get.back(closeOverlays: true);
    //   Get.showSnackbar(
    //       toast().bottom_snackbar_success('Sukses', 'Beban berhasil dihapus'));
    //   print('deleted ' + id_local.toString());
    // } else {
    //   Get.back(closeOverlays: true);
    //   Get.showSnackbar(toast()
    //       .bottom_snackbar_error('Error', 'gagal menghapus kategori beban'));
    // }
  }

  bool isBase64Svg(String base64) {
    try {
      // Decode the base64 string to UTF-8
      final String decoded = utf8.decode(base64Decode(base64));
      // Check if the decoded string contains '<svg'
      return decoded.contains('<svg');
    } catch (e) {
      // If decoding fails, it's not an SVG
      return false;
    }
  }

  fetchKategoriProdukLocal({id_toko}) async {
    print('-------------------fetch pelanggan local---------------------');

    List<Map<String, Object?>> query = await DBHelper().FETCH(
        'SELECT * FROM Kelompok_produk WHERE id_toko = "$id_toko" AND Aktif = 1');
    if (query.isNotEmpty) {
      List<DataKategoriProduk> data =
          query.map((e) => DataKategoriProduk.fromJsondb(e)).toList();
      kategorilist.value = data;
      //print(data.first.uuid);
      return data;
    } else {
      print('empty');
      return null;
    }
  }

  var produk = <DataProduk>[].obs;

  fetchProdukLocal({id_toko}) async {
    print('-------------------fetch produk local---------------------');

    List<Map<String, Object?>> query = await DBHelper().FETCH('''
  SELECT 
      produk.*, 
      kelompok_produk.Nama_Kelompok AS nama_kategori,
      Sub_kelompok_produk.Nama_Sub_Kelompok AS nama_subkategori,
      pajak_produk.nama_pajak AS nama_pajak,
      pajak_produk.nominal_pajak AS nominal_pajak,
      ukuran_produk.ukuran as nama_ukuran
  FROM 
      produk 
  LEFT JOIN 
     Kelompok_produk ON produk.id_kelompok_produk = Kelompok_produk.uuid
  LEFT JOIN 
     Sub_kelompok_produk ON produk.id_sub_kelompok_produk = Sub_kelompok_produk.uuid
  LEFT JOIN 
     pajak_produk ON produk.pajak = pajak_produk.uuid
  LEFT JOIN 
     ukuran_produk ON produk.ukuran = ukuran_produk.uuid
  WHERE 
      produk.id_toko = "$id_toko"
  ''');
    if (query.isNotEmpty) {
      List<DataProduk> data =
          query.map((e) => DataProduk.fromJsondb(e)).toList();
      produk.value = data;
      return data;
    } else {
      print('empty');
      return null;
    }
  }

  fetchSubKategoriProdukLocal({id_toko, kategori}) async {
    print('-------------------fetch pelanggan local---------------------');

    List<Map<String, Object?>> query = await DBHelper().FETCH(
        'SELECT * FROM Sub_Kelompok_produk WHERE id_toko = "$id_toko" AND ID_Kelompok_Produk = "$kategori" AND aktif = 1');
    if (query.isNotEmpty) {
      List<DataSubKategoriProduk> data =
          query.map((e) => DataSubKategoriProduk.fromJsondb(e)).toList();
      subKategorilist.value = data;
      //logo.value = userList.value.first.logo!;
      return data;
    } else {
      print('empty');
      return null;
    }
  }

  var produkQTY = 0.obs;

  popaddproduk() {
    Get.dialog(AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      contentPadding: EdgeInsets.all(10),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12.0),
        ),
      ),
      content: Builder(
        builder: (context) {
          return Container(
            width: context.res_width,
            child: produk.isNotEmpty
                ? ListView.builder(
                    itemCount: produk.length,
                    itemBuilder: (context, index) {
                      final customer = produk;

                      return customer[index].tampilkan_di_produk == 1
                          ? GestureDetector(
                              onTap: () {
                                final existingIndex = produktemp.indexWhere(
                                    (item) =>
                                        item.uuid == customer[index].uuid);
                                //produktemp.refresh();
                                if (existingIndex == -1) {
                                  produktemp.add(DataProdukTemp(
                                    qty: 1,
                                    hpp: customer[index].hpp,
                                    nama_produk: customer[index].nama_produk,
                                    uuid: customer[index].uuid,
                                    harga_jual_pelanggan:
                                        customer[index].harga_jual_pelanggan,
                                    serial_key: customer[index].serial_key,
                                    namaKategori: customer[index].namaKategori,
                                    namasubKategori:
                                        customer[index].namasubKategori,
                                    id_toko: customer[index].id_toko,
                                    imei: customer[index].imei,
                                    harga_jual_eceran:
                                        customer[index].harga_jual_eceran,
                                    harga_jual_grosir:
                                        customer[index].harga_jual_grosir,
                                    id_sub_kelompok_produk:
                                        customer[index].id_sub_kelompok_produk,
                                    id_kelompok_produk:
                                        customer[index].id_kelompok_produk,
                                    kode_produk: customer[index].kode_produk,
                                    jenisProduk: customer[index].jenisProduk,
                                    pajak: customer[index].pajak,
                                    info_stok_habis:
                                        customer[index].info_stok_habis,
                                    ukuran: customer[index].ukuran,
                                    berat: customer[index].berat,
                                    volume_panjang:
                                        customer[index].volume_panjang,
                                    volume_lebar: customer[index].volume_lebar,
                                    volume_tinggi:
                                        customer[index].volume_tinggi,
                                    id_gambar: customer[index].id_gambar,
                                    gambar_produk_utama:
                                        customer[index].gambar_produk_utama,
                                    stockawal: customer[index].stockawal,
                                    nominalpajak: customer[index].nominalpajak,
                                    harga_beli: customer[index].harga_beli,
                                    hitung_stok: customer[index].hitung_stok,
                                    tampilkan_di_produk:
                                        customer[index].tampilkan_di_produk,
                                    namaPajak: customer[index].namaPajak,
                                    namaukuran: customer[index].namaukuran,
                                  ));

                                  // harga_modal.value +=
                                  //     customer[index].harga_beli!;
                                  // harga_hpp.value += customer[index].hpp!;
                                  // hargaModal.value.text =
                                  //     harga_modal.value.toString();
                                  // hpp.value.text = harga_hpp.value.toString();
                                  // print('sum harga modal --->' +
                                  //     harga_modal.value.toString());
                                  // print('sum harga hpp --->' +
                                  //     harga_hpp.value.toString());
                                  produktemp.refresh();
                                } else {
                                  produktemp[existingIndex].qty++;
                                  produktemp.refresh();
                                }
                                harga_modal.value +=
                                    customer[index].harga_beli!;
                                harga_hpp.value += customer[index].hpp!;
                                hargaModal.value.text =
                                    harga_modal.value.toString();
                                hpp.value.text = harga_hpp.value.toString();
                                print('sum harga modal --->' +
                                    harga_modal.value.toString());
                                print('sum harga hpp --->' +
                                    harga_hpp.value.toString());
                              },
                              child: Column(
                                children: [
                                  ListTile(
                                      leading: ClipOval(
                                        child: customer[index]
                                                        .gambar_produk_utama !=
                                                    '' &&
                                                customer[index]
                                                        .gambar_produk_utama !=
                                                    null
                                            ? isBase64Svg(customer[index]
                                                    .gambar_produk_utama!)
                                                ? SvgPicture.memory(
                                                    base64Decode(customer[index]
                                                        .gambar_produk_utama!),
                                                    width: 30,
                                                    height: 40,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.memory(
                                                    base64Decode(customer[index]
                                                        .gambar_produk_utama!),
                                                    width: 30,
                                                    height: 40,
                                                    fit: BoxFit.cover,
                                                  )
                                            : Image.asset(
                                                AppString.defaultImg,
                                                width: 30,
                                                height: 40,
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                      title: Text(
                                        customer[index].nama_produk ??
                                            'default nama',
                                        style: AppFont.regular(),
                                      ),
                                      subtitle: Text(
                                        customer[index].namaKategori!,
                                        style: AppFont.small(),
                                      ),
                                      trailing: Text(
                                        customer[index].hpp.toString(),
                                        style: AppFont.small(),
                                      )),
                                  Container(
                                    height: 0.5,
                                    color: Colors.black,
                                  )
                                ],
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                Get.toNamed('/isiproduk',
                                    arguments: customer[index]);
                              },
                              child: Card(
                                color: Colors.grey[300],
                                margin: EdgeInsets.only(bottom: 25),
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ListTile(
                                  leading: ClipOval(
                                    child:
                                        customer[index].gambar_produk_utama !=
                                                    '' &&
                                                customer[index]
                                                        .gambar_produk_utama !=
                                                    null
                                            ? isBase64Svg(customer[index]
                                                    .gambar_produk_utama!)
                                                ? SvgPicture.memory(
                                                    base64Decode(customer[index]
                                                        .gambar_produk_utama!),
                                                    width: 30,
                                                    height: 40,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.memory(
                                                    base64Decode(customer[index]
                                                        .gambar_produk_utama!),
                                                    width: 30,
                                                    height: 40,
                                                    fit: BoxFit.cover,
                                                  )
                                            : Image.asset(
                                                AppString.defaultImg,
                                                width: 30,
                                                height: 40,
                                                fit: BoxFit.cover,
                                              ),
                                  ),
                                  title: Text(
                                    customer[index].nama_produk ??
                                        'default nama',
                                    style: AppFont.regular(),
                                  ),
                                  subtitle: Text('Nonaktif',
                                      style: TextStyle(color: Colors.red)),
                                ),
                              ),
                            );
                    },
                  )
                : EmptyData(),
          );
        },
      ),
    ));
  }

  var searchproduk = TextEditingController().obs;

  searchProdukLocal({id_toko}) async {
    print('-------------------fetch produk local---------------------');

    List<Map<String, Object?>> query = await DBHelper().FETCH('''
    SELECT 
        produk.*, 
        kelompok_produk.Nama_Kelompok AS nama_kategori,
        Sub_kelompok_produk.Nama_Sub_Kelompok AS nama_subkategori,
        pajak_produk.nama_pajak AS nama_pajak,
        ukuran_produk.ukuran as nama_ukuran
    FROM 
        produk 
    LEFT JOIN 
       Kelompok_produk ON produk.id_kelompok_produk = Kelompok_produk.uuid
    LEFT JOIN 
       Sub_kelompok_produk ON produk.id_sub_kelompok_produk = Sub_kelompok_produk.uuid
    LEFT JOIN 
       pajak_produk ON produk.pajak = pajak_produk.uuid
    LEFT JOIN 
       ukuran_produk ON produk.ukuran = ukuran_produk.uuid
    WHERE 
        produk.id_toko = "$id_toko" AND produk.nama_produk LIKE "%${searchproduk.value.text}%"
  ''');
    if (query.isNotEmpty) {
      List<DataProduk> data =
          query.map((e) => DataProduk.fromJsondb(e)).toList();
      produk.value = data;
      print("data search-------->" + data.toString());
      return data;
    } else {
      print('empty');
      return [];
    }
  }

  popaddprodukv2() {
    var con = Get.find<CentralProdukController>();
    con.fetchProdukLocal(id_toko: id_toko, isAktif: true);
    Get.dialog(SheetViewport(
        child: Sheet(
      scrollConfiguration: SheetScrollConfiguration(),
      initialOffset: const SheetOffset(0.5),
      physics: BouncingSheetPhysics(),
      snapGrid: MultiSnapGrid(snaps: [SheetOffset(0.5), SheetOffset(1)]),
      child: Material(
        color: Colors.transparent,
        child: Obx(() {
          return Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              padding: AppPading.defaultBodyPadding(),
              height: Get.height * 0.5,
              child: Column(children: [
                Obx(() {
                  return TextField(
                    onChanged: (val) {
                      print(val);
                      con.searchProdukLocal(id_toko: id_toko);
                    },
                    controller: con.searchproduk.value,
                    decoration: InputDecoration(hintText: 'Cari...'),
                  );
                }),
                con.produk.isNotEmpty
                    ? Expanded(
                        child: ListView.builder(
                          itemCount: con.produk.length,
                          itemBuilder: (context, index) {
                            final customer = con.produk;

                            return customer[index].tampilkan_di_produk == 1
                                ? GestureDetector(
                                    onTap: () {
                                      var check = con.produk
                                          .where((element) =>
                                              element.uuid ==
                                              customer[index].uuid)
                                          .first;
                                      final existingIndex =
                                          produktemp.indexWhere((item) =>
                                              item.uuid ==
                                              customer[index].uuid);
                                      if (check.qty == 0 &&
                                          check.tampilkan_di_produk == 1 &&
                                          check.hitung_stok == 1) {
                                        Get.showSnackbar(toast()
                                            .bottom_snackbar_error("Error",
                                                'Stock sudah habis! harap isi stock terlebih dahulu'));
                                        return;
                                      }
                                      if (existingIndex == -1) {
                                        produktemp.add(DataProdukTemp(
                                          qty: 1,
                                          hpp: customer[index].hpp,
                                          nama_produk:
                                              customer[index].nama_produk,
                                          uuid: customer[index].uuid,
                                          harga_jual_pelanggan: customer[index]
                                              .harga_jual_pelanggan,
                                          serial_key:
                                              customer[index].serial_key,
                                          namaKategori:
                                              customer[index].namaKategori,
                                          namasubKategori:
                                              customer[index].namasubKategori,
                                          id_toko: customer[index].id_toko,
                                          imei: customer[index].imei,
                                          harga_jual_eceran:
                                              customer[index].harga_jual_eceran,
                                          harga_jual_grosir:
                                              customer[index].harga_jual_grosir,
                                          id_sub_kelompok_produk:
                                              customer[index]
                                                  .id_sub_kelompok_produk,
                                          id_kelompok_produk: customer[index]
                                              .id_kelompok_produk,
                                          kode_produk:
                                              customer[index].kode_produk,
                                          jenisProduk:
                                              customer[index].jenisProduk,
                                          pajak: customer[index].pajak,
                                          info_stok_habis:
                                              customer[index].info_stok_habis,
                                          ukuran: customer[index].ukuran,
                                          berat: customer[index].berat,
                                          volume_panjang:
                                              customer[index].volume_panjang,
                                          volume_lebar:
                                              customer[index].volume_lebar,
                                          volume_tinggi:
                                              customer[index].volume_tinggi,
                                          id_gambar: customer[index].id_gambar,
                                          gambar_produk_utama: customer[index]
                                              .gambar_produk_utama,
                                          stockawal: customer[index].stockawal,
                                          nominalpajak:
                                              customer[index].nominalpajak,
                                          harga_beli:
                                              customer[index].harga_beli,
                                          hitung_stok:
                                              customer[index].hitung_stok,
                                          tampilkan_di_produk: customer[index]
                                              .tampilkan_di_produk,
                                          namaPajak: customer[index].namaPajak,
                                          namaukuran:
                                              customer[index].namaukuran,
                                          diskon: customer[index].diskon,
                                        ));

                                        produktemp.refresh();
                                      } else {
                                        if (produktemp[existingIndex].qty >
                                                check.qty! &&
                                            check.tampilkan_di_produk == 1 &&
                                            check.hitung_stok == 1) {
                                          Get.showSnackbar(toast()
                                              .bottom_snackbar_error("Error",
                                                  'Stock tidak mencukupi'));

                                          return;
                                        }
                                        produktemp[existingIndex].qty++;
                                        produktemp.refresh();
                                      }
                                      harga_modal.value +=
                                          customer[index].harga_beli!;
                                      harga_hpp.value += customer[index].hpp!;
                                      hargaModal.value.text = AppFormat()
                                          .numFormat(harga_modal.value);
                                      hpp.value.text = AppFormat()
                                          .numFormat(harga_hpp.value);
                                      print('sum harga modal --->' +
                                          harga_modal.value.toString());
                                      print('sum harga hpp --->' +
                                          harga_hpp.value.toString());
                                    },
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: ListTile(
                                                  leading: customer[index]
                                                                  .gambar_produk_utama !=
                                                              '' &&
                                                          customer[index]
                                                                  .gambar_produk_utama !=
                                                              null
                                                      ? isBase64Svg(customer[
                                                                  index]
                                                              .gambar_produk_utama!)
                                                          ? SvgPicture.memory(
                                                              base64Decode(customer[
                                                                      index]
                                                                  .gambar_produk_utama!),
                                                              width: 50,
                                                              height: 50,
                                                              fit: BoxFit
                                                                  .contain,
                                                            )
                                                          : Image.memory(
                                                              base64Decode(customer[
                                                                      index]
                                                                  .gambar_produk_utama!),
                                                              width: 50,
                                                              height: 50,
                                                              fit: BoxFit
                                                                  .contain,
                                                            )
                                                      : Image.asset(
                                                          AppString.defaultImg,
                                                          width: 50,
                                                          height: 500,
                                                          fit: BoxFit.contain,
                                                        ),
                                                  title: Text(
                                                    customer[index]
                                                            .nama_produk ??
                                                        'default nama',
                                                    style: AppFont.regular(),
                                                  ),
                                                  subtitle: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        customer[index]
                                                                    .hitung_stok ==
                                                                1
                                                            ? 'Qty : ' +
                                                                customer[index]
                                                                    .qty
                                                                    .toString()
                                                            : 'Nonstock',
                                                        style: AppFont.small(),
                                                      ),
                                                      Text(
                                                        'HPP ' +
                                                            AppFormat().numFormat(
                                                                customer[index]
                                                                    .hpp),
                                                        style: AppFont.small(),
                                                      ),
                                                    ],
                                                  )),
                                            ),
                                            button_solid_custom(
                                                onPressed: () {
                                                  popaddqty(customer[index]);
                                                },
                                                child: Text(
                                                  '+ Qty',
                                                  style: AppFont.small_white(),
                                                ),
                                                width: 100)
                                          ],
                                        ),
                                        Container(
                                          height: 0.5,
                                          color: Colors.black,
                                        )
                                      ],
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      // Get.toNamed('/isiproduk',
                                      //     arguments: customer[index]);
                                    },
                                    child: Card(
                                      color: Colors.grey[300],
                                      margin: EdgeInsets.only(bottom: 25),
                                      elevation: 4,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: ListTile(
                                        leading: ClipOval(
                                          child: customer[index]
                                                          .gambar_produk_utama !=
                                                      '' &&
                                                  customer[index]
                                                          .gambar_produk_utama !=
                                                      null
                                              ? isBase64Svg(customer[index]
                                                      .gambar_produk_utama!)
                                                  ? SvgPicture.memory(
                                                      base64Decode(customer[
                                                              index]
                                                          .gambar_produk_utama!),
                                                      width: 30,
                                                      height: 40,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Image.memory(
                                                      base64Decode(customer[
                                                              index]
                                                          .gambar_produk_utama!),
                                                      width: 30,
                                                      height: 40,
                                                      fit: BoxFit.cover,
                                                    )
                                              : Image.asset(
                                                  AppString.defaultImg,
                                                  width: 30,
                                                  height: 40,
                                                  fit: BoxFit.cover,
                                                ),
                                        ),
                                        title: Text(
                                          customer[index].nama_produk ??
                                              'default nama',
                                          style: AppFont.regular(),
                                        ),
                                        subtitle: Text('Nonaktif',
                                            style:
                                                TextStyle(color: Colors.red)),
                                      ),
                                    ),
                                  );
                          },
                        ),
                      )
                    : Expanded(child: Text('kosong')),
              ]));
        }),
      ),
    )));
  }

  var customqty = TextEditingController().obs;

  RxList<String> deletedDetailIds = <String>[].obs;

  popaddqty(DataProduk data) {
    var con = Get.find<CentralProdukController>();
    Get.dialog(AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      contentPadding: EdgeInsets.all(10),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12.0),
        ),
      ),
      content: Builder(
        builder: (context) {
          return Container(
              height: Get.height * 0.25,
              width: context.res_width,
              padding: AppPading.defaultBodyPadding(),
              child: Column(children: [
                Expanded(child: Text('Qty')),
                Expanded(
                  child: TextField(
                      controller: customqty.value,
                      decoration: InputDecoration(
                          hintText: 'Masukan jumlah produk',
                          border: OutlineInputBorder())),
                ),

                //tambah add - qty di list
                Expanded(
                  child: button_solid_custom(
                      onPressed: () {
                        final existingIndex = produktemp
                            .indexWhere((item) => item.uuid == data.uuid);
                        final qty = int.parse(customqty.value.text);
                        var check = con.produk
                            .where((element) => element.uuid == data.uuid)
                            .first;
                        if (check.qty == 0 &&
                            check.tampilkan_di_produk == 1 &&
                            check.hitung_stok == 1) {
                          Get.showSnackbar(toast().bottom_snackbar_error(
                              "Error",
                              'Stock sudah habis! harap isi stock terlebih dahulu'));
                          return;
                        }

                        if (existingIndex == -1) {
                          produktemp.add(DataProdukTemp(
                            qty: qty,
                            hpp: data.hpp,
                            nama_produk: data.nama_produk,
                            uuid: data.uuid,
                            harga_jual_pelanggan: data.harga_jual_pelanggan,
                            serial_key: data.serial_key,
                            namaKategori: data.namaKategori,
                            namasubKategori: data.namasubKategori,
                            id_toko: data.id_toko,
                            imei: data.imei,
                            harga_jual_eceran: data.harga_jual_eceran,
                            harga_jual_grosir: data.harga_jual_grosir,
                            id_sub_kelompok_produk: data.id_sub_kelompok_produk,
                            id_kelompok_produk: data.id_kelompok_produk,
                            kode_produk: data.kode_produk,
                            jenisProduk: data.jenisProduk,
                            pajak: data.pajak,
                            info_stok_habis: data.info_stok_habis,
                            ukuran: data.ukuran,
                            berat: data.berat,
                            volume_panjang: data.volume_panjang,
                            volume_lebar: data.volume_lebar,
                            volume_tinggi: data.volume_tinggi,
                            id_gambar: data.id_gambar,
                            gambar_produk_utama: data.gambar_produk_utama,
                            stockawal: data.stockawal,
                            nominalpajak: data.nominalpajak,
                            harga_beli: data.harga_beli,
                            hitung_stok: data.hitung_stok,
                            tampilkan_di_produk: data.tampilkan_di_produk,
                            namaPajak: data.namaPajak,
                            namaukuran: data.namaukuran,
                          ));

                          produktemp.refresh();
                        } else {
                          if (produktemp[existingIndex].qty > check.qty! &&
                              check.tampilkan_di_produk == 1 &&
                              check.hitung_stok == 1) {
                            Get.showSnackbar(toast().bottom_snackbar_error(
                                "Error", 'Stock tidak mencukupi'));

                            return;
                          }
                          produktemp[existingIndex].qty += qty;
                          produktemp.refresh();
                        }
                        harga_modal.value += data.harga_beli! * qty;
                        harga_hpp.value += data.hpp! * qty;
                        hargaModal.value.text =
                            AppFormat().numFormat(harga_modal.value);
                        hpp.value.text = AppFormat().numFormat(harga_hpp.value);
                        print('sum harga modal --->' +
                            harga_modal.value.toString());
                        print(
                            'sum harga hpp --->' + harga_hpp.value.toString());
                        Get.back();
                      },
                      child: Text('Tambah'),
                      width: Get.width),
                )
              ]));
        },
      ),
    ));
  }
}
