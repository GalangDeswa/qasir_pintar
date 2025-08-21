import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qasir_pintar/Config/config.dart';
import 'package:qasir_pintar/Controllers/CentralController.dart';
import 'package:uuid/uuid.dart';

import '../../../../Database/DB_helper.dart';
import '../../../../Widget/widget.dart';
import '../../Kategori/model_subkategoriproduk.dart';
import '../../Produk/model_kategoriproduk.dart';
import '../../controller_basemenuproduk.dart';
import '../model_produk.dart';

class EditIsiProdukController extends GetxController {
  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    loadDependencies();

    kategorivalue = data.id_kelompok_produk;
    subKategorivalue = data.id_sub_kelompok_produk;
    pajakValue = data.pajak ?? null;
    ukuranValue = data.ukuran ?? null;

    namaProduk.value.text = data.nama_produk ?? '';
    kodeProduk.value.text = data.kode_produk ?? '';
    serialKey.value.text = data.serial_key ?? '';
    imei.value.text = data.imei ?? '';
    hargaBeli.value.text = NumberFormat('#,###')
            .format(double.parse(data.harga_beli.toString())) ??
        '';
    hpp.value.text =
        NumberFormat('#,###').format(double.parse(data.hpp.toString())) ?? '';
    hargaJualGrosir.value.text = NumberFormat('#,###')
            .format(double.parse(data.harga_jual_grosir.toString())) ??
        '';
    hargaJualEceran.value.text = NumberFormat('#,###')
            .format(double.parse(data.harga_jual_eceran.toString())) ??
        '';
    hargaJualPelanggan.value.text = NumberFormat('#,###')
            .format(double.parse(data.harga_jual_pelanggan.toString())) ??
        '';
    stockAwal.value.text = data.stockawal?.toString() ?? '0';
    minimumStock.value.text = data.info_stok_habis?.toString() ?? '0';
    hitungStok.value = data.hitung_stok == 1 ? true : false;

    berat.value.text =
        NumberFormat('#,###').format(double.parse(data.berat.toString())) ?? '';
    volumePanjang.value.text = NumberFormat('#,###')
            .format(double.parse(data.volume_panjang.toString())) ??
        '';
    volumeLebar.value.text = NumberFormat('#,###')
            .format(double.parse(data.volume_lebar.toString())) ??
        '';
    volumeTinggi.value.text = NumberFormat('#,###')
            .format(double.parse(data.volume_tinggi.toString())) ??
        '';
    jenisvalue = data.jenisProduk;

    // Dropdowns

    // Switches
    hitungStok.value = data.hitung_stok == 1 ? true : false;
    tampilkanDiProduk.value = data.tampilkan_di_produk == 1 ? true : false;
    pajakdisplay.value = data.pajak != null ? true : false;
    ukurandisplay.value = data.ukuran != null ? true : false;
    dimensi.value = data.berat != 0.0 &&
            data.volume_lebar != 0.0 &&
            data.volume_panjang != 0.0 &&
            data.volume_tinggi != 0.0
        ? true
        : false;
    diskonvalue.value = data.diskon ?? 0.0;
    diskon.value.text =
        NumberFormat('#,###').format(double.parse(data.diskon.toString())) ??
            '0.0';
    print('diskon-->');
    print(data.diskon);
    showdiskon.value = data.diskon != 0.0 ? true : false;

    if (opsidiskon.isNotEmpty) {
      selecteddiskon.value = opsidiskon[0]; // Default to first option (Rp.)
    }

