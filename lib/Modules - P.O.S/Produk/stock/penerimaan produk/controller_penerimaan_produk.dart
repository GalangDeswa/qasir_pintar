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
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qasir_pintar/Config/config.dart';
import 'package:qasir_pintar/Controllers/CentralController.dart';
import 'package:qasir_pintar/Modules - P.O.S/Kasir/controller_kasir.dart';
import 'package:qasir_pintar/Modules - P.O.S/Produk/stock/controller_basemenustock.dart';
import 'package:qasir_pintar/Modules - P.O.S/Produk/stock/model_penerimaan.dart';
import 'package:smooth_sheets/smooth_sheets.dart';
import 'package:uuid/uuid.dart';

import '../../../../Database/DB_helper.dart';
import '../../../../Widget/widget.dart';
import '../../../Pelanggan/List Pelanggan/controller_pelanggan.dart';
import '../../../Pelanggan/List Pelanggan/model_pelanggan.dart';
import '../../../Pelanggan/List kategori pelanggan/model_kategoriPelanggan.dart';
import '../../../Supplier/model_supplier.dart';
import '../../Data produk/model_produk.dart';
import '../../controller_basemenuproduk.dart';

class PenerimaanProdukController extends GetxController {
  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    await Get.find<CentralSupplierController>()
        .fetchSupplierLocal(id_toko: id_toko);
    await Get.find<CentralProdukController>()
        .fetchProdukLocal(id_toko: id_toko);
  }

  List<dynamic> insertResults = []; // Track insertion results
  var harga_modal = 0.0.obs;
  var harga_hpp = 0.0.obs;
  var produktemp = <DataProdukTemp>[].obs;
  var hargaModal = TextEditingController().obs;
  RxList<String> deletedDetailIds = <String>[].obs;
  var hpp = TextEditingController().obs;
  final searchController = TextEditingController();
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
    Get.dialog(SheetViewport(
        child: Sheet(
      scrollConfiguration: SheetScrollConfiguration(),
      initialOffset: const SheetOffset(0.5),
      physics: BouncingSheetPhysics(),
      snapGrid: MultiSnapGrid(snaps: [SheetOffset(0.5), SheetOffset(1)]),
      child: Material(
        color: Colors.white,
        child: Obx(() {
          return Container(
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
                    decoration: InputDecoration(hintText: 'pencarian'),
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
                                      final existingIndex =
                                          produktemp.indexWhere((item) =>
                                              item.uuid ==
                                              customer[index].uuid);
                                      //produktemp.refresh();
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
                                        ));

                                        produktemp.refresh();
                                      } else {
                                        produktemp[existingIndex].qty++;
                                        produktemp.refresh();
                                      }
                                      harga_modal.value +=
                                          customer[index].harga_beli!;
                                      harga_hpp.value += customer[index].hpp!;
                                      totalharga.value.text = AppFormat()
                                          .numFormat(harga_modal.value);
                                      hpp.value.text = AppFormat()
                                          .numFormat(harga_hpp.value);
                                      cariTotalBayar();
                                      print(totalharga.value.text);
                                      print('sum harga modal --->' +
                                          harga_modal.value.toString());
                                      print('sum harga hpp --->' +
                                          harga_hpp.value.toString());

                                      // Calculate sum of quantities
                                      var sumqty = produktemp.fold(0,
                                          (sum, item) => sum + (item.qty ?? 0));
                                      var sumharga = produktemp.fold(
                                          0.0,
                                          (sum, item) =>
                                              sum + (item.harga_beli ?? 0));
                                      jumlahqty.value.text = sumqty.toString();
                                      // totalharga.value.text =
                                      //     sumharga.toString();
                                      // cariTotalBayar();
                                      print('Total Qty: $sumqty');
                                    },
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: ListTile(
                                                  // leading: ClipOval(
                                                  //   child: customer[index]
                                                  //                   .gambar_produk_utama !=
                                                  //               '' &&
                                                  //           customer[index]
                                                  //                   .gambar_produk_utama !=
                                                  //               null
                                                  //       ? isBase64Svg(customer[
                                                  //                   index]
                                                  //               .gambar_produk_utama!)
                                                  //           ? SvgPicture.memory(
                                                  //               base64Decode(customer[
                                                  //                       index]
                                                  //                   .gambar_produk_utama!),
                                                  //               width: 30,
                                                  //               height: 40,
                                                  //               fit: BoxFit
                                                  //                   .cover,
                                                  //             )
                                                  //           : Image.memory(
                                                  //               base64Decode(customer[
                                                  //                       index]
                                                  //                   .gambar_produk_utama!),
                                                  //               width: 30,
                                                  //               height: 40,
                                                  //               fit: BoxFit
                                                  //                   .cover,
                                                  //             )
                                                  //       : Image.asset(
                                                  //           AppString
                                                  //               .defaultImg,
                                                  //           width: 30,
                                                  //           height: 40,
                                                  //           fit: BoxFit.cover,
                                                  //         ),
                                                  // ),
                                                  title: Text(
                                                    customer[index]
                                                            .nama_produk ??
                                                        'default nama',
                                                    style: AppFont.regular(),
                                                  ),
                                                  subtitle: Text(
                                                    'Rp. ' +
                                                        AppFormat().numFormat(
                                                            customer[index]
                                                                .harga_beli),
                                                    style: AppFont.small(),
                                                  )),
                                            ),
                                            button_solid_custom(
                                                onPressed: () {
                                                  popaddqty(customer[index]);
                                                },
                                                child: Text(
                                                  '+ kelipatan',
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

  popAddSupplier() {
    Get.put(CentralSupplierController());

    Get.dialog(SheetViewport(
        child: Sheet(
      scrollConfiguration: SheetScrollConfiguration(),
      initialOffset: const SheetOffset(0.5),
      physics: BouncingSheetPhysics(),
      snapGrid: MultiSnapGrid(snaps: [SheetOffset(0.5), SheetOffset(1)]),
      child: Material(
          color: Colors.white,
          child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
              padding: AppPading.defaultBodyPadding(),
              height: Get.height,
              child: TambahSupplierPenerimaan())),
    )));
  }

  var customqty = TextEditingController().obs;

  popaddqty(DataProduk data) {
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
              child: Column(children: [
                Expanded(child: Text('jumlah')),
                Expanded(
                  child: TextField(
                    controller: customqty.value,
                    decoration:
                        InputDecoration(hintText: 'Masukan jumlah produk'),
                  ),
                ),
                Expanded(
                  child: button_solid_custom(
                      onPressed: () {
                        final existingIndex = produktemp
                            .indexWhere((item) => item.uuid == data.uuid);
                        final qty = int.parse(customqty.value.text);
                        //produktemp.refresh();
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
                          produktemp[existingIndex].qty += qty;
                          produktemp.refresh();
                        }
                        harga_modal.value += data.harga_beli! * qty;
                        harga_hpp.value += data.hpp! * qty;
                        totalharga.value.text = harga_modal.value.toString();
                        hpp.value.text = harga_hpp.value.toString();
                        print('sum harga modal --->' +
                            harga_modal.value.toString());
                        print(
                            'sum harga hpp --->' + harga_hpp.value.toString());

                        // Calculate total quantities
                        var sumqty = produktemp.fold(
                            0, (sum, item) => sum + (item.qty ?? 0));

                        // check pengecekan harga dan belum dikali qty
                        var sumharga = produktemp.fold(0.0,
                            (sum, item) => sum + (item.harga_jual_eceran ?? 0));
                        jumlahqty.value.text = sumqty.toString();
                        //totalharga.value.text = sumharga.toString();
                        cariTotalBayar();
                        print('Total Quantity: $sumqty');
                        //cariTotalBayar();

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

  var nama = TextEditingController().obs;
  var nomorfaktur = TextEditingController().obs;
  var email = TextEditingController().obs;
  var jumlahqty = TextEditingController().obs;
  var totalharga = TextEditingController().obs;
  var ongkir = TextEditingController().obs;
  var totalbayar = TextEditingController().obs;
  var jumlahbayar = TextEditingController().obs;
  var sisabayar = TextEditingController().obs;
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
  String? jenispenerimaanvalue;
  var jenispenerimaan = ['Lunas', 'Hutang'].obs;

  var kategoripelangganList = <DataKategoriPelanggan>[].obs;
  var kategorivalue;

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

  tambahPelangganLocal() async {
    print('-------------------tambah pelanggan local---------------------');

    Get.dialog(showloading(), barrierDismissible: false);
    var uuid = Uuid().v4();
    var db = await DBHelper().INSERT(
        'pelanggan',
        DataPelanggan(
          uuid: uuid,
          idToko: id_toko,
          email: email.value.text,
          alamat: alamat.value.text,
          namaPelanggan: nama.value.text,
          noHp: telepon.value.text,
          tglLahir: tanggal.value.text,
          foto: image64,
          statusPelanggan: 1,
          idKategori: kategorivalue,
        ).DB());

    if (db != null) {
      await Get.find<PelangganController>()
          .fetchPelangganLocal(id_toko: id_toko);
      Get.back(closeOverlays: true);
      Get.showSnackbar(
          toast().bottom_snackbar_success('Sukses', 'Berhasil registrasi'));
    } else {
      Get.back();
      Get.showSnackbar(toast().bottom_snackbar_error('error', 'gagal'));
    }
  }

  var supplierList = <DataSupplier>[].obs;
  var suppliervalue = ''.obs;
  fetchSupplierLocal({id_toko}) async {
    print('-------------------fetch supplier local---------------------');

    List<Map<String, Object?>> query = await DBHelper()
        .FETCH('SELECT * FROM Supplier WHERE id_toko = "$id_toko"');
    if (query.isNotEmpty) {
      List<DataSupplier> data =
          query.map((e) => DataSupplier.fromJsondb(e)).toList();
      supplierList.value = data;
      //logo.value = userList.value.first.logo!;
      return data;
    } else {
      print('empty');
      return null;
    }
  }

  var produk = <DataProduk>[].obs;
  fetchProdukLocal({id_toko, bool ascending = true}) async {
    print('-------------------fetch produk local---------------------');

    String orderBy = ascending ? 'ASC' : 'DESC'; // Determine order
    List<Map<String, Object?>> query = await DBHelper().FETCH('''
  SELECT 
      produk.*, 
      kelompok_produk.Nama_Kelompok AS nama_kategori,
      Sub_kelompok_produk.Nama_Sub_Kelompok AS nama_subkategori,
      pajak_produk.nama_pajak AS nama_pajak,
      pajak_produk.nominal_pajak AS nominal_pajak,
      stock_produk.stok AS qty,
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
  LEFT JOIN 
     stock_produk ON produk.uuid = stock_produk.id_produk
  WHERE 
      produk.id_toko = "$id_toko"
  ORDER BY produk.nama_produk $orderBy
  ''');
    if (query.isNotEmpty) {
      List<DataProduk> data =
          query.map((e) => DataProduk.fromJsondb(e)).toList();
      produk.value = data;
      print('qty---------->');
      print(data[0].qty);
      return data;
    } else {
      print('empty');
      return null;
    }
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

  String generateInvoiceNumber() {
    final now = DateTime.now();
    final currentDate = DateFormat('yyyyMMdd').format(now);

    // Get last stored date and sequence
    final lastDate = GetStorage().read('lastInvoiceDate');
    int sequence = GetStorage().read('invoiceSequence') ?? 1;

    // Reset sequence if it's a new day
    if (lastDate != currentDate) {
      sequence = 1;
    } else {
      sequence++;
    }

    // Store new values
    GetStorage().write('lastInvoiceDate', currentDate);
    GetStorage().write('invoiceSequence', sequence);

    // Format sequence with leading zeros
    final sequenceFormatted = sequence.toString().padLeft(4, '0');

    return 'INV$currentDate-$sequenceFormatted';
  }

  String getTodayDateISO() {
    // Get the current date
    DateTime now = DateTime.now();

    // Format the date as "YYYY-MM-DD"
    String formattedDate =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    return formattedDate;
  }

  cariTotalBayar() {
    var x = double.parse(totalharga.value.text.replaceAll(',', ''));
    if (ongkir.value.text == '') {
      ongkir.value.text = '0.0';
    }
    var y = double.parse(ongkir.value.text.replaceAll(',', ''));
    var z = x + y;
    totalbayar.value.text = AppFormat().numFormat(z);

    // return AppFormat().numFormat(double.parse(totalbayar.value.text));
  }

  //TODO : FILTER TGL

  cariSisaBayar() {
    if (jenispenerimaanvalue == 'LUNAS') {
      sisabayar.value.text = '0';
      return;
    }
    var x = double.parse(totalbayar.value.text.replaceAll(',', ''));
    var y = double.parse(jumlahbayar.value.text.replaceAll(',', ''));
    var z = x - y;
    return sisabayar.value.text = AppFormat().numFormat(z);
  }

  Map<String, dynamic> dataeditqty({qty}) {
    var map = <String, dynamic>{};

    map['stok'] = qty;
    return map;
  }

  tambahPenerimaanProduk() async {
    print('-------------------tambah paket produk local---------------------');

    Get.dialog(showloading(), barrierDismissible: false);
    //var uuid_produk = Uuid().v4();
    //var uuid_gambar = Uuid().v4();
    var uuidpenerimaan = Uuid().v4();

    var uuid_pajak = Uuid().v4();
    var uuid_ukuran = Uuid().v4();

    var paket = await DBHelper().INSERT(
      'penerimaan_produk',
      DataPenerimaanProduk(
              uuid: uuidpenerimaan,
              idToko: id_toko,
              idSupplier: suppliervalue.value,
              jenisPenerimaan: jenispenerimaanvalue,
              nomorFaktur: nomorfaktur.value.text,
              jumlahQty: int.parse(jumlahqty.value.text),
              totalHarga:
                  double.parse(totalharga.value.text.replaceAll(',', '')),
              ongkosKirim: double.parse(ongkir.value.text.replaceAll(',', '')),
              totalBayar:
                  double.parse(totalbayar.value.text.replaceAll(',', '')),
              jumlahBayar:
                  double.parse(jumlahbayar.value.text.replaceAll(',', '')),
              sisaBayar: double.parse(sisabayar.value.text.replaceAll(',', '')),
              tanggal: getTodayDateISO(),
              idLogin: id_toko)
          .DB(),
    );

    if (paket != null) {
      for (DataProdukTemp produk in produktemp) {
        var uuuidDetauilpenerimaan = Uuid().v4();
        var detail = await DBHelper().INSERT(
            'detail_penerimaan_produk',
            DataDetailPenerimaanProduk(
              uuid: uuuidDetauilpenerimaan,
              qty: produk.qty,
              idPenerimaan: uuidpenerimaan,
              idProduk: produk.uuid,
              idToko: id_toko,
              subtotal: produk.harga_jual_eceran! * produk.qty,
            ).DB());
        print('update stock ---->' +
            produk.nama_produk! +
            ' ' +
            produk.qty.toString());
        await DBHelper().incrementQty(
            table: 'stock_produk',
            id_produk: produk.uuid!,
            increment: produk.qty);
      }

      await Get.find<BasemenuStockController>()
          .fetchPenerimaanLocal(id_toko: id_toko);
      await Get.find<CentralProdukController>()
          .fetchProdukLocal(id_toko: id_toko);

      Get.back(closeOverlays: true);
      Get.showSnackbar(toast().bottom_snackbar_success('Sukses', 'Berhasil'));
    } else {
      Get.back();
      Get.showSnackbar(toast().bottom_snackbar_error('error', 'gagal'));
    }
  }
}

class TambahSupplierPenerimaan extends GetView<CentralSupplierController> {
  const TambahSupplierPenerimaan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCustom(
        title: 'Tambah Supplier',
        NeedBottom: false,
      ),
      body: Padding(
        padding: AppPading.defaultBodyPadding(),
        child: SingleChildScrollView(
          child: Form(
            key: controller.registerKey(),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: AppPading.customBottomPadding(),
                    child: button_border_custom(
                        onPressed: () async {
                          if (await controller.checkContactPermission()) {
                            controller.selectContact();
                          } else {
                            Get.snackbar(
                              'Izin Diperlukan',
                              'Silakan berikan izin akses kontak terlebih dahulu',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          }
                        },
                        child: Text('Tambah dari kontak'),
                        width: context.res_width),
                  ),
                  Obx(() {
                    return Padding(
                      padding: AppPading.customBottomPadding(),
                      child: TextFormField(
                        controller: controller.nama.value,
                        decoration: InputDecoration(
                          labelText: 'Nama Supllier',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Nama harus diisi';
                          }
                          return null;
                        },
                      ),
                    );
                  }),
                  Obx(() {
                    return Padding(
                      padding: AppPading.customBottomPadding(),
                      child: TextFormField(
                        controller: controller.telepon.value,
                        decoration: InputDecoration(
                          labelText: 'Nomor telepon',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Nomor telepon harus diisi';
                          }
                          return null;
                        },
                      ),
                    );
                  }),
                  Obx(() {
                    return Padding(
                      padding: AppPading.customBottomPadding(),
                      child: TextFormField(
                        controller: controller.alamat.value,
                        decoration: InputDecoration(
                          labelText: 'Alamat',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Alamat harus diisi';
                          }
                          return null;
                        },
                      ),
                    );
                  }),
                  button_solid_custom(
                      onPressed: () {
                        if (controller.registerKey.value.currentState!
                            .validate()) {
                          controller.tambahSupplierLocal();
                        }
                        //Get.toNamed('/setuptoko');
                        // Get.toNamed('/loginform');
                      },
                      child: Text(
                        'Tambah',
                        style: AppFont.regular_white_bold(),
                      ),
                      width: context.res_width)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
