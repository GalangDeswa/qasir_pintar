import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:lottie/lottie.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:qasir_pintar/Config/config.dart';
import 'package:qasir_pintar/Modules - P.O.S/Karyawan/controller_karyawan.dart';
import 'package:qasir_pintar/Modules - P.O.S/Karyawan/model_karyawan.dart';
import 'package:qasir_pintar/Modules - P.O.S/Pelanggan/List%20kategori%20pelanggan/controller_kategoripelanggan.dart';
import 'package:qasir_pintar/Modules - P.O.S/Pelanggan/List%20kategori%20pelanggan/model_kategoriPelanggan.dart';
import 'package:qasir_pintar/Modules - P.O.S/Produk/Data%20produk/model_produk.dart';
import 'package:qasir_pintar/Modules - P.O.S/Produk/Kategori/model_subkategoriproduk.dart';
import 'package:qasir_pintar/Modules - P.O.S/Produk/Produk/model_kategoriproduk.dart';
import 'package:qasir_pintar/Modules - P.O.S/Produk/controller_basemenuproduk.dart';
import 'package:qasir_pintar/Modules - P.O.S/Supplier/controller_supplier.dart';
import 'package:qasir_pintar/Modules - P.O.S/Supplier/model_supplier.dart';
import 'package:qasir_pintar/Widget/widget.dart';

import '../Modules - P.O.S/Kasir - Pembayaran/controller_pembayaran.dart';
import '../Modules - P.O.S/Kasir/controller_kasir.dart';
import '../Modules - P.O.S/Pelanggan/Edit kategori pelanggan/controller_editkategoripelanggan.dart';
import '../Modules - P.O.S/Pelanggan/List Pelanggan/controller_pelanggan.dart';
import '../Modules - P.O.S/Pelanggan/List Pelanggan/model_pelanggan.dart';
import '../Modules - P.O.S/Promo/controller_promo.dart';
import '../Modules - P.O.S/Promo/model_promo.dart';

// class heroPop extends StatelessWidget {
//   const heroPop({super.key, required this.tag, required this.image});
//   final String tag;
//   final String image;
//   @override
//   Widget build(BuildContext context) {
//     return
//   }
// }

heroPop({required String tag, required String image, required String type}) {
  Get.dialog(Center(
    child: type == 'memory'
        ? Hero(
            tag: tag,
            child: Image.memory(
              base64Decode(image),
              fit: BoxFit.contain,
            ),
          )
        : type == 'asset'
            ? Hero(
                tag: tag,
                child: Image.asset(
                  AppString.defaultImg,
                  fit: BoxFit.contain,
                ),
              )
            : Hero(
                tag: tag,
                child: SvgPicture.memory(
                  base64Decode(image),
                  fit: BoxFit.contain,
                ),
              ),
  ));
}

class header extends StatelessWidget {
  const header(
      {Key? key,
      this.base_color,
      this.title,
      this.icon,
      this.function,
      this.icon_color,
      this.icon_funtion,
      this.iscenter})
      : super(key: key);
  final Color? base_color, icon_color;
  final String? title;
  final IconData? icon, icon_funtion;
  final bool? iscenter;

  //final IconButton? button;
  final Function()? function;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: base_color == null ? Colors.white : base_color,
            borderRadius: BorderRadius.all(Radius.circular(15)),
            border: Border.all(color: AppColor.primary)),
        child: iscenter == false
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: AppColor.primary,
                              borderRadius: BorderRadius.circular(10)),
                          child: FaIcon(
                            icon!,
                            size: 20,
                            color:
                                icon_color == null ? Colors.white : icon_color,
                          )),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        title!.toUpperCase(),
                        style: AppFont.bold(),
                      ),
                    ],
                  ),
                  function == null
                      ? Container()
                      : Container(
                          decoration: BoxDecoration(
                              color: AppColor.primary, shape: BoxShape.circle),
                          child: IconButton(
                              color: Colors.white,
                              onPressed: () {
                                function!();
                              },
                              icon: Icon(icon_funtion)),
                        )

                  // button_solid_custom(
                  //     onPressed: () {
                  //       Get.toNamed('/tambah_produk');
                  //     },
                  //     child: Text(
                  //       'tambah produk',
                  //       style: font().header,
                  //     ),
                  //     width: context.width_query * 0.2,
                  //     height: 55)
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: FaIcon(
                        icon!,
                        size: 20,
                        color:
                            icon_color == null ? AppColor.primary : icon_color,
                      )),
                  Text(title!, style: AppFont.regular_bold()),
                  function == null
                      ? Container()
                      : Container(
                          decoration: BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                          child: IconButton(
                              color: AppColor.primary,
                              onPressed: () {
                                function!();
                              },
                              icon: Icon(icon_funtion)),
                        )

                  // button_solid_custom(
                  //     onPressed: () {
                  //       Get.toNamed('/tambah_produk');
                  //     },
                  //     child: Text(
                  //       'tambah produk',
                  //       style: font().header,
                  //     ),
                  //     width: context.width_query * 0.2,
                  //     height: 55)
                ],
              ));
  }
}