    // Images
    // if (data.gambar_produk_utama.isNotEmpty) {}
  }

  fetchpajak({id_toko}) async {
    print('-------------------fetch pajak local---------------------');

    List<Map<String, Object?>> query = await DBHelper()
        .FETCH('SELECT * FROM pajak_produk WHERE id_toko = "$id_toko"');
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

    List<Map<String, Object?>> query = await DBHelper()
        .FETCH('SELECT * FROM ukuran_produk WHERE id_toko = "$id_toko"');
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

  void loadDependencies() async {
    // Load necessary dropdown options
    await fetchKategoriProdukLocal(id_toko: id_toko);
    await fetchSubKategoriProdukLocal(
        id_toko: id_toko, kategori: kategorivalue);
    await fetchpajak(id_toko: id_toko);
    await fetchukuran(id_toko: id_toko);
    await fetchgambar(id_toko: id_toko, id_produk: data.uuid);
  }

  var jenisproduklist = ['Produk jadi', 'Bahan baku'].obs;
  var jenisvalue;
  Map<String, dynamic> dataeditstock({stockawal}) {
    var map = <String, dynamic>{};
    map['stok'] = stockawal;
    return map;
  }

  Map<String, dynamic> dataeditstockHPP({HPP}) {
    var map = <String, dynamic>{};
    map['hpp'] = HPP;
    return map;
  }

  Map<String, dynamic> dataeditproduk({
    id_kelompok_produk,
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
    harga_jual_pelanggan,
    pajak,
    info_stok_habis,
    ukuran,
    berat,
    volume_panjang,
    volume_lebar,
    volume_tinggi,
    id_gambar,
    jenis_produk,
    diskon,
    stock_awal,
  }) {
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
    map['pajak'] = pajak;
    map['stock_awal'] = stock_awal;
    map['info_stok_habis'] = info_stok_habis;
    map['ukuran'] = ukuran;
    map['berat'] = berat;
    map['volume_panjang'] = volume_panjang;
    map['volume_lebar'] = volume_lebar;
    map['volume_tinggi'] = volume_tinggi;
    map['jenis_produk'] = jenis_produk;
    map['diskon'] = diskon;

    return map;
  }

  Map<String, dynamic> dataeditgambar({gambar}) {
    var map = <String, dynamic>{};

    map['gambar'] = gambar;

    return map;
  }

  fetchgambar({id_toko, id_produk}) async {
    print('-------------------fetch gambar local---------------------');

    List<Map<String, Object?>> query = await DBHelper().FETCH(
        'SELECT * FROM gambar_produk WHERE id_toko = "$id_toko" AND id_produk = "$id_produk"');
    if (query.isNotEmpty) {
      List<DataGambarProduk> data =
          query.map((e) => DataGambarProduk.fromJsondb(e)).toList();
      gambarlist.value = data;
      originalGambarlist = List.from(data);
      //print(data.first.uuid);
      return data;
    } else {
      print('empty');
      return null;
    }
  }

  var gambarlist = <DataGambarProduk>[].obs;
//var uuid_produk = Uuid().v4();
  DataProduk data = Get.arguments;
  var hitungStok = false.obs;
  var tampilkanDiProduk = false.obs;
  var registerKey = GlobalKey<FormState>().obs;
  var registerKey2 = GlobalKey<FormState>().obs;
  var pajakkey = GlobalKey<FormState>().obs;
  var ukurankey = GlobalKey<FormState>().obs;
  var hargaJualPelanggan = TextEditingController().obs;
  var uuid = TextEditingController().obs;
  var idToko = TextEditingController().obs;
  var idKelompokProduk = TextEditingController().obs;
  var idSubKelompokProduk = TextEditingController().obs;
  var kodeProduk = TextEditingController().obs;
  var namaProduk = TextEditingController().obs;
  var serialKey = TextEditingController().obs;
  var imei = TextEditingController().obs;
  var hargaBeli = TextEditingController().obs;
  var hpp = TextEditingController().obs;
  var hargaJualGrosir = TextEditingController().obs;
  var hargaJualEceran = TextEditingController().obs;
  var satuanUtama = TextEditingController().obs;
  var isiDalamSatuan = TextEditingController().obs;
  var pajak = TextEditingController().obs;
  var minimumStock = TextEditingController().obs;
  var stockAwal = TextEditingController().obs;
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
  var produktemp = <DataProduk>[].obs;
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
                          pickImagesGallery();
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
                          pickImagesCamera();
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
                  _onIconSelectedv2(icons[index]);
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

  addtemp() {
    var uuid = Uuid().v4();
    produktemp.value.add(DataProduk(
      uuid: uuid,
      id_toko: id_toko,
      id_kelompok_produk: kategorivalue,
      id_sub_kelompok_produk: subKategorivalue,
      kode_produk: kodeProduk.value.text,
      nama_produk: namaProduk.value.text,
      serial_key: serialKey.value.text,
      imei: imei.value.text,
      harga_beli: double.parse(hargaBeli.value.text),
      hpp: double.parse(hpp.value.text),
    ));

    print(produktemp.first);

    Get.toNamed('/tambahprodukv3next');
  }

  var gambartemp = <DataGambarProduk>[];
  var hargajualtemp = <DataHargaJualProduk>[];
  var satuantemp = <DataSatuanProduk>[];
  var pajaktemp = <DataPajakProduk>[];
  var ukurantemp = <DataUkuranProduk>[];

  addtempv2() async {
    var uuid = Uuid().v4();
    produktemp.value.add(DataProduk(
      uuid: uuid,
      id_toko: id_toko,
      id_kelompok_produk: kategorivalue,
      id_sub_kelompok_produk: subKategorivalue,
      kode_produk: kodeProduk.value.text,
      nama_produk: namaProduk.value.text,
      serial_key: serialKey.value.text,
      imei: imei.value.text,
      harga_beli: double.parse(hargaBeli.value.text),
      hpp: double.parse(hpp.value.text),
    ));

    print('Product data prepared. Proceeding to next step.');
    // Navigate to the next page without inserting into the database
    await fetchpajak(id_toko: id_toko);
    await fetchukuran(id_toko: id_toko);
    Get.toNamed('/tambahprodukv3next');
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
                nominal_pajak: double.parse(nominalPajak.value.text))
            .DB());

    if (db != null) {
      print(db);
      await fetchpajak(id_toko: id_toko);
      pajakValue = uuid;
      Get.back(closeOverlays: true);
      Get.showSnackbar(toast().bottom_snackbar_success('Sukses', 'Berhasil'));
    } else {
      Get.back();
      Get.showSnackbar(toast().bottom_snackbar_error('error', 'gagal'));
    }
  }

  List<dynamic> insertResults = []; // Track insertion results
  List<DataGambarProduk> originalGambarlist = [];

  void removeImage(file) {
    // Find the index of the file to remove
    final int index = pickedImageFiles.indexOf(file);

    if (index != -1) {
      // Remove from both lists simultaneously
      pickedImageFiles.removeAt(index);
      image64List.removeAt(index);
      if (image64List.isEmpty) {
        print('image list empery-------------------->');
        data.gambar_produk_utama = null;
        print('gambar thumb-------------------->');
        print(data.gambar_produk_utama);
      }
    }
  }

  void removeIcon(file) {
    // Find the index of the file to remove
    final int index = selectedIconPaths.indexOf(file);

    if (index != -1) {
      // Remove from both lists simultaneously
      selectedIconPaths.removeAt(index);
      image64List.removeAt(index);
      if (image64List.isEmpty) {
        print('image list empery-------------------->');
        data.gambar_produk_utama = null;
        print('gambar thumb-------------------->');
        print(data.gambar_produk_utama);
      }
    }
  }

  var pajakdisplay = false.obs;
  var ukurandisplay = false.obs;
  var dimensi = false.obs;
  deletegambar({uuid}) async {
    Get.dialog(const showloading(), barrierDismissible: false);
    var delete = await DBHelper().DELETE(table: 'gambar_produk', id: uuid);

    if (delete == 1) {
      // Remove duplicate fetch call
      await fetchgambar(id_toko: id_toko, id_produk: data.uuid);

      // Manually remove deleted item from the list
      final index = gambarlist.indexWhere((g) => g.uuid == uuid);
      if (index != -1) {
        gambarlist.removeAt(index);
      }

      if (gambarlist.isEmpty) {
        data.gambar_produk_utama = '';
      }

      Get.back();
      Get.showSnackbar(
          toast().bottom_snackbar_success('Sukses', 'berhasil dihapus'));
    } else {
      Get.back();
      Get.showSnackbar(toast().bottom_snackbar_error('Error', 'gagal'));
    }
  }

  editProduklocal() async {
    print('-------------------edit  produk local---------------------');

    Get.dialog(const showloading(), barrierDismissible: false);

    for (String image64 in image64List.value) {
      var uuid = Uuid().v4();

      gambartemp.add(DataGambarProduk(
        uuid: uuid, // Unique UUID per image
        id_toko: id_toko,
        aktif: 1,
        gambar: image64,
        id_produk: data.uuid,
      ));
      await DBHelper().INSERT(
        'gambar_produk',
        DataGambarProduk(
          uuid: uuid,
          id_toko: id_toko,
          id_produk: data.uuid,
          gambar: image64,
          aktif: 1,
        ).DB(),
      );
    }

    var produk = await DBHelper().UPDATE(
        id: data.uuid,
        table: 'produk',
        data: dataeditproduk(
          id_kelompok_produk: kategorivalue,
          id_sub_kelompok_produk: subKategorivalue,
          gambar_produk_utama: image64List.isEmpty
              ? data.gambar_produk_utama
              : image64List.first,
          kode_produk: kodeProduk.value.text,
          nama_produk: namaProduk.value.text,
          serial_key: serialKey.value.text,
          imei: imei.value.text,
          hitung_stok: hitungStok.value == true ? 1 : 0,
          stock_awal: int.parse(stockAwal.value.text),
          info_stok_habis: int.parse(minimumStock.value.text),
          tampilkan_di_produk: tampilkanDiProduk.value == true ? 1 : 0,
          harga_beli: double.parse(hargaBeli.value.text.replaceAll(',', '')),
          hpp: double.parse(hpp.value.text.replaceAll(',', '')),
          harga_jual_grosir:
              double.parse(hargaJualGrosir.value.text.replaceAll(',', '')),
          harga_jual_eceran:
              double.parse(hargaJualEceran.value.text.replaceAll(',', '')),
          harga_jual_pelanggan:
              double.parse(hargaJualPelanggan.value.text.replaceAll(',', '')),
          pajak: pajakdisplay.value == true ? pajakValue : null,
          jenis_produk: jenisvalue,
          ukuran: ukurandisplay.value == true ? ukuranValue : null,
          berat: double.parse(berat.value.text.replaceAll(',', '')),
          volume_panjang:
              double.parse(volumePanjang.value.text.replaceAll(',', '')),
          volume_lebar:
              double.parse(volumeLebar.value.text.replaceAll(',', '')),
          volume_tinggi:
              double.parse(volumeTinggi.value.text.replaceAll(',', '')),
          id_gambar:
              image64List.isEmpty ? data.gambar_produk_utama : gambartemp.first,
          diskon: selecteddiskon.value == 'Rp.'
              ? diskonvalue.value
              : (double.parse(hargaJualEceran.value.text.replaceAll(',', '')) *
                  diskonvalue.value /
                  100),
        ));
    if (produk == 1) {
      print('update HPP stock ---->');
      await DBHelper().UPDATEQTY(
          table: 'stock_produk',
          id: data.uuid!,
          data: dataeditstockHPP(
              HPP: double.parse(hpp.value.text.replaceAll(',', ''))));
      if (hitungStok.value == true) {
        print('update stock ---->');
        await DBHelper().incrementQty(
            table: 'stock_produk',
            id_produk: data.uuid!,
            increment: int.parse(stockAwal.value.text));
      } else {
        await DBHelper().UPDATEQTY(
            table: 'stock_produk',
            id: data.uuid!,
            data: dataeditstock(stockawal: 0));
      }
      await Get.find<CentralProdukController>()
          .fetchProdukLocal(id_toko: id_toko);
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

  var selecteddiskon = ''.obs;
  var diskonnominal = 0.0.obs;
  var diskonvalue = 0.0.obs;
  var diskonpersen = 0.0.obs;
  var diskon = TextEditingController().obs;
  var opsidiskon = ['Rp.', '%'].obs;
  var showdiskon = false.obs;

  tambahProdukLocalv2() async {
    print('-------------------tambah produk local---------------------');

    Get.dialog(showloading(), barrierDismissible: false);
    //var uuid_produk = Uuid().v4();
    //var uuid_gambar = Uuid().v4();
    var uuid_hargajual = Uuid().v4();
    var uuid_satuanproduk = Uuid().v4();
    var uuid_pajak = Uuid().v4();
    var uuid_ukuran = Uuid().v4();

    var produkResult = await DBHelper().INSERT(
      'produk',
      DataProduk(
        id_toko: id_toko,
        uuid: produktemp.first.uuid, // Use the same UUID from addtempv2
        id_kelompok_produk: produktemp.first.id_kelompok_produk,
        id_sub_kelompok_produk: produktemp.first.id_sub_kelompok_produk,
        kode_produk: produktemp.first.kode_produk,
        nama_produk: produktemp.first.nama_produk,
        serial_key: produktemp.first.serial_key,
        imei: produktemp.first.imei,
        harga_beli: produktemp.first.harga_beli,
        hpp: produktemp.first.hpp,
      ).DB(),
    );

    if (produkResult != null) {
      for (String image64 in image64List.value) {
        // Generate a new UUID for each image
        String newUuid = const Uuid().v4(); // Requires the 'uuid' package
        gambartemp.add(DataGambarProduk(
          uuid: newUuid, // Unique UUID per image
          id_toko: id_toko,
          aktif: 1,
          gambar: image64,
          id_produk: produktemp.first.uuid,
        ));
        // Insert each image entry into the database
        var result = await DBHelper().INSERT(
          'gambar_produk',
          DataGambarProduk(
            uuid: newUuid, // Unique UUID per image
            id_toko: id_toko,
            aktif: 1,
            gambar: image64,
            id_produk: produktemp.first.uuid,
          ).DB(),
        );
        insertResults.add(result); // Store each insert result
      }

      // // Insert into harga_jual table
      // print('insert harga jual----------------------------------->');
      // hargajualtemp.add(DataHargaJualProduk(
      //   uuid: uuid_hargajual,
      //   id_produk: produktemp.first.uuid,
      //   id_toko: id_toko,
      //   aktif: 1,
      //   harga_jual: double.parse(hargaJualUtama.value.text),
      //   jenis_transaksi: jenistransaksi.value.text,
      //   // Add other fields as necessary
      // ));
      // print(hargajualtemp.first.harga_jual);
      // var hargajualdb = await DBHelper().INSERT(
      //   'harga_jual_produk',
      //   DataHargaJualProduk(
      //     uuid: uuid_hargajual,
      //     id_produk: produktemp.first.uuid,
      //     id_toko: id_toko,
      //     aktif: 1,
      //     harga_jual: double.parse(hargaJualUtama.value.text),
      //     jenis_transaksi: jenistransaksi.value.text,
      //     // Add other fields as necessary
      //   ).DB(),
      // );

      // Insert into satuan table
      // print('insert satuan produk----------------------------------->');
      // print('uuid satuan produk');
      //
      // satuantemp.add(DataSatuanProduk(
      //     uuid: uuid_satuanproduk,
      //     aktif: 1,
      //     id_toko: id_toko,
      //     id_produk: produktemp.first.uuid,
      //     harga_per_satuan: double.parse(hargaPerSatuan.value.text),
      //     isi_per_satuan: double.parse(isiDalamSatuan.value.text),
      //     nama_satuan: satuanUtama.value.text
      //     // Add other fields as necessary
      //     ));
      //
      // print(satuantemp.first.harga_per_satuan);
      //
      // var satuandb = await DBHelper().INSERT(
      //   'satuan_produk',
      //   DataSatuanProduk(
      //           uuid: uuid_satuanproduk,
      //           aktif: 1,
      //           id_toko: id_toko,
      //           id_produk: produktemp.first.uuid,
      //           harga_per_satuan: double.parse(hargaPerSatuan.value.text),
      //           isi_per_satuan: double.parse(isiDalamSatuan.value.text),
      //           nama_satuan: satuanUtama.value.text
      //           // Add other fields as necessary
      //           )
      //       .DB(),
      // );

      // Insert into pajak table
      // print('insert pajak ----------------------------------->');
      // pajaktemp.add(DataPajakProduk(
      //     uuid: uuid_pajak,
      //     id_produk: produktemp.first.uuid,
      //     id_toko: id_toko,
      //     aktif: 1,
      //     nama_pajak: pajak.value.text,
      //     nominal_pajak: double.parse(nominalPajak.value.text)
      //     // Add other fields as necessary
      //     ));

      // print(pajaktemp.first.nama_pajak);
      // var pajakdb = await DBHelper().INSERT(
      //   'pajak_produk',
      //   DataPajakProduk(
      //           uuid: uuid_pajak,
      //           id_produk: produktemp.first.uuid,
      //           id_toko: id_toko,
      //           aktif: 1,
      //           nama_pajak: pajak.value.text,
      //           nominal_pajak: double.parse(nominalPajak.value.text)
      //           // Add other fields as necessary
      //           )
      //       .DB(),
      // );

      // Insert into ukuran table
      // print('insert ukuran----------------------------------->');
      // ukurantemp.add(DataUkuranProduk(
      //   uuid: uuid_ukuran,
      //   aktif: 1,
      //   id_toko: id_toko,
      //   id_produk: produktemp.first.uuid,
      //   ukuran: ukuran.value.text,
      //   // Add other fields as necessary
      // ));
      // print(ukurantemp.first.ukuran);
      // var ukurandb = await DBHelper().INSERT(
      //   'ukuran_produk',
      //   DataUkuranProduk(
      //     uuid: uuid_ukuran,
      //     aktif: 1,
      //     id_toko: id_toko,
      //     id_produk: produktemp.first.uuid,
      //     ukuran: ukuran.value.text,
      //     // Add other fields as necessary
      //   ).DB(),
      // );

      if (insertResults.isNotEmpty &&
          insertResults.every((result) => result != null)) {
        await Get.find<BaseMenuProdukController>()
            .fetchProdukLocal(id_toko: id_toko);
        Get.back(closeOverlays: true);
        Get.back();
        Get.showSnackbar(toast().bottom_snackbar_success('Sukses', 'Berhasil'));
      } else {
        Get.back(closeOverlays: true);
        //Get.back();
        Get.showSnackbar(toast().bottom_snackbar_error('error', 'gagal'));
      }
    } else {
      Get.back(closeOverlays: true);
      //Get.back();
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
      await fetchukuran(id_toko: id_toko);
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

    List<Map<String, Object?>> query = await DBHelper()
        .FETCH('SELECT * FROM Kelompok_produk WHERE id_toko = "$id_toko"');
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

  fetchSubKategoriProdukLocal({id_toko, kategori}) async {
    print('-------------------fetch pelanggan local---------------------');

    List<Map<String, Object?>> query = await DBHelper().FETCH(
        'SELECT * FROM Sub_Kelompok_produk WHERE id_toko = "$id_toko" AND ID_Kelompok_Produk = "$kategori"');
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
}
