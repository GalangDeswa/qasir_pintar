import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:meta/meta.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:qasir_pintar/Modules - P.O.S/Karyawan/model_karyawan.dart';
import 'package:smooth_sheets/smooth_sheets.dart';

import '../../Config/config.dart';
import '../../Database/DB_helper.dart';
import '../../Widget/popscreen.dart';
import '../../Widget/widget.dart';
import '../Produk/Data produk/model_produk.dart';
import '../Produk/Kategori/model_subkategoriproduk.dart';
import '../Produk/Produk/model_kategoriproduk.dart';
import '../Users/model_user.dart';

class KasirController extends GetxController {
  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    print('Kasir CON INIt--------------------------------->');
    uuid.value = await GetStorage().read('uuid');
    // await fetchKaryawanLocal(id_toko: id_toko);
    // await checkKaryawan();
    // cari cara karyawan login

    await checktour();
    await fetchUserLocal(uuid);
    await fetchKategoriProdukLocal(id_toko: id_toko);
    await fetchSubKategoriProdukLocal(id_toko: id_toko);
    await fetchProdukLocal(id_toko: id_toko);
  }

  var keranjang = <DataProdukTemp>[].obs;
  final formKey = GlobalKey<FormState>();
  final verifikasi_kode = TextEditingController().obs;
  var karyawanlist = <DataKaryawan>[].obs;
  var karyawanvalue;
  loginKaryawan(uuid, kode) async {
    print('-------------------login karyawan---------------------');

    List<Map<String, Object?>> query = await DBHelper().FETCH(
        'SELECT * FROM Karyawan WHERE id_toko = "$id_toko" AND uuid = "$uuid" AND Pin = "$kode"');
    if (query.isNotEmpty) {
      await GetStorage().write('karyawan_login', true);
      Get.back();
    } else {
      Get.showSnackbar(toast().bottom_snackbar_error('Error', 'Gagal login'));
    }
  }

  checkKaryawan() async {
    // if (karyawanlist.isEmpty) {
    //   Get.toNamed('/tambahkaryawan');
    // }
    var read = await GetStorage().read('karyawan_login');
    if (read == true) {
      print('Karyawan login');
    } else {
      print('Karyawan belum login');
      popLoginKaryawan();
    }
  }

  popLoginKaryawan() {
    Get.dialog(SheetViewport(
        child: Sheet(
      // scrollConfiguration: SheetScrollConfiguration(),
      initialOffset: const SheetOffset(1),
      physics: BouncingSheetPhysics(),
      snapGrid: MultiSnapGrid(snaps: [SheetOffset(0.6), SheetOffset(1)]),
      child: Material(
          color: Colors.white,
          child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
              padding: AppPading.defaultBodyPadding(),
              height: Get.height,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Padding(
                            //   padding: const EdgeInsets.only(bottom: 50),
                            //   child: Text(
                            //     'Toko Berkah',
                            //     style: TextStyle(
                            //         fontSize: 25, fontWeight: FontWeight.bold),
                            //   ),
                            // ),
                            Padding(
                              padding: AppPading.customBottomPadding(),
                              child: DropdownButtonFormField2(
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 20),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null) {
                                    return 'Pilih jenis usaha';
                                  }
                                  return null;
                                },
                                isExpanded: true,
                                dropdownStyleData: DropdownStyleData(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white)),
                                hint: Text('Pilih Karyawan',
                                    style: AppFont.regular()),
                                value: karyawanvalue,
                                items: karyawanlist.map((x) {
                                  return DropdownMenuItem(
                                    child: Text(x.nama_karyawan!),
                                    value: x.uuid,
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  karyawanvalue = val!.toString();
                                  print(karyawanvalue);
                                },
                              ),
                            ),
                            button_border_custom(
                                onPressed: () {},
                                child: Text('Tambah Karyawan'),
                                width: Get.width),
                            SizedBox(height: 100.0),
                          ],
                        ),
                        //Text('Masukan kode verifikasi'),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 15),
                          width: 350,
                          child: Form(
                            key: formKey,
                            child: Column(
                              children: [
                                PinCodeTextField(
                                  appContext: Get.context!,
                                  length: 6,
                                  obscureText: true,
                                  animationType: AnimationType.fade,
                                  pinTheme: PinTheme(
                                      shape: PinCodeFieldShape.circle,
                                      borderRadius: BorderRadius.circular(5),
                                      fieldHeight: 50,
                                      fieldWidth: 40,
                                      activeFillColor: Colors.white,
                                      inactiveColor: AppColor.primary),
                                  animationDuration:
                                      Duration(milliseconds: 300),
                                  //backgroundColor: Colors.blue.shade50,
                                  controller: verifikasi_kode.value,
                                  onCompleted: (v) {
                                    print("Completed");
                                  },
                                  onChanged: (value) {
                                    print('verifikasi code -->' + value);
                                    print(verifikasi_kode.value.text);
                                  },
                                  beforeTextPaste: (text) {
                                    print("Allowing to paste $text");
                                    //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                    //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                    return true;
                                  },
                                  // appContext: context,
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  width: 350,
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: AppColor.secondary),
                                    onPressed: () {
                                      loginKaryawan(karyawanvalue,
                                          verifikasi_kode.value.text);
                                    },
                                    child: Text('Masuk'),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                // RichText(
                                //     text: TextSpan(
                                //         text: 'Kode tidak terkirim? ',
                                //         style: TextStyle(color: Colors.black),
                                //         children: <TextSpan>[
                                //       TextSpan(
                                //           text: ' kirim ulang',
                                //           recognizer: TapGestureRecognizer()
                                //             ..onTap = () {
                                //               Get.offAndToNamed('/loginpin');
                                //             },
                                //           style: TextStyle(color: Colors.blue))
                                //     ])),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ))),
    )));
  }

  fetchKaryawanLocal({id_toko}) async {
    print('-------------------fetch supplier local---------------------');

    List<Map<String, Object?>> query = await DBHelper()
        .FETCH('SELECT * FROM Karyawan WHERE id_toko = "$id_toko"');
    if (query.isNotEmpty) {
      List<DataKaryawan> data =
          query.map((e) => DataKaryawan.fromJsondb(e)).toList();
      karyawanlist.value = data;
      //logo.value = userList.value.first.logo!;
      return data;
    } else {
      print('empty');
      return [];
    }
  }

  addKeranjang(DataProduk produkCahce) async {
    var check =
        produk.where((element) => element.uuid == produkCahce.uuid).first;
    print('add keranjang ===>' + produkCahce.nama_produk!);
    final existingIndex =
        keranjang.indexWhere((item) => item.uuid == produkCahce.uuid);

    if (check.qty == 0 &&
        check.tampilkan_di_produk == 1 &&
        check.hitung_stok == 1) {
      Get.showSnackbar(toast().bottom_snackbar_error(
          "Error", 'Stock sudah habis! harap isi stock terlebih dahulu'));
      return;
    }

    if (existingIndex == -1) {
      keranjang.add(DataProdukTemp(
        uuid: produkCahce.uuid,
        id_toko: id_toko,
        qty: 1,
        pajak: produkCahce.pajak,
        hpp: produkCahce.hpp,
        nominalpajak: produkCahce.nominalpajak,
        namaPajak: produkCahce.pajak,
        gambar_produk_utama: produkCahce.gambar_produk_utama,
        harga_jual_eceran: produkCahce.harga_jual_eceran,
        nama_produk: produkCahce.nama_produk,
      ));
      keranjang.refresh();
    } else {
      if (keranjang[existingIndex].qty >= check.qty! &&
          check.tampilkan_di_produk == 1 &&
          check.hitung_stok == 1) {
        Get.showSnackbar(
            toast().bottom_snackbar_error("Error", 'Stock tidak mencukupi'));

        return;
      }

      keranjang[existingIndex].qty++;
      keranjang.refresh();
    }
    totalitem.value = keranjang.fold(0, (sum, item) => sum + (item.qty ?? 0));
    subtotal.value = keranjang.fold(
        0.0, (sum, item) => sum + (item.harga_jual_eceran! * item.qty));
  }

  var totalitem = 0.obs;
  var subtotal = 0.0.obs;

  RxString username = ''.obs;
  RxString email = ''.obs;
  var token = ''.obs;
  var logo = ''.obs;
  var toko = ''.obs;
  var namatoko = GetStorage().read('user_business_name');

  List<String> produklist = ['kopi', 'milo', 'indomie', 'supermie', 'arabica'];

  String? jenisvalue;
  var jenislistlocal = [
    'Promo',
    'Kupon',
    "Point",
  ].obs;

  var tampilan = ''.obs;

  List<String> meja = [
    'meja 1',
    'meja 2',
    'meja 3',
    'meja 4',
    'meja 5',
  ].obs;

  checktour() async {
    var x = await GetStorage().read('tour');
    print(x);
    if (x == null) {
      await GetStorage().write('tour', true);
      Popscreen().toursplash();
    }
  }

  var uuid = ''.obs;
  //var uuid;

  var datauser = <DataUser>[].obs;

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
      datauser.value = data;
      print(datauser.value);
      return data;
    } else {
      print('empty');
      return null;
    }
  }

  var index = 0.obs;

  List<IconData> icons = [
// The underscore declares a variable as private in dart.
    FontAwesomeIcons.home,

    FontAwesomeIcons.cashRegister,
  ];

  searchProdukLocal({id_toko, search}) async {
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
      //logo.value = userList.value.first.logo!;
      return data;
    } else {
      print('empty');
      return null;
    }
  }

  var isAscending = true.obs;
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

  fetchPaketLocal({id_toko}) async {
    print('-------------------fetch produk local---------------------');

    List<Map<String, Object?>> query = await DBHelper().FETCH('''
  SELECT 
      paket_produk.*, 
      pajak_produk.nama_pajak AS nama_pajak,
      pajak_produk.nominal_pajak AS nominal_pajak
  FROM 
      paket_produk 
  LEFT JOIN 
     pajak_produk ON paket_produk.pajak = pajak_produk.uuid
  WHERE 
      paket_produk.id_toko = "$id_toko"
  
  ''');
    if (query.isNotEmpty) {
      List<DataPaketProduk> data =
          query.map((e) => DataPaketProduk.fromJsondb(e)).toList();
      paketproduk.value = data;
      return data;
    } else {
      print('empty');
      return null;
    }
  }

  var pajakValue;
  var pajakList = <DataPajakProduk>[].obs;

  var ukuranValue;
  var ukuranList = <DataUkuranProduk>[].obs;
  fetchPajakLocal({id_toko}) async {
    print('-------------------fetch produk local---------------------');

    List<Map<String, Object?>> query = await DBHelper()
        .FETCH('SELECT * FROM pajak_produk WHERE id_toko = "$id_toko"');
    if (query.isNotEmpty) {
      List<DataPajakProduk> data =
          query.map((e) => DataPajakProduk.fromJsondb(e)).toList();
      pajakList.value = data;
      //logo.value = userList.value.first.logo!;
      return data;
    } else {
      print('empty');
      return null;
    }
  }

  fetchUkuranLocal({id_toko}) async {
    print('-------------------fetch produk local---------------------');

    List<Map<String, Object?>> query = await DBHelper()
        .FETCH('SELECT * FROM ukuran_produk WHERE id_toko = "$id_toko"');
    if (query.isNotEmpty) {
      List<DataUkuranProduk> data =
          query.map((e) => DataUkuranProduk.fromJsondb(e)).toList();
      ukuranList.value = data;
      //logo.value = userList.value.first.logo!;
      return data;
    } else {
      print('empty');
      return null;
    }
  }

  fetchKategoriProdukLocal({id_toko}) async {
    print('-------------------fetch pelanggan local---------------------');

    List<Map<String, Object?>> query = await DBHelper()
        .FETCH('SELECT * FROM Kelompok_produk WHERE id_toko = "$id_toko"');
    if (query.isNotEmpty) {
      List<DataKategoriProduk> data =
          query.map((e) => DataKategoriProduk.fromJsondb(e)).toList();
      kategoriProduk.value = data;
      //logo.value = userList.value.first.logo!;
      return data;
    } else {
      print('empty');
      return null;
    }
  }

  fetchSubKategoriProdukLocal({id_toko}) async {
    print('-------------------fetch pelanggan local---------------------');

    List<Map<String, Object?>> query = await DBHelper().FETCH('''
    SELECT 
        Sub_Kelompok_produk.*, 
        kelompok_produk.Nama_Kelompok AS kategori_nama
    FROM 
        Sub_Kelompok_produk 
    LEFT JOIN 
       Kelompok_produk ON Sub_Kelompok_produk.ID_Kelompok_Produk = Kelompok_produk.uuid 
    WHERE 
         Sub_Kelompok_produk.id_toko = "$id_toko"
  ''');
    if (query.isNotEmpty) {
      List<DataSubKategoriProduk> data =
          query.map((e) => DataSubKategoriProduk.fromJsondb(e)).toList();
      subKategoriProduk.value = data;
      //logo.value = userList.value.first.logo!;
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

  var id_toko = GetStorage().read('uuid');
  var kategoriProduk = <DataKategoriProduk>[].obs;
  var produk = <DataProduk>[].obs;
  var subKategoriProduk = <DataSubKategoriProduk>[].obs;
  var search = TextEditingController().obs;
  var searchproduk = TextEditingController().obs;
  var subsearch = TextEditingController().obs;
  serachKategoriProdukLocal() async {
    List<Map<String, Object?>> query = await DBHelper().FETCH(
        'SELECT * FROM Kelompok_produk WHERE id_toko = "$id_toko" AND Nama_Kelompok LIKE "%${search.value.text}%" ');
    List<DataKategoriProduk> jenis = query.isNotEmpty
        ? query.map((e) => DataKategoriProduk.fromJsondb(e)).toList()
        : [];
    kategoriProduk.value = jenis;

    return jenis;
  }

  serachSubKategoriProdukLocal() async {
    List<Map<String, Object?>> query = await DBHelper().FETCH('''
   SELECT 
    Sub_Kelompok_produk.*, 
    Kelompok_produk.Nama_Kelompok AS kategori_nama
FROM 
    Sub_Kelompok_produk 
LEFT JOIN 
    Kelompok_produk ON Sub_Kelompok_produk.ID_Kelompok_Produk = Kelompok_produk.uuid 
WHERE 
    Sub_Kelompok_produk.id_toko = "$id_toko" 
    AND Sub_Kelompok_produk.Nama_Sub_Kelompok LIKE "%${subsearch.value.text}%"
  ''');
    List<DataSubKategoriProduk> jenis = query.isNotEmpty
        ? query.map((e) => DataSubKategoriProduk.fromJsondb(e)).toList()
        : [];
    subKategoriProduk.value = jenis;

    return jenis;
  }

  var thumb = false.obs;
  var paketproduk = <DataPaketProduk>[].obs;
}