class Popscreen {
  deletePromo(PromoController controller, DataPromo arg) {
    Get.dialog(AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      title: header(
        title: 'Hapus Promo',
        icon: Icons.warning,
        icon_color: AppColor.warning,
      ),
      contentPadding: EdgeInsets.all(10),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12.0),
        ),
      ),
      content: Builder(
        builder: (context) {
          return Container(
              margin: EdgeInsets.all(10),
              width: context.res_width / 2.6,
              height: context.res_height / 4.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Hapus " + arg.namaPromo! + '?',
                    style: AppFont.regular_bold(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  button_solid_custom(
                    onPressed: () async {
                      //Get.back();
                      await controller.deletePromo(uuid: arg.uuid);
                    },
                    child: Text(
                      'Hapus',
                      style: AppFont.regular_white_bold(),
                    ),
                    width: context.res_width,
                  ),
                  button_border_custom(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text(
                      'Batal',
                      style: AppFont.regular(),
                    ),
                    width: context.res_width,
                  )
                ],
              ));
        },
      ),
    ));
  }

  deletePaketProduk(BaseMenuProdukController controller, DataPaketProduk arg) {
    Get.dialog(AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      title: header(
        title: 'Hapus Paket',
        icon: Icons.warning,
        icon_color: AppColor.warning,
      ),
      contentPadding: EdgeInsets.all(10),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12.0),
        ),
      ),
      content: Builder(
        builder: (context) {
          return Container(
              margin: EdgeInsets.all(10),
              width: context.res_width / 2.6,
              height: context.res_height / 4.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Hapus " + arg.nama_paket! + '?',
                    style: AppFont.regular_bold(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  button_solid_custom(
                    onPressed: () async {
                      //Get.back();
                      await controller.deletepaket(uuid: arg.uuid);
                    },
                    child: Text(
                      'Hapus',
                      style: AppFont.regular_white_bold(),
                    ),
                    width: context.res_width,
                  ),
                  button_border_custom(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text(
                      'Batal',
                      style: AppFont.regular(),
                    ),
                    width: context.res_width,
                  )
                ],
              ));
        },
      ),
    ));
  }

  deleteKaryawan(KaryawanController controller, DataKaryawan arg) {
    Get.dialog(AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      title: header(
        title: 'Hapus Karyawan',
        icon: Icons.warning,
        icon_color: AppColor.warning,
      ),
      contentPadding: EdgeInsets.all(10),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12.0),
        ),
      ),
      content: Builder(
        builder: (context) {
          return Container(
              margin: EdgeInsets.all(10),
              width: context.res_width / 2.6,
              height: context.res_height / 4.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Hapus " + arg.nama_karyawan! + '?',
                    style: AppFont.regular_bold(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  button_solid_custom(
                    onPressed: () async {
                      //Get.back();
                      await controller.deleteKaryawan(uuid: arg.uuid);

                      //controller.deleteproduk(arg.id.toString());
                    },
                    child: Text(
                      'Hapus',
                      style: AppFont.regular_white_bold(),
                    ),
                    width: context.res_width,
                  ),
                  button_border_custom(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text(
                      'Batal',
                      style: AppFont.regular(),
                    ),
                    width: context.res_width,
                  )
                ],
              ));
        },
      ),
    ));
  }

  deleteKategoriProduk(
      BaseMenuProdukController controller, DataKategoriProduk arg) {
    Get.dialog(AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      title: header(
        title: 'Hapus Kategori produk',
        icon: Icons.warning,
        icon_color: AppColor.warning,
      ),
      contentPadding: EdgeInsets.all(10),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12.0),
        ),
      ),
      content: Builder(
        builder: (context) {
          return Container(
              margin: EdgeInsets.all(10),
              width: context.res_width / 2.6,
              height: context.res_height / 4.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Hapus " + arg.namakelompok! + '?',
                    style: AppFont.regular_bold(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  button_solid_custom(
                    onPressed: () async {
                      //Get.back();
                      await controller.deleteKategoriProduk(uuid: arg.uuid);

                      //controller.deleteproduk(arg.id.toString());
                    },
                    child: Text(
                      'Hapus',
                      style: AppFont.regular_white_bold(),
                    ),
                    width: context.res_width,
                  ),
                  button_border_custom(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text(
                      'Batal',
                      style: AppFont.regular(),
                    ),
                    width: context.res_width,
                  )
                ],
              ));
        },
      ),
    ));
  }

  deletepajak(BaseMenuProdukController controller, DataPajakProduk arg) {
    Get.dialog(AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      title: header(
        title: 'Hapus pajak',
        icon: Icons.warning,
        icon_color: AppColor.warning,
      ),
      contentPadding: EdgeInsets.all(10),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12.0),
        ),
      ),
      content: Builder(
        builder: (context) {
          return Container(
              margin: EdgeInsets.all(10),
              width: context.res_width / 2.6,
              height: context.res_height / 4.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Hapus " + arg.nama_pajak! + '?',
                    style: AppFont.regular_bold(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  button_solid_custom(
                    onPressed: () async {
                      //Get.back();
                      await controller.deletepajak(uuid: arg.uuid);
                    },
                    child: Text(
                      'Hapus',
                      style: AppFont.regular_white_bold(),
                    ),
                    width: context.res_width,
                  ),
                  button_border_custom(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text(
                      'Batal',
                      style: AppFont.regular(),
                    ),
                    width: context.res_width,
                  )
                ],
              ));
        },
      ),
    ));
  }

  deleteukuran(BaseMenuProdukController controller, DataUkuranProduk arg) {
    Get.dialog(AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      title: header(
        title: 'Hapus ukuran',
        icon: Icons.warning,
        icon_color: AppColor.warning,
      ),
      contentPadding: EdgeInsets.all(10),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12.0),
        ),
      ),
      content: Builder(
        builder: (context) {
          return Container(
              margin: EdgeInsets.all(10),
              width: context.res_width / 2.6,
              height: context.res_height / 4.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Hapus " + arg.ukuran! + '?',
                    style: AppFont.regular_bold(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  button_solid_custom(
                    onPressed: () async {
                      //Get.back();
                      await controller.deleteukuran(uuid: arg.uuid);
                    },
                    child: Text(
                      'Hapus',
                      style: AppFont.regular_white_bold(),
                    ),
                    width: context.res_width,
                  ),
                  button_border_custom(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text(
                      'Batal',
                      style: AppFont.regular(),
                    ),
                    width: context.res_width,
                  )
                ],
              ));
        },
      ),
    ));
  }

  deleteProduk(BaseMenuProdukController controller, DataProduk arg) {
    Get.dialog(AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      title: header(
        title: 'Hapus Produk',
        icon: Icons.warning,
        icon_color: AppColor.warning,
      ),
      contentPadding: EdgeInsets.all(10),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12.0),
        ),
      ),
      content: Builder(
        builder: (context) {
          return Container(
              margin: EdgeInsets.all(10),
              width: context.res_width / 2.6,
              height: context.res_height / 4.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Hapus " + arg.nama_produk! + '?',
                    style: AppFont.regular_bold(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  button_solid_custom(
                    onPressed: () async {
                      //Get.back();
                      await controller.deleteProduk(uuid: arg.uuid);

                      //controller.deleteproduk(arg.id.toString());
                    },
                    child: Text(
                      'Hapus',
                      style: AppFont.regular_white_bold(),
                    ),
                    width: context.res_width,
                  ),
                  button_border_custom(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text(
                      'Batal',
                      style: AppFont.regular(),
                    ),
                    width: context.res_width,
                  )
                ],
              ));
        },
      ),
    ));
  }

  deleteSupllier(SupplierController controller, DataSupplier arg) {
    Get.dialog(AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      title: header(
        title: 'Hapus Supplier',
        icon: Icons.warning,
        icon_color: AppColor.warning,
      ),
      contentPadding: EdgeInsets.all(10),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12.0),
        ),
      ),
      content: Builder(
        builder: (context) {
          return Container(
              margin: EdgeInsets.all(10),
              width: context.res_width / 2.6,
              height: context.res_height / 4.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Hapus " + arg.nama_supplier! + '?',
                    style: AppFont.regular_bold(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  button_solid_custom(
                    onPressed: () async {
                      //Get.back();
                      await controller.deleteSupplier(uuid: arg.uuid);

                      //controller.deleteproduk(arg.id.toString());
                    },
                    child: Text(
                      'Hapus',
                      style: AppFont.regular_white_bold(),
                    ),
                    width: context.res_width,
                  ),
                  button_border_custom(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text(
                      'Batal',
                      style: AppFont.regular(),
                    ),
                    width: context.res_width,
                  )
                ],
              ));
        },
      ),
    ));
  }

  deleteKategoriPelanggan(
      KategoriPelangganController controller, DataKategoriPelanggan arg) {
    Get.dialog(AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      title: header(
        title: 'Hapus Kategori',
        icon: Icons.warning,
        icon_color: AppColor.warning,
      ),
      contentPadding: EdgeInsets.all(10),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12.0),
        ),
      ),
      content: Builder(
        builder: (context) {
          return Container(
              margin: EdgeInsets.all(10),
              width: context.res_width / 2.6,
              height: context.res_height / 4.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Hapus kategori " + arg.kategori! + '?',
                    style: AppFont.regular_bold(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  button_solid_custom(
                    onPressed: () async {
                      //Get.back();
                      await controller.deleteKategoriPelanggan(uuid: arg.uuid);

                      //controller.deleteproduk(arg.id.toString());
                    },
                    child: Text(
                      'Hapus',
                      style: AppFont.regular_white_bold(),
                    ),
                    width: context.res_width,
                  ),
                  button_border_custom(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text(
                      'Batal',
                      style: AppFont.regular(),
                    ),
                    width: context.res_width,
                  )
                ],
              ));
        },
      ),
    ));
  }

  deletePelanggan(PelangganController controller, DataPelanggan arg) {
    Get.dialog(AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      title: header(
        title: 'Hapus Pelanggan',
        icon: Icons.warning,
        icon_color: AppColor.warning,
      ),
      contentPadding: EdgeInsets.all(10),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12.0),
        ),
      ),
      content: Builder(
        builder: (context) {
          return Container(
              margin: EdgeInsets.all(10),
              width: context.res_width / 2.6,
              height: context.res_height / 4.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Hapus" + arg.namaPelanggan! + '?',
                    style: AppFont.regular_bold(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  button_solid_custom(
                    onPressed: () async {
                      //Get.back();
                      await controller.deletePelanggan(uuid: arg.uuid);

                      //controller.deleteproduk(arg.id.toString());
                    },
                    child: Text(
                      'Hapus',
                      style: AppFont.regular_white_bold(),
                    ),
                    width: context.res_width,
                  ),
                  button_border_custom(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text(
                      'Batal',
                      style: AppFont.regular(),
                    ),
                    width: context.res_width,
                  )
                ],
              ));
        },
      ),
    ));
  }

  deleteSubkategori(
      BaseMenuProdukController controller, DataSubKategoriProduk arg) {
    Get.dialog(AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      title: header(
        title: 'Hapus Sub kategori',
        icon: Icons.warning,
        icon_color: AppColor.warning,
      ),
      contentPadding: EdgeInsets.all(10),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12.0),
        ),
      ),
      content: Builder(
        builder: (context) {
          return Container(
              margin: EdgeInsets.all(10),
              width: context.res_width / 2.6,
              height: context.res_height / 4.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Hapus" + arg.namaSubkelompok! + '?',
                    style: AppFont.regular_bold(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  button_solid_custom(
                    onPressed: () async {
                      //Get.back();
                      await controller.deleteSubKategoriProduk(uuid: arg.uuid);

                      //controller.deleteproduk(arg.id.toString());
                    },
                    child: Text(
                      'Hapus',
                      style: AppFont.regular_white_bold(),
                    ),
                    width: context.res_width,
                  ),
                  button_border_custom(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text(
                      'Batal',
                      style: AppFont.regular(),
                    ),
                    width: context.res_width,
                  )
                ],
              ));
        },
      ),
    ));
  }

  void pilihSourceFoto(
      {Future<dynamic>? galery,
      Future<dynamic>? camera,
      Future<dynamic>? ikon}) {
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
                          galery;
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
                          camera;
                        },
                        child:
                            Text('Kamera', style: AppFont.regular_white_bold()),
                        width: context.res_width),
                  ),
                  Padding(
                    padding: AppPading.customBottomPadding(),
                    child: button_border_custom(
                        onPressed: () {
                          ikon;
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

  bukakasir() {
    Get.dialog(AlertDialog(
      surfaceTintColor: Colors.white,
      title: Text('qweq'),
      contentPadding: EdgeInsets.all(10),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12.0),
        ),
      ),
      content: Builder(
        builder: (context) {
          return Container(
              margin: EdgeInsets.all(10),
              width: context.res_width / 2.6,
              height: context.res_height / 2.6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Halo! sudah siap buka kasir?'),
                  SizedBox(
                    height: 10,
                  ),
                  button_solid_custom(
                    onPressed: () {},
                    child: Text('13qwe'),
                    width: context.res_width / 2.6,
                  )
                ],
              ));
        },
      ),
    ));
  }

  toursplash() {
    Get.dialog(AlertDialog(
      insetPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      surfaceTintColor: Colors.white,
      content: Builder(
        builder: (context) {
          var height = MediaQuery.of(context).size.height;
          var width = MediaQuery.of(context).size.width;

          return Container(
            width: width - 30,
            height: height - 200,
            child: IntroSlider(
              onDonePress: () {
                Get.back();
              },
              indicatorConfig: IndicatorConfig(
                  colorActiveIndicator: AppColor.primary,
                  colorIndicator: Colors.white),
              nextButtonStyle: ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll<Color>(Colors.white)),
              prevButtonStyle: ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll<Color>(Colors.white)),
              doneButtonStyle: ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll<Color>(Colors.white)),
              skipButtonStyle: ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll<Color>(Colors.white)),
              listContentConfig: [
                ContentConfig(
                  title: "qasir pintar",
                  styleTitle: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  pathImage: "assets/icons/splash.png",
                  description: "Selamat datang di qasir pintar!",
                  styleDescription: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  backgroundImage: "assets/images/bg.png",
                  backgroundColor: AppColor.primary,
                ),
                ContentConfig(
                  styleTitle: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  styleDescription: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  title: "Fitur lengkap",
                  pathImage: "assets/images/intro2.png",
                  description: "Nikmati berbagai fitur menarik qasir pintar",
                  backgroundImage: "assets/images/bg.png",
                  backgroundColor: Colors.white,
                ),
                ContentConfig(
                  styleTitle: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  styleDescription: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  title: "Lengkapi Data",
                  pathImage: "assets/images/list.png",
                  description: "Silahkan lengapi data untuk memulai transaksi",
                  backgroundImage: "assets/images/bg.png",
                  backgroundColor: Colors.white,
                ),
              ],
            ),
          );
        },
      ),
    ));
  }

  konfirmasibayar(
    List<DataProdukTemp> keranjang,
    PembayaranController controller,
  ) {
    Get.dialog(AlertDialog(
      insetPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      content: Builder(
        builder: (context) {
          var height = MediaQuery.of(context).size.height;
          var width = MediaQuery.of(context).size.width;

          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.white,
            ),
            padding: EdgeInsets.all(20),
            width: width - 30,
            height: height - 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                      color: AppColor.primary,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Text(
                      'Detail Penjualan',
                      style: AppFont.regular_white(),
                    ),
                  ),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text('sales person :', style: AppFont.regular()),
                //     // Text(controller.namakasir, style: font().reguler_bold),
                //   ],
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Pelanggan :', style: AppFont.regular()),
                    Text(
                      controller.namaPelanggan.value != ''
                          ? controller.namaPelanggan.value
                          : '-',
                      style: AppFont.regular_bold(),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total item : ', style: AppFont.regular()),
                    Text(
                      controller.totalItem.toString(),
                      style: AppFont.regular_bold(),
                    )
                  ],
                ),
                controller.displaydiskon.value == 0.0
                    ? Container()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Diskon : ', style: AppFont.regular()),
                          Text(
                            'Rp. ' +
                                AppFormat().numFormat(
                                    controller.jumlahdiskonkasir.value),
                            style: AppFont.regular_bold(),
                          )
                        ],
                      ),
                controller.promolistvalue == null
                    ? Container()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Promo : ', style: AppFont.regular()),
                          Text(
                            controller.namaPromo.value,
                            style: AppFont.regular_bold(),
                          )
                        ],
                      ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Subtotal : ', style: AppFont.regular()),
                    Text(
                      'Rp. ' + AppFormat().numFormat(controller.subtotal.value),
                      style: AppFont.regular_bold(),
                    )
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total : ', style: AppFont.regular()),
                    Text(
                      'Rp. ' + AppFormat().numFormat(controller.total.value),
                      style: AppFont.regular_bold(),
                    ),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Pembayaran: ', style: AppFont.regular()),
                    Text(
                      'Rp. ' +
                          AppFormat().numFormat(controller.bayarvalue.value),
                      style: AppFont.regular_bold(),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Kembalian : ', style: AppFont.regular()),
                    Text(
                        style: AppFont.regular_bold(),
                        'Rp. ' +
                            AppFormat().numFormat((controller.bayarvalue.value -
                                controller.total.value))),
                  ],
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text('Metode bayar :', style: AppFont.regular()),
                //     // Text(
                //     //     controller.groupindex.value == 1
                //     //         ? 'Tunai'
                //     //         : controller.groupindex.value == 2
                //     //         ? 'Hutang'
                //     //         : '-',
                //     //     style: font().reguler_bold),
                //   ],
                // ),
                // Container(
                //   width: double.infinity,
                //   padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                //   color: color_template().primary,
                //   child: Text(
                //     'Kembalian',
                //     style: font().header,
                //   ),
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    button_border_custom(
                      onPressed: () {
                        //Navigator.of(context).pop();
                        Get.back();
                        print('back');
                      },
                      child: Text(
                        'Batal',
                        style: TextStyle(color: Colors.black),
                      ),
                      width: 100,
                    ),
                    button_solid_custom(
                      onPressed: () async {
                        print('bayar local------------------------------->');
                        await controller.pembayaran();
                      },
                      child: Text(
                        'bayar',
                        style: TextStyle(color: Colors.white),
                      ),
                      width: 100,
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    ));
  }

  berhasilbayar(
    PembayaranController controller,
  ) {
    Get.dialog(
        barrierDismissible: false,
        AlertDialog(
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          content: Builder(
            builder: (context) {
              var height = MediaQuery.of(context).size.height;
              var width = MediaQuery.of(context).size.width;

              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.white,
                ),
                padding: EdgeInsets.all(20),
                width: width - 30,
                height: height - 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 100,
                      color: Colors.green,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Transaksi Berhasil!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Pembayaran berhasil dilakukan.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Spacer(), // This will push the buttons to the bottom
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        button_border_custom(
                            onPressed: () {}, child: Text('Share'), width: 150),
                        button_border_custom(
                            onPressed: () {
                              controller.printstruk();
                            },
                            child: Text('Print struk'),
                            width: 150),
                      ],
                    ),
                    button_border_custom(
                      onPressed: () {
                        Get.offAllNamed("/basemenu");
                      },
                      child: Text('Selesai'),
                      width: context.res_width,
                    ),
                    SizedBox(height: 20), // Add some space at the bottom
                  ],
                ),
              );
            },
          ),
        ));
  }

  karyawanLogin(KasirController controller) {
    Get.dialog(AlertDialog(
      insetPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      content: Builder(
        builder: (context) {
          var height = MediaQuery.of(context).size.height;
          var width = MediaQuery.of(context).size.width;

          return Column(
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
                        DropdownButtonFormField2(
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
                          hint:
                              Text('Pilih Karyawan', style: AppFont.regular()),
                          value: controller.karyawanvalue,
                          items: controller.karyawanlist.map((x) {
                            return DropdownMenuItem(
                              child: Text(x.nama_karyawan!),
                              value: x.uuid,
                            );
                          }).toList(),
                          onChanged: (val) {
                            controller.karyawanvalue = val!.toString();
                            print(controller.karyawanvalue);
                          },
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
                        key: controller.formKey,
                        child: Column(
                          children: [
                            PinCodeTextField(
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
                              animationDuration: Duration(milliseconds: 300),
                              //backgroundColor: Colors.blue.shade50,
                              controller: controller.verifikasi_kode.value,
                              onCompleted: (v) {
                                print("Completed");
                              },
                              onChanged: (value) {
                                print('verifikasi code -->' + value);
                                print(controller.verifikasi_kode.value.text);
                              },
                              beforeTextPaste: (text) {
                                print("Allowing to paste $text");
                                //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                return true;
                              },
                              appContext: context,
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              width: 350,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: AppColor.secondary),
                                onPressed: () {
                                  controller.loginKaryawan(
                                      controller.karyawanvalue,
                                      controller.verifikasi_kode.value.text);
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
          );
        },
      ),
    ));
  }
}
